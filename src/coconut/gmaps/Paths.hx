package coconut.gmaps;

import google.maps.LatLng;
import tink.pure.List;

@:forward
abstract Paths(List<List<LatLngLiteral>>) from List<List<LatLngLiteral>> to List<List<LatLngLiteral>> {
	@:from
	public static function fromArray(v:Array<Array<LatLngLiteral>>):Paths {
		return [for(i in v) List.fromArray(i)];
	}
	
	@:from
	public static function fromPolygon(polygon:google.maps.Polygon):Paths {
		var arr = [];
		polygon.getPaths().forEach(function(path, _) {
			var verts:Array<LatLngLiteral> = [];
			path.forEach(function(v, _) verts.push(v));
			arr.push(verts);
		});
		return fromArray(arr);
	}
	
	#if geojson
	@:to
	public function toGeoJson():geojson.Polygon {
		return new geojson.Polygon([for(path in this) [for(v in path) new geojson.util.Coordinates(v.lat, v.lng)]]);
	}
	
	@:from
	public static function fromGeoJson(polygon:geojson.Polygon):Paths {
		var arr = [];
		for(line in polygon.lines) {
			var verts = [];
			for(point in line) verts.push(new LatLngLiteral(point.latitude, point.longitude));
			arr.push(verts);
		}
		return fromArray(arr);
	}
	#end
	
	public function deleteVertex(path:Int, vertex:Int):Paths {
		var arr = [for(path in this) [for(v in path) v]];
		arr[path].splice(vertex, 1);
		return fromArray(arr);
	}
}