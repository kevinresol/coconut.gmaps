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
	
	public function reset() {
		Event.clearInstanceListeners(this.ref);
		close(ref);
		
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

class GoogleMap extends vdom.Foreign {
	
	var data:Data;
	var map:google.maps.Map;
	var markers:Array<MarkerRef> = [];
	var polygons:Array<PolygonRef> = [];
	var infoWindows:Array<InfoWindowRef> = [];
	var binding:CallbackLink = null;
	
	public function new(data:Data) {
		super(null);
		this.data = data;
	}
	
	function refresh() {
		var markers = [];
		var polygons = [];
		var infoWindows = [];
		if(data.children != null) for(o in data.children) switch o.toType() {
			case OMarker(marker):
				markers.push(marker);
				if(marker.data.children != null) for(o in marker.data.children) switch o.toType() {
					case OInfoWindow(infoWindow):
						infoWindows.push({window: infoWindow, anchor: marker});
					case _: // TODO
				}
			case OPolygon(polygon):
				polygons.push(polygon);
			case OInfoWindow(infoWindow):
				infoWindows.push({window: infoWindow, anchor: null});
		}
		refreshMarkers(markers);
		refreshPolygons(polygons);
		refreshInfoWindows(infoWindows);
		
		trace(markers.length, infoWindows.length);
	}
	
	inline function refreshMarkers(data:Array<Marker>) {
		var i = 0;
		
		for(v in data) {
			var ref = 
				if(markers.length > i) {
					var reused = markers[i];
					reused.reset();
					reused;
				} else 
					markers[i] = new MarkerRef();
					
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
		for(j in i...markers.length) markers[j].reset();
	}
	
	inline function refreshPolygons(data:Array<Polygon>) {
		var i = 0;
		
		for(v in data) {
			var ref = 
				if(polygons.length > i) {
					var reused = polygons[i];
					reused.reset();
					reused;
				} else
					polygons[i] = new PolygonRef();
				
			ref.data = v;
			var data = v.data;
			var polygon = ref.ref;
			
			
			ref.listen.bind('click', data.onClick);
			ref.listen.bind('dblclick', data.onDoubleClick);
			ref.listen.bind('rightclick', data.onRightClick);
			ref.listen.bind('mousedown', data.onMouseDown);
			ref.listen.bind('mouseout', data.onMouseOut);
			ref.listen.bind('mouseup', data.onMouseUp);
			ref.listen.bind('mouseover', data.onMouseOver);
			ref.listen.bind('dragstart', data.onDragStart);
			ref.listen.bind('drag', data.onDrag);
			ref.listen.bind('dragend', data.onDragEnd);
			polygon.setDraggable(data.draggable);
			polygon.setEditable(data.editable);
			polygon.setPaths([for(v in data.paths) v.toArray()]);
			polygon.setVisible(data.visible);
				
			// enable the polygon
			polygon.setMap(map);
			
			i++;
		}
		
		// clean up unused polygon instances
		for(j in i...polygons.length) polygons[j].reset();
	}
	
	
	inline function refreshInfoWindows(data:Array<{window:InfoWindow, anchor:Marker}>) {
		var i = 0;
		
		for(v in data) {
			var ref = 
				if(infoWindows.length > i) {
					var reused = infoWindows[i];
					reused.reset();
					reused;
				} else
					infoWindows[i] = new InfoWindowRef();
				
			ref.data = v.window;
			var data = v.window.data;
			var infoWindow = ref.ref;
			
			
			ref.listen.bind('closeclick', data.onCloseClick);
			infoWindow.setContent(data.children.toElement());
			infoWindow.setPosition(data.position);
			infoWindow.setZIndex(data.zIndex);
				
			// enable the infoWindow
			var anchor = markers.find(function(m) return m.data == v.anchor);
			infoWindow.open(map, anchor == null ? null : anchor.ref);
			
			i++;
		}
		
		// clean up unused infoWindow instances
		for(j in i...infoWindows.length) infoWindows[j].reset();
	}
	
	override function init() {
		element = js.Browser.document.createDivElement();
		element.className = data.className;
		element.style.cssText = data.style;
		
		map = new google.maps.Map(element, {
			center: data.defaultCenter,
			zoom: data.defaultZoom,
		});
		
		refresh();
		
		return element;
	}
	
	override function update(prev:{}, e) {
		switch Std.instance(prev, GoogleMap) {
			case null:
			case that:
				element = that.element;
				map = that.map;
				markers = that.markers;
				polygons = that.polygons;
				infoWindows = that.infoWindows;
				that.destroy();
				refresh();
		}
		
		return element;
	}
	
	override function destroy() {
		data = null;
		element = null;
		map = null;
		markers = null;
		polygons = null;
		infoWindows = null;
		binding.dissolve();
	}
}