package coconut.gmaps;

import js.html.*;
import js.Browser.*;
import google.maps.LatLng;
import google.maps.LatLngBounds;
import coconut.gmaps.Object;
import tink.pure.*;

using tink.CoreApi;

typedef OverlayData = {
	var bounds:LatLngBounds;
	@:optional var children:coconut.ui.RenderResult;
}

class Overlay extends ObjectBase<OverlayData> {
	override function toType() return OOverlay(this);
}
