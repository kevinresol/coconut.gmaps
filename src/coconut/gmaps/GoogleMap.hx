package coconut.gmaps;

import coconut.data.*;
import google.maps.Event;
import google.maps.LatLng;

using coconut.gmaps.Marker;
using coconut.gmaps.Polygon;
using coconut.gmaps.InfoWindow;
using coconut.gmaps.DrawingManager;
using tink.CoreApi;
using Lambda;

private typedef Data = {
	@:optional var className(default, never):String;
	@:optional var style(default, never):String;
	var defaultCenter(default, never):LatLngLiteral;
	var defaultZoom(default, never):Float;
	@:optional var children(default, never):Array<Object>;
}

private class Ref<T, Data> {
	public var ref(default, null):T;
	public var binding:CallbackLink;
	public var data:Data;
	var doClose:T->Void;
	var doReset:T->Void;
	
	public function new(ref, doClose, ?doReset) {
		this.ref = ref;
		this.doClose = doClose;
		this.doReset = doReset;
	}
	
	// this function makes sure there is at most only one listener for an event
	public function listen(name:String, f) {
		Event.clearListeners(this.ref, name);
		if(f != null) Event.addListener(this.ref, name, f);
	}
	
	public function reset(close = true) {
		Event.clearInstanceListeners(this.ref);
		if(doReset != null) doReset(ref); // type-specific reset code
		
		if(close) doClose(ref);
		
		this.binding.dissolve();
		this.binding = null;
	}
}

@:forward
abstract MarkerRef(Ref<google.maps.Marker, Marker>) {
	public inline function new() {
		this = new Ref(
			new google.maps.Marker(),
			function(v) v.setMap(null)
		);
	}
	
	public inline function setup(map:google.maps.Map, data:MarkerData) {
		this.listen('click', data.onClick);
		this.listen('dblclick', data.onDoubleClick);
		this.listen('rightclick', data.onRightClick);
		this.listen('mousedown', data.onMouseDown);
		this.listen('mouseout', data.onMouseOut);
		this.listen('mouseup', data.onMouseUp);
		this.listen('mouseover', data.onMouseOver);
		this.listen('dragstart', data.onDragStart);
		this.listen('drag', data.onDrag);
		this.listen('dragend', data.onDragEnd);
		this.ref.setAnimation(data.animation);
		this.ref.setClickable(data.clickable);
		this.ref.setCursor(data.cursor);
		this.ref.setDraggable(data.draggable);
		this.ref.setIcon(data.icon);
		this.ref.setLabel(data.label);
		this.ref.setOpacity(data.opacity);
		this.ref.setPosition(data.position);
		this.ref.setShape(data.shape.toGoogle());
		this.ref.setTitle(data.title);
		this.ref.setVisible(data.visible);
		this.ref.setZIndex(data.zIndex);
		this.ref.setMap(map);
	}
}

@:forward
abstract PolygonRef(Ref<google.maps.Polygon, Polygon>) {
	public inline function new() {
		this = new Ref(
			new google.maps.Polygon(),
			function(v) v.setMap(null)
		);
	}
	
	public inline function setup(map:google.maps.Map, data:PolygonData) {
		this.listen('click', data.onClick);
		this.listen('dblclick', data.onDoubleClick);
		this.listen('rightclick', data.onRightClick);
		this.listen('mousedown', data.onMouseDown);
		this.listen('mouseout', data.onMouseOut);
		this.listen('mouseup', data.onMouseUp);
		this.listen('mouseover', data.onMouseOver);
		this.listen('dragstart', data.onDragStart);
		this.listen('drag', data.onDrag);
		this.listen('dragend', data.onDragEnd);
		this.ref.setDraggable(data.draggable);
		this.ref.setEditable(data.editable);
		this.ref.setPaths([for(v in data.paths) v.toArray()]);
		this.ref.setMap(map);
	}
}

@:forward
abstract InfoWindowRef(Ref<google.maps.InfoWindow, InfoWindow>) {
	public inline function new() {
		this = new Ref(
			new google.maps.InfoWindow(),
			function(v) v.close()
		);
	}
	
	public inline function setup(map, anchor, data:InfoWindowData) {
		this.listen('closeclick', data.onCloseClick);
		this.ref.setContent(data.children.toElement());
		this.ref.setPosition(data.position);
		this.ref.setZIndex(data.zIndex);
		this.ref.open(map, anchor);
	}
}

@:forward
abstract DrawingManagerRef(Ref<google.maps.drawing.DrawingManager, DrawingManager>) {
	public inline function new() {
		this = new Ref(
			new google.maps.drawing.DrawingManager(),
			function(v) v.setMap(null)
		);
	}
	
	public inline function setup(map, data:DrawingManagerData) {
		this.listen('circlecomplete', function(v) {if(data.onCircleComplete != null) data.onCircleComplete(v); v.setMap(null);});
		this.listen('markercomplete', function(v) {if(data.onMarkerComplete != null) data.onMarkerComplete(v); v.setMap(null);});
		this.listen('polygoncomplete', function(v) {if(data.onPolygonComplete != null) data.onPolygonComplete(v); v.setMap(null);});
		this.listen('polylinecomplete', function(v) {if(data.onPolylineComplete != null) data.onPolylineComplete(v); v.setMap(null);});
		this.listen('rectanglecomplete', function(v) {if(data.onRectangleComplete != null) data.onRectangleComplete(v); v.setMap(null);});
		// this.listen('overlaycomplete', data.onOverlayComplete);
		
		this.ref.setOptions({
			drawingControl: data.drawingControl,	
			drawingControlOptions: data.drawingControlOptions,	
			map: map,
			// circleOptions: data.circleOptions,	
			// markerOptions: data.markerOptions,	
			// polygonOptions: data.polygonOptions,	
			// polylineOptions: data.polylineOptions,	
			// rectangleOptions: data.rectangleOptions,
		});
		
		if(this.ref.getDrawingMode() != data.drawingMode)
			this.ref.setDrawingMode(data.drawingMode);
	}
}

private typedef Context = {
	var markers:Array<MarkerRef>;
	var polygons:Array<PolygonRef>;
	var infoWindows:Array<InfoWindowRef>;
	var drawingManager:DrawingManagerRef;
}

class GoogleMap extends vdom.Foreign {
	
	var data:Data;
	var map:google.maps.Map;
	var ctx:Context;
	
	public function new(data:Data) {
		super(null);
		this.data = data;
	}
	
	function refresh() {
		var markers = [];
		var polygons = [];
		var infoWindows = [];
		var drawingManager = null;
		if(data.children != null) for(o in data.children) switch o.toType() {
			case OMarker(v):
				markers.push(v);
				if(v.data.children != null) for(o in v.data.children) switch o.toType() {
					case OInfoWindow(infoWindow):
						infoWindows.push({window: infoWindow, anchor: v});
					case _: // TODO
				}
			case OPolygon(v):
				polygons.push(v);
			case OInfoWindow(v):
				infoWindows.push({window: v, anchor: null});
			case ODrawingManager(v):
				drawingManager = v;
		}
		refreshMarkers(markers);
		refreshPolygons(polygons);
		refreshInfoWindows(infoWindows);
		refreshDrawingManager(drawingManager);
	}
	
	inline function refreshMarkers(data:Array<Marker>) {
		var i = 0;
		for(v in data) {
			var ref = 
				if(ctx.markers.length > i) {
					var reused = ctx.markers[i];
					reused.reset(false);
					reused;
				} else 
					ctx.markers[i] = new MarkerRef();
					
			ref.data = v;
			ref.setup(map, v.data);
			i++;
		}
		
		// clean up unused marker instances
		for(j in i...ctx.markers.length) ctx.markers[j].reset();
	}
	
	inline function refreshPolygons(data:Array<Polygon>) {
		var i = 0;
		for(v in data) {
			var ref = 
				if(ctx.polygons.length > i) {
					var reused = ctx.polygons[i];
					reused.reset(false);
					reused;
				} else
					ctx.polygons[i] = new PolygonRef();
				
			ref.data = v;
			ref.setup(map, v.data);
			i++;
		}
		
		// clean up unused polygon instances
		for(j in i...ctx.polygons.length) ctx.polygons[j].reset();
	}
	
	
	inline function refreshInfoWindows(data:Array<{window:InfoWindow, anchor:Marker}>) {
		var i = 0;
		for(v in data) {
			var ref = 
				if(ctx.infoWindows.length > i) {
					var reused = ctx.infoWindows[i];
					reused.reset(false);
					reused;
				} else
					ctx.infoWindows[i] = new InfoWindowRef();
				
			ref.data = v.window;
			var anchor = ctx.markers.find(function(m) return m.data == v.anchor);
			ref.setup(map, anchor == null ? null : anchor.ref, v.window.data);
			
			i++;
		}
		
		// clean up unused infoWindow instances
		for(j in i...ctx.infoWindows.length) ctx.infoWindows[j].reset();
	}
	
	inline function refreshDrawingManager(data:DrawingManager) {
		if(data != null) {
			if(ctx.drawingManager == null)
				ctx.drawingManager = new DrawingManagerRef();
			else
				ctx.drawingManager.reset(false);
			
			ctx.drawingManager.data = data;
			ctx.drawingManager.setup(map, data.data);
			
		} else {
			if(ctx.drawingManager != null) ctx.drawingManager.reset();
		}
	}
	
	override function init() {
		element = js.Browser.document.createDivElement();
		element.className = data.className;
		element.style.cssText = data.style;
		
		map = new google.maps.Map(element, {
			center: data.defaultCenter,
			zoom: data.defaultZoom,
		});
		
		ctx = {
			markers: [],
			polygons: [],
			infoWindows: [],
			drawingManager: null,
		}
		
		refresh();
		
		return element;
	}
	
	override function update(prev:{}, e) {
		switch Std.instance(prev, GoogleMap) {
			case null:
			case that:
				element = that.element;
				map = that.map;
				ctx = that.ctx;
				that.destroy();
				refresh();
		}
		
		return element;
	}
	
	override function destroy() {
		data = null;
		element = null;
		map = null;
		ctx = null;
	}
}