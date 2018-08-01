package coconut.gmaps.ref;

import google.maps.*;
import coconut.gmaps.InfoWindow;

@:forward
abstract InfoWindowRef(RefBase<google.maps.InfoWindow, InfoWindow>) {
	public inline function new() {
		this = new RefBase(
			new google.maps.InfoWindow(),
			function(v) v.close()
		);
	}
	
	public inline function setup(map, anchor, data:InfoWindowData) {
		this.listen('closeclick', data.onCloseClick);
		this.ref.setContent(data.children.toElement());
		this.ref.setZIndex(data.zIndex);
		
		if(anchor == null && data.position != this.ref.getPosition())
			this.ref.setPosition(data.position);
		
		if(this.ref.getMap() != map || this.ref.getAnchor() != anchor)
			this.ref.open(map, anchor);
	}
}