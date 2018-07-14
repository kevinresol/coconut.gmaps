package coconut.gmaps;

import google.maps.LatLng;

class Marker implements coconut.data.Model {
	@:constant var position:LatLngLiteral;
	@:constant var onClick:Void->Void = @byDefault null;
}