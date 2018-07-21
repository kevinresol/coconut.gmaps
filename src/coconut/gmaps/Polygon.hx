package coconut.gmaps;

import haxe.extern.*;
import google.maps.*;
import google.maps.LatLng;
import coconut.gmaps.Object;
import tink.pure.*;

typedef PolygonData = {
	
	@:optional var clickable:Bool;
	@:optional var draggable:Bool;
	@:optional var editable:Bool;
	@:optional var fillColor:String;
	@:optional var fillOpacity:Float;
	@:optional var geodesic:Bool;
	@:optional var strokeColor:String;
	@:optional var strokePosition:StrokePosition;
	@:optional var strokeOpacity:Float;
	@:optional var paths:Paths;
	@:optional var visible:Bool;
	@:optional var zIndex:Float;
	
	@:optional var onClick:MouseEvent->Void;
	@:optional var onDoubleClick:MouseEvent->Void;
	@:optional var onRightClick:MouseEvent->Void;
	@:optional var onMouseDown:MouseEvent->Void;
	@:optional var onMouseOut:MouseEvent->Void;
	@:optional var onMouseUp:MouseEvent->Void;
	@:optional var onMouseOver:MouseEvent->Void;
	@:optional var onDragStart:MouseEvent->Void;
	@:optional var onDrag:MouseEvent->Void;
	@:optional var onDragEnd:MouseEvent->Void;
	@:optional var onChange:Paths->Void;
}

class Polygon extends ObjectBase<PolygonData> {
	override function toType() return OPolygon(this);
}