package coconut.gmaps;

import coconut.data.*;
import google.maps.LatLng;

using tink.CoreApi;

private typedef Data = {
	var defaultCenter(default, never):LatLngLiteral;
	var defaultZoom(default, never):Float;
	@:optional var markers(default, never):Value<List<Marker>>;
}

class GoogleMap extends vdom.Foreign {
	
	var data:Data;
	var map:google.maps.Map;
	var markers:Array<google.maps.Marker> = [];
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
							google.maps.Event.clearInstanceListeners(reused);
							reused;
						} else 
							markers[i] = new google.maps.Marker();
					
					if(m.onClick != null) marker.addListener('click', m.onClick);
					
					marker.setPosition(m.position);
					marker.setMap(map);
					
					i++;
				}
				
				for(j in i...markers.length)
					markers[j].setMap(null);
			});
		} else {
			for(marker in markers) {
				google.maps.Event.clearInstanceListeners(marker);
				marker.setMap(null);
			}
		}
	}
	
	override function init() {
		element = js.Browser.document.createDivElement();
		element.style.width = '100%';
		element.style.height = '100%';
		
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