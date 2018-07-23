package coconut.gmaps;

import haxe.extern.*;
import google.maps.LatLng;
import google.maps.LatLngBounds;
import google.maps.Padding;

enum Viewport {
	Center(center:LatLngLiteral, zoom:Float);
	Bounds(bounds:LatLngBoundsLiteral, padding:EitherType<Float, Padding>);
}