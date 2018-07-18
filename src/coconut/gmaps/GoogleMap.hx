package coconut.gmaps;

import coconut.data.*;
import google.maps.Event;
import google.maps.LatLng;

using coconut.gmaps.Marker;
using tink.CoreApi;

private typedef Data = {
	@:optional var className(default, never):String;
	@:optional var style(default, never):String;
	var defaultCenter(default, never):LatLngLiteral;
	var defaultZoom(default, never):Float;
	@:optional var markers(default, never):Value<List<Marker>>;
	@:optional var polygons(default, never):Value<List<Polygon>>;
	@:optional var infoWindows(default, never):Value<List<InfoWindow>>;
}

private class Ref<T> {
	public var ref(default, null):T;
	public var binding:CallbackLink;
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
abstract MarkerRef(Ref<google.maps.Marker>) {
	public inline function new() {
		this = new Ref(new google.maps.Marker(), function(v) v.setMap(null));
	}
}

@:forward
abstract PolygonRef(Ref<google.maps.Polygon>) {
	public inline function new() {
		this = new Ref(new google.maps.Polygon(), function(v) v.setMap(null));
	}
}

@:forward
abstract InfoWindowRef(Ref<google.maps.InfoWindow>) {
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
	
	function setupBindings() {
		setupMarkerBindings();
		setupPolygonBindings();
		setupInfoWindowBindings();
	}
	
	inline function setupMarkerBindings() {
		if(data.markers != null) {
			binding = binding & data.markers.bind(null, function(v) {
				var i = 0;
				for(m in v) {
					// grab a marker ref
					var ref = 
						if(markers.length > i) {
							var reused = markers[i];
							reused.reset();
							reused;
						} else 
							markers[i] = new MarkerRef();
					
					var marker = ref.ref;
					var obs = m.observables;
					
					// refresh marker when data changes
					ref.binding = [
						obs.onClick.bind(ref.listen.bind('click')),
						obs.onDoubleClick.bind(ref.listen.bind('dblclick')),
						obs.onRightClick.bind(ref.listen.bind('rightclick')),
						obs.onMouseDown.bind(ref.listen.bind('mousedown')),
						obs.onMouseOut.bind(ref.listen.bind('mouseout')),
						obs.onMouseUp.bind(ref.listen.bind('mouseup')),
						obs.onMouseOver.bind(ref.listen.bind('mouseover')),
						obs.onDragStart.bind(ref.listen.bind('dragstart')),
						obs.onDrag.bind(ref.listen.bind('drag')),
						obs.onDragEnd.bind(ref.listen.bind('dragend')),
						obs.animation.bind(marker.setAnimation),
						obs.clickable.bind(marker.setClickable),
						obs.cursor.bind(marker.setCursor),
						obs.draggable.bind(marker.setDraggable),
						obs.icon.bind(marker.setIcon),
						obs.label.bind(marker.setLabel),
						obs.opacity.bind(marker.setOpacity),
						obs.position.bind(marker.setPosition),
						obs.shape.bind(function(v) marker.setShape(v.toGoogle())),
						obs.title.bind(marker.setTitle),
						obs.visible.bind(marker.setVisible),
						obs.zIndex.bind(marker.setZIndex),
					];
					
					// enable the marker
					marker.setMap(map);
					
					i++;
				}
				
				// clean up unused marker instances
				for(j in i...markers.length) markers[j].reset();
			});
		} else {
			// clean up all marker instances
			for(marker in markers) marker.reset();
		}
	}
	
	inline function setupPolygonBindings() {
		if(data.polygons != null) {
			binding = binding & data.polygons.bind(null, function(v) {
				var i = 0;
				for(m in v) {
					// grab a polygon ref
					var ref = 
						if(polygons.length > i) {
							var reused = polygons[i];
							reused.reset();
							reused;
						} else 
							polygons[i] = new PolygonRef();
					
					var polygon = ref.ref;
					var obs = m.observables;
					
					// refresh polygon when data changes
					ref.binding = [
						obs.onClick.bind(ref.listen.bind('click')),
						obs.onDoubleClick.bind(ref.listen.bind('dblclick')),
						obs.onRightClick.bind(ref.listen.bind('rightclick')),
						obs.onMouseDown.bind(ref.listen.bind('mousedown')),
						obs.onMouseOut.bind(ref.listen.bind('mouseout')),
						obs.onMouseUp.bind(ref.listen.bind('mouseup')),
						obs.onMouseOver.bind(ref.listen.bind('mouseover')),
						obs.onDragStart.bind(ref.listen.bind('dragstart')),
						obs.onDrag.bind(ref.listen.bind('drag')),
						obs.onDragEnd.bind(ref.listen.bind('dragend')),
						obs.draggable.bind(polygon.setDraggable),
						obs.editable.bind(polygon.setEditable),
						obs.paths.bind(null, function(v) polygon.setPaths([for(v in v) v.toArray()])),
						obs.visible.bind(polygon.setVisible),
					];
					
					// enable the polygon
					polygon.setMap(map);
					
					i++;
				}
				
				// clean up unused polygon instances
				for(j in i...polygons.length) polygons[j].reset();
			});
		} else {
			// clean up all polygon instances
			for(polygon in polygons) polygon.reset();
		}
	}
	
	inline function setupInfoWindowBindings() {
		if(data.infoWindows != null) {
			binding = binding & data.infoWindows.bind(null, function(v) {
				var i = 0;
				for(m in v) {
					// grab a infoWindow ref
					var ref = 
						if(infoWindows.length > i) {
							var reused = infoWindows[i];
							reused.reset();
							reused;
						} else 
							infoWindows[i] = new InfoWindowRef();
					
					var infoWindow = ref.ref;
					var obs = m.observables;
					
					// refresh infoWindow when data changes
					ref.binding = [
						obs.onCloseClick.bind(ref.listen.bind('closeclick')),
						obs.content.bind(null, function(v) infoWindow.setContent(v.toElement())),
						obs.position.bind(infoWindow.setPosition),
						obs.zIndex.bind(infoWindow.setZIndex),
					];
					
					// enable the infoWindow
					infoWindow.open(map);
					
					i++;
				}
				
				// clean up unused infoWindow instances
				for(j in i...infoWindows.length) infoWindows[j].reset();
			});
		} else {
			// clean up all infoWindow instances
			for(infoWindow in infoWindows) infoWindow.reset();
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
		
		setupBindings();
		
		return element;
	}
	
	override function update(prev:{}, e) {
		switch Std.instance(prev, GoogleMap) {
			case null:
			case that:
				element = that.element;
				map = that.map;
				markers = that.markers;
				that.destroy();
				setupBindings();
		}
		
		return element;
	}
	
	override function destroy() {
		data = null;
		element = null;
		map = null;
		markers = null;
		binding.dissolve();
	}
}