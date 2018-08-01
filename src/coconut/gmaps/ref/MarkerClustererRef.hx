package coconut.gmaps.ref;

import google.maps.*;
import coconut.gmaps.MarkerClusterer;

@:forward
abstract MarkerClustererRef(RefBase<google.maps.markerclustererplus.MarkerClusterer, MarkerClustererData>) {
	public inline function new() {
		this = new RefBase(
			new google.maps.markerclustererplus.MarkerClusterer(null),
			function(v) {
				clearMarkers(v);
				v.setMap(null);
			}
		);
	}
	
	public inline function setup(map, markers:Array<Marker>, data:MarkerClustererData) {
		trace('number of markers to cluster = ' + markers.length);
		clearMarkers(this.ref);
		
		this.listen('click', data.onClick);
		this.ref.addMarkers(markers);
		this.ref.setZoomOnClick(data.zoomOnClick);
		
		// js.Browser.console.log(this.ref);
		
		// if(anchor == null && data.position != this.ref.getPosition())
		// 	this.ref.setPosition(data.position);
		
		if(this.ref.getMap() != map)
			this.ref.setMap(map);
			
		this.data = data;
	}
	
	// the library calls marker.setMap(null) when clearing
	// this is a hack to retain keep the map reference as-is
	function clearMarkers(clusterer:google.maps.markerclustererplus.MarkerClusterer) {
		var restoreMap = [for(m in this.ref.getMarkers()) {
			var map = m.getMap();
			function() m.setMap(map);
		}];
		clusterer.clearMarkers();
		for(f in restoreMap) f();
	}
}