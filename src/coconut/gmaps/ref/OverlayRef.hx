package coconut.gmaps.ref;

import google.maps.*;

using coconut.gmaps.Overlay;

@:forward
abstract OverlayRef(RefBase<google.maps.OverlayView, OverlayData>) {
	public inline function new() {
		this = new RefBase(
			(null:google.maps.OverlayView),
			function(v) v.setMap(null)
		);
	}
	
	public inline function setup(map:google.maps.Map, data:OverlayData) {
		if(this.ref != null) this.ref.setMap(null);
		this.ref = data.type.toGoogle();
		this.ref.setMap(map);
	}
}