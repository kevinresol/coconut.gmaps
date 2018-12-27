package coconut.gmaps;

import google.maps.LatLngBounds;

class ImageOverlay extends Overlay {
	public function new(opt) {
		super({type: Image(opt.src, opt.bounds)});
	}
}