package coconut.gmaps;

import coconut.data.*;
import google.maps.Event;
import google.maps.LatLng;

using tink.CoreApi;

private typedef Data = {
	@:optional var className(default, never):String;
	@:optional var style(default, never):String;
	var defaultCenter(default, never):LatLngLiteral;
	var defaultZoom(default, never):Float;
	@:optional var markers(default, never):Value<List<Marker>>;
}

@:forward
abstract MarkerRef({ref:google.maps.Marker, binding:CallbackLink}) from {ref:google.maps.Marker, binding:CallbackLink} {
	public inline function new() {
		this = {ref: new google.maps.Marker(), binding: null}
	}
	
	public function reset() {
		Event.clearInstanceListeners(this.ref);
		this.ref.setMap(null);
		
		this.binding.dissolve();
		this.binding = null;
	}
}

class GoogleMap extends vdom.Foreign {
	
	var data:Data;
	var map:google.maps.Map;
	var markers:Array<MarkerRef> = [];
	var binding:CallbackLink = null;
	
	public function new(data:Data) {
		super(null);
		this.data = data;
	}
	
	function setupBindings() {
		if(data.markers != null) {
			binding = binding & data.markers.bind(null, function(v) {
				var i = 0;
				for(m in v) {
					var marker = 
						if(markers.length > i) {
							var reused = markers[i];
							reused.reset();
							reused;
						} else 
							markers[i] = new MarkerRef();
					
					var ref = marker.ref;
					var obs = m.observables;
					
					function listen(name:String, f) {
						Event.clearListeners(ref, name);
						if(f != null) Event.addListener(ref, name, f);
					}
					
					marker.binding = [
						obs.onClick.bind(listen.bind('click')),
						obs.onDoubleClick.bind(listen.bind('dblclick')),
						obs.onRightClick.bind(listen.bind('rightclick')),
						obs.onMouseDown.bind(listen.bind('mousedown')),
						obs.onMouseOut.bind(listen.bind('mouseout')),
						obs.onMouseUp.bind(listen.bind('mouseup')),
						obs.onMouseOver.bind(listen.bind('mouseover')),
						obs.onDragStart.bind(listen.bind('dragstart')),
						obs.onDrag.bind(listen.bind('drag')),
						obs.onDragEnd.bind(listen.bind('dragend')),
						obs.clickable.bind(ref.setClickable),
						obs.draggable.bind(ref.setDraggable),
						obs.position.bind(ref.setPosition),
					];
						
					ref.setMap(map);
					
					i++;
				}
				
				for(j in i...markers.length) {
					markers[j].reset();
				}
			});
		} else {
			for(marker in markers) {
				marker.reset();
			}
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