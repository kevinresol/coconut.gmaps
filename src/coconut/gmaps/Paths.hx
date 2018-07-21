package coconut.gmaps;

import google.maps.Polygon;
import google.maps.LatLng;
import tink.pure.List;

@:forward
abstract Paths(List<List<LatLngLiteral>>) from List<List<LatLngLiteral>> to List<List<LatLngLiteral>> {
	@:from
	public static function fromArray(v:Array<Array<LatLngLiteral>>):Paths {
		return [for(i in v) List.fromArray(i)];
	}
	
	@:from
	public static function fromPolygon(polygon:Polygon):Paths {
		var arr = [];
		polygon.getPaths().forEach(function(path, _) {
			var verts:Array<LatLngLiteral> = [];
			path.forEach(function(v, _) verts.push(v));
			arr.push(verts);
		});
		return fromArray(arr);
	}
	
	public function deleteVertex(path:Int, vertex:Int):Paths {
		var arr = [for(path in this) [for(v in path) v]];
		arr[path].splice(vertex, 1);
		return fromArray(arr);
	}
}