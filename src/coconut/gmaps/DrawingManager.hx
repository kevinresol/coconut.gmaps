package coconut.gmaps;

import google.maps.*;
import google.maps.drawing.*;
import google.maps.LatLng;
import coconut.gmaps.Object;
import tink.pure.*;

using tink.CoreApi;

typedef DrawingManagerData = {
	@:optional var drawingControl:Bool;
	@:optional var drawingControlOptions:DrawingControlOptions;
	@:optional var drawingMode:OverlayType;
	@:optional var onCircleComplete:Circle->Void;
	@:optional var onMarkerComplete:Marker->Void;
	// @:optional var onOverlayComplete:OverlayCompleteEvent->Void;
	@:optional var onPolygonComplete:Polygon->Void;
	@:optional var onPolylineComplete:Polyline->Void;
	@:optional var onRectangleComplete:Rectangle->Void;
}

class DrawingManager extends ObjectBase<DrawingManagerData> {
	override function toType() return ODrawingManager(this);
}