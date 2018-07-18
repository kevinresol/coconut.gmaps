package coconut.gmaps;

import google.maps.*;
import google.maps.LatLng;
import coconut.gmaps.Object;
import tink.pure.*;

typedef PolygonData = {
	
	@:optional var draggable:Bool;
	@:optional var editable:Bool;
	@:optional var paths:List<List<LatLngLiteral>>;
	@:optional var visible:Bool;
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
}

class Polygon extends ObjectBase<PolygonData> {
	override function toType() return OPolygon(this);
}