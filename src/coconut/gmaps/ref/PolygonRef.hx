package coconut.gmaps.ref;

import google.maps.*;
import coconut.gmaps.Polygon;

@:forward
abstract PolygonRef(RefBase<google.maps.Polygon, Polygon>) {
	public inline function new() {
		this = new RefBase(
			new google.maps.Polygon(),
			function(v) v.setMap(null),
			function(v) {
				var paths = v.getPaths();
				Event.clearInstanceListeners(paths);
				paths.forEach(function(path, _) Event.clearInstanceListeners(path));
			}
		);
	}
	
	public inline function setup(map:google.maps.Map, data:PolygonData) {
		this.listen('click', data.onClick);
		this.listen('dblclick', data.onDoubleClick);
		this.listen('rightclick', data.onRightClick);
		this.listen('mousedown', data.onMouseDown);
		this.listen('mouseout', data.onMouseOut);
		this.listen('mouseup', data.onMouseUp);
		this.listen('mouseover', data.onMouseOver);
		this.listen('dragstart', data.onDragStart);
		this.listen('drag', data.onDrag);
		this.listen('dragend', data.onDragEnd);
		
		this.ref.setOptions({
			clickable: data.clickable,
			draggable: data.draggable,
			editable: data.editable,
			fillColor: data.fillColor,
			fillOpacity: data.fillOpacity,
			geodesic: data.geodesic,
			paths: [for(v in data.paths) v.toArray()],
			strokeColor: data.strokeColor,
			strokePosition: data.strokePosition,
			strokeOpacity: data.strokeOpacity,
			zIndex: data.zIndex,
		});
		
		if(this.ref.getMap() != map) this.ref.setMap(map);
		
		var dragging = false;
		Event.addListener(this.ref, 'dragstart', function() {
			dragging = true;
		});
		Event.addListener(this.ref, 'dragend', function() {
			dragging = false;
			if(data.onChange != null) data.onChange(this.ref);
		});
		
		var onPathsUpdate, setupPathListeners;
		
		onPathsUpdate = function() {
			if(data.onChange != null && !dragging) data.onChange(this.ref);
			setupPathListeners();
		}
		
		setupPathListeners = function() {
			var paths = this.ref.getPaths();
			Event.clearInstanceListeners(paths);
			Event.addListener(paths, 'remove_at', onPathsUpdate);
			Event.addListener(paths, 'insert_at', onPathsUpdate);
			Event.addListener(paths, 'set_at', onPathsUpdate);
			paths.forEach(function(path, _) {
				Event.clearInstanceListeners(path);
				Event.addListener(path, 'remove_at', onPathsUpdate);
				Event.addListener(path, 'insert_at', onPathsUpdate);
				Event.addListener(path, 'set_at', onPathsUpdate);
			});
		}
		
		setupPathListeners();
	}
}

