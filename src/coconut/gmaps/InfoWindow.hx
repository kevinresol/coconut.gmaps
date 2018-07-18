package coconut.gmaps;

import google.maps.LatLng;

class InfoWindow implements coconut.data.Model {
	@:constant var content:coconut.ui.RenderResult;
	@:constant var position:LatLngLiteral = @byDefault null;
	@:constant var zIndex:Int = @byDefault null;
	
	@:constant var onCloseClick:Void->Void = @byDefault null;
}