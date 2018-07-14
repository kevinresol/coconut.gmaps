package coconut.gmaps;

import tink.state.*;

using tink.CoreApi;

abstract MultiPolygon(MultiPolygonObject) {
	public var map(get, set):google.maps.Map;
	inline function get_map() return this.map.value;
	inline function set_map(v) {
		this.map.set(v);
		return v;
	}
	
	@:to
	public inline function observe()
		return this.state.observe();
		
	public inline function new(init)
		this = new MultiPolygonObject(init);
	
}

private class MultiPolygonObject {
	public var state:State<geojson.MultiPolygon>;
	public var map:State<google.maps.Map>;
	
	var polygons:Array<google.maps.Polygon>;
	var dragging = false;
	
	public function new(init:geojson.MultiPolygon) {
		state = new State(init);
		map = new State(null);
		polygons = [for(polygon in init.polygons) toGoogleMapPolygon(new geojson.Polygon(polygon))];
		
		state.observe().bind(null, function(multipolygon) {
			// add / remove / update gmap polygons
			var polygons = multipolygon.polygons;
			for(i in 0...polygons.length) {
				var gpolygon = this.polygons[i];
				if(gpolygon == null) gpolygon = this.polygons[i] = new google.maps.Polygon({editable: true, draggable: true});
				var polygon = polygons[i];
				gpolygon.getPaths().forEach(function(path, _) {
					google.maps.Event.clearInstanceListeners(path);
				});
				gpolygon.setPaths([for(line in polygon.lines) [for(point in line.slice(0, line.length - 1)) {lat: point.latitude, lng: point.longitude}]]);
				gpolygon.getPaths().forEach(function(path, _) {
					google.maps.Event.addListener(path, 'insert_at', scheduleUpdate);
					google.maps.Event.addListener(path, 'remove_at', scheduleUpdate);
					google.maps.Event.addListener(path, 'set_at', scheduleUpdate);
				});
				google.maps.Event.addListener(gpolygon, 'dragstart', function() dragging = true);
				google.maps.Event.addListener(gpolygon, 'dragend', function() {dragging = false; update();});
			}
			
			// remove extra gpolygons
			while(this.polygons.length > polygons.length) {
				var gpolygon = this.polygons.pop();
				gpolygon.setMap(null);
			}
		});
		
		map.observe().bind(null, function(map) {
			for(polygon in polygons) polygon.setMap(map);
		});
		
	}
	
	var scheduled = false;
	function scheduleUpdate() {
		if(scheduled || dragging) return;
		scheduled = true;
		Callback.defer(function() {
			scheduled = false;
			update();
		});
	}
	
	function update() {
		state.set(new geojson.MultiPolygon(polygons.map(function(o) return toPolygon(o).lines)));
	}
	
	function toPolygon(p:google.maps.Polygon):geojson.Polygon {
		var lines = [];
		p.getPaths().forEach(function(path, _) {
			var line = [];
			lines.push(line);
			path.forEach(function(vertex, _) line.push(new geojson.util.Coordinates(vertex.lat(), vertex.lng())));
			line.push(line[0]); // finish the loop
		});
		return new geojson.Polygon(lines);
	}
	
	function toGoogleMapPolygon(p:geojson.Polygon):google.maps.Polygon {
		return new google.maps.Polygon({
			paths: [for(line in p.lines) [for(point in line.slice(0, line.length - 1)) {lat: point.latitude, lng: point.longitude}]],
			editable: true,
			draggable: true,
		});
	}
}
