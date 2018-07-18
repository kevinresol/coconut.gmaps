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
	OMarker(v:Marker);
	OPolygon(v:Polygon);
	OInfoWindow(v:InfoWindow);
	ODrawingManager(v:DrawingManager);
}