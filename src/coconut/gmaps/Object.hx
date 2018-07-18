package coconut.gmaps;

interface Object {
	function toType():ObjectType;
}

class ObjectBase<T> implements Object {
	public var data:T;
	public function new(data)
		this.data = data;
	public function toType():ObjectType
		throw 'abstract';
}

enum ObjectType {
	OMarker(marker:Marker);
	OPolygon(polygon:Polygon);
	OInfoWindow(infoWindow:InfoWindow);
}