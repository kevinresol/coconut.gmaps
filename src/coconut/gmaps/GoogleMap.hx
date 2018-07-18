package coconut.gmaps;

import coconut.data.*;
import google.maps.Event;
import google.maps.LatLng;

using coconut.gmaps.Marker;
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
	var close:T->Void;
	
	public function new(ref, close) {
		this.ref = ref;
		this.close = close;
	}
	
	// this function makes sure there is at most only one listener for an event
	public function listen(name:String, f) {
		Event.clearListeners(this.ref, name);
		if(f != null) Event.addListener(this.ref, name, f);
	}
	
	public function reset(close = true) {
		Event.clearInstanceListeners(this.ref);
		if(close) this.close(ref);
		
		this.binding.dissolve();
		this.binding = null;
	}
}

@:forward
abstract MarkerRef(Ref<google.maps.Marker, Marker>) {
	public inline function new() {
		this = new Ref(new google.maps.Marker(), function(v) v.setMap(null));
	}
}

@:forward
abstract PolygonRef(Ref<google.maps.Polygon, Polygon>) {
	public inline function new() {
		this = new Ref(new google.maps.Polygon(), function(v) v.setMap(null));
	}
}

@:forward
abstract InfoWindowRef(Ref<google.maps.InfoWindow, InfoWindow>) {
	public inline function new() {
		this = new Ref(new google.maps.InfoWindow(), function(v) v.close());
	}
}

@:forward
abstract DrawingManagerRef(Ref<google.maps.drawing.DrawingManager, DrawingManager>) {
	public inline function new() {
		this = new Ref(new google.maps.drawing.DrawingManager(), function(v) v.setMap(null));
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
			var data = v.data;
			var marker = ref.ref;
			
			ref.listen('click', data.onClick);
			ref.listen('dblclick', data.onDoubleClick);
			ref.listen('rightclick', data.onRightClick);
			ref.listen('mousedown', data.onMouseDown);
			ref.listen('mouseout', data.onMouseOut);
			ref.listen('mouseup', data.onMouseUp);
			ref.listen('mouseover', data.onMouseOver);
			ref.listen('dragstart', data.onDragStart);
			ref.listen('drag', data.onDrag);
			ref.listen('dragend', data.onDragEnd);
			marker.setAnimation(data.animation);
			marker.setClickable(data.clickable);
			marker.setCursor(data.cursor);
			marker.setDraggable(data.draggable);
			marker.setIcon(data.icon);
			marker.setLabel(data.label);
			marker.setOpacity(data.opacity);
			marker.setPosition(data.position);
			marker.setShape(data.shape.toGoogle());
			marker.setTitle(data.title);
			marker.setVisible(data.visible);
			marker.setZIndex(data.zIndex);
				
			// enable the marker
			marker.setMap(map);
			
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
			var data = v.data;
			var polygon = ref.ref;
			
			
			ref.listen('click', data.onClick);
			ref.listen('dblclick', data.onDoubleClick);
			ref.listen('rightclick', data.onRightClick);
			ref.listen('mousedown', data.onMouseDown);
			ref.listen('mouseout', data.onMouseOut);
			ref.listen('mouseup', data.onMouseUp);
			ref.listen('mouseover', data.onMouseOver);
			ref.listen('dragstart', data.onDragStart);
			ref.listen('drag', data.onDrag);
			ref.listen('dragend', data.onDragEnd);
			polygon.setDraggable(data.draggable);
			polygon.setEditable(data.editable);
			polygon.setPaths([for(v in data.paths) v.toArray()]);
			polygon.setVisible(data.visible);
				
			// enable the polygon
			polygon.setMap(map);
			
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
			var data = v.window.data;
			var infoWindow = ref.ref;
			
			
			ref.listen('closeclick', data.onCloseClick);
			infoWindow.setContent(data.children.toElement());
			infoWindow.setPosition(data.position);
			infoWindow.setZIndex(data.zIndex);
				
			// enable the infoWindow
			var anchor = ctx.markers.find(function(m) return m.data == v.anchor);
			infoWindow.open(map, anchor == null ? null : anchor.ref);
			
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
			
			// sorry for the shadowing, just wanna be consistent with other functions
			var ref = ctx.drawingManager;
			ref.data = data;
			var drawingManager = ctx.drawingManager.ref;
			var data = data.data;
			
			ref.listen('circlecomplete', function(v) {if(data.onCircleComplete != null) data.onCircleComplete(v); v.setMap(null);});
			ref.listen('markercomplete', function(v) {if(data.onMarkerComplete != null) data.onMarkerComplete(v); v.setMap(null);});
			ref.listen('polygoncomplete', function(v) {if(data.onPolygonComplete != null) data.onPolygonComplete(v); v.setMap(null);});
			ref.listen('polylinecomplete', function(v) {if(data.onPolylineComplete != null) data.onPolylineComplete(v); v.setMap(null);});
			ref.listen('rectanglecomplete', function(v) {if(data.onRectangleComplete != null) data.onRectangleComplete(v); v.setMap(null);});
			// ref.listen('overlaycomplete', data.onOverlayComplete);
			
			drawingManager.setOptions({
				drawingControl: data.drawingControl,	
				drawingControlOptions: data.drawingControlOptions,	
				map: map,
				// circleOptions: data.circleOptions,	
				// markerOptions: data.markerOptions,	
				// polygonOptions: data.polygonOptions,	
				// polylineOptions: data.polylineOptions,	
				// rectangleOptions: data.rectangleOptions,
			});
			
			if(drawingManager.getDrawingMode() != data.drawingMode)
				drawingManager.setDrawingMode(data.drawingMode);
			
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