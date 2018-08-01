package coconut.gmaps.ref;

import google.maps.*;

using coconut.gmaps.DrawingManager;

@:forward
abstract DrawingManagerRef(RefBase<google.maps.drawing.DrawingManager, DrawingManagerData>) {
	public inline function new() {
		this = new RefBase(
			new google.maps.drawing.DrawingManager(),
			function(v) v.setMap(null)
		);
	}
	
	public inline function setup(map, data:DrawingManagerData) {
		this.listen('circlecomplete', function(v) {if(data.onCircleComplete != null) data.onCircleComplete(v); v.setMap(null);});
		this.listen('markercomplete', function(v) {if(data.onMarkerComplete != null) data.onMarkerComplete(v); v.setMap(null);});
		this.listen('polygoncomplete', function(v) {if(data.onPolygonComplete != null) data.onPolygonComplete(v); v.setMap(null);});
		this.listen('polylinecomplete', function(v) {if(data.onPolylineComplete != null) data.onPolylineComplete(v); v.setMap(null);});
		this.listen('rectanglecomplete', function(v) {if(data.onRectangleComplete != null) data.onRectangleComplete(v); v.setMap(null);});
		// this.listen('overlaycomplete', data.onOverlayComplete);
		this.listen('drawingmode_changed', function() if(data.onDrawingModeChanged != null) data.onDrawingModeChanged(DrawingModeTools.fromOverlayType(this.ref.getDrawingMode())));
			
		this.ref.setOptions({
			drawingControlOptions: data.drawingControlOptions,	
			// circleOptions: data.circleOptions,	
			// markerOptions: data.markerOptions,	
			// polygonOptions: data.polygonOptions,	
			// polylineOptions: data.polylineOptions,	
			// rectangleOptions: data.rectangleOptions,
		});
		
		if(this.ref.getMap() != map) this.ref.setMap(map);
		
		if(data.drawingMode != null) {
			var mode = data.drawingMode.toOverlayType();
			if(this.ref.getDrawingMode() != mode)
				this.ref.setDrawingMode(mode);
		}
		
		this.data = data;
	}
}