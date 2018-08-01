package coconut.gmaps.ref;

import google.maps.*;
import coconut.gmaps.MarkerClusterer;

@:forward
abstract MarkerClustererRef(RefBase<google.maps.markerclustererplus.MarkerClusterer, MarkerClustererData>) {
	public inline function new() {
		this = new RefBase(
			new google.maps.markerclustererplus.MarkerClusterer(null),
			function(v) {}
		);
	}
	
	public inline function setup(map, markers, data:MarkerClustererData) {
		this.listen('click', data.onClick);
		this.ref.clearMarkers();
		this.ref.addMarkers(markers);
		this.ref.setZoomOnClick(data.zoomOnClick);
		
		// js.Browser.console.log(this.ref);
		
		// if(anchor == null && data.position != this.ref.getPosition())
		// 	this.ref.setPosition(data.position);
		
		if(this.ref.getMap() != map)
			this.ref.setMap(map);
			
		this.data = data;
	}
}