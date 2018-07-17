package coconut.gmaps;

import google.maps.MouseEvent;
import google.maps.LatLng;
import tink.pure.*;

using tink.CoreApi;

class Marker implements coconut.data.Model {
	
	@:constant var animation:String = @byDefault null;
	@:constant var clickable:Bool = @byDefault true;
	@:constant var cursor:String = @byDefault null;
	@:constant var draggable:Bool = @byDefault false;
	@:constant var icon:String = @byDefault null;
	@:constant var label:String = @byDefault null;
	@:constant var opacity:Float = @byDefault null;
	@:external var position:LatLngLiteral;
	@:constant var shape:MarkerShape = null;
	@:constant var title:String = @byDefault null;
	@:constant var visible:Bool = @byDefault null;
	@:constant var zIndex:Int = @byDefault null;
	
	@:constant var onClick:MouseEvent->Void = @byDefault null;
	@:constant var onDoubleClick:MouseEvent->Void = @byDefault null;
	@:constant var onRightClick:MouseEvent->Void = @byDefault null;
	
	@:constant var onMouseDown:MouseEvent->Void = @byDefault null;
	@:constant var onMouseOut:MouseEvent->Void = @byDefault null;
	@:constant var onMouseUp:MouseEvent->Void = @byDefault null;
	@:constant var onMouseOver:MouseEvent->Void = @byDefault null;
	
	@:constant var onDragStart:MouseEvent->Void = @byDefault null;
	@:constant var onDrag:MouseEvent->Void = @byDefault null;
	@:constant var onDragEnd:MouseEvent->Void = @byDefault null;
}

enum MarkerShape {
	Circle(x:Float, y:Float, r:Float);
	Poly(vertices:List<Pair<Float, Float>>);
	Rect(x1:Float, y1:Float, x2:Float, y2:Float);
}

class MarkerShapeTools {
	public static function toGoogle(shape:MarkerShape):google.maps.MarkerShape {
		return switch shape {
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