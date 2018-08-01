package coconut.gmaps;

import google.maps.MouseEvent;
import google.maps.LatLng;
import coconut.gmaps.Object;
import tink.pure.*;

using tink.CoreApi;

typedef MarkerData = {
	@:optional var animation:String;
	@:optional var clickable:Bool;
	@:optional var cursor:String;
	@:optional var data:Any;
	@:optional var draggable:Bool;
	@:optional var icon:String;
	@:optional var label:String;
	@:optional var opacity:Float;
	@:optional var position:LatLngLiteral;
	@:optional var shape:MarkerShape;
	@:optional var title:String;
	@:optional var visible:Bool;
	@:optional var zIndex:Int;
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
	@:optional var children:Array<Object>;
}

class Marker extends ObjectBase<MarkerData> {
	override function toType() return OMarker(this);
}

enum MarkerShape {
	Circle(x:Float, y:Float, r:Float);
	Poly(vertices:List<Pair<Float, Float>>);
	Rect(x1:Float, y1:Float, x2:Float, y2:Float);
}

class MarkerShapeTools {
	public static function toGoogle(shape:MarkerShape):google.maps.MarkerShape {
		return switch shape {
			case null:
				null;
			case Circle(x, y, r):
				{
					coords: [x, y, r],
					type: 'circle',
				}
			case Poly(v):
				{
					coords: {
						var arr = [];
						for(p in v) {
							arr.push(p.a);
							arr.push(p.b);
						}
						arr;
					},
					type: 'poly',
				}
			case Rect(x1, y1, x2, y2):
				{
					coords: [x1, y1, x2, y2],
					type: 'rect',
				}
		}
	}
}