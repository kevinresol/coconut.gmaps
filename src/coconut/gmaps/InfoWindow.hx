package coconut.gmaps;

import google.maps.*;
import google.maps.LatLng;
import coconut.gmaps.Object;
import tink.pure.*;

typedef InfoWindowData = {
	@:optional var position:LatLngLiteral;
	@:optional var zIndex:Int;
	@:optional var onCloseClick:Void->Void;
	@:optional var children:coconut.ui.RenderResult;
}

class InfoWindow extends ObjectBase<InfoWindowData> {
	override function toType() return OInfoWindow(this);
}