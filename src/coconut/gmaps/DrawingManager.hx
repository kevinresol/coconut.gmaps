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
	@:optional var drawingMode:DrawingMode;
	@:optional var onDrawingModeChanged:DrawingMode->Void;
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

enum DrawingMode {
	None;
	Polygon;
	Circle;
	Marker;
	Polyline;
	Rectangle;
}

class DrawingModeTools {
	public static function toOverlayType(mode:DrawingMode):OverlayType {
		return switch mode {
			case None: null;
			case Polygon: POLYGON;
			case Circle: CIRCLE;
			case Marker: MARKER;
			case Polyline: POLYLINE;
			case Rectangle: RECTANGLE;
		}
	}
	
	public static function fromOverlayType(type:OverlayType):DrawingMode {
		return switch type {
			case null: None;
			case POLYGON: Polygon;
			case CIRCLE: Circle;
			case MARKER: Marker;
			case POLYLINE: Polyline;
			case RECTANGLE: Rectangle;
		}
	}
}