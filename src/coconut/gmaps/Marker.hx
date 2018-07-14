package coconut.gmaps;

import google.maps.MouseEvent;
import google.maps.LatLng;

class Marker implements coconut.data.Model {
	@:constant var position:LatLngLiteral;
	@:constant var clickable:Bool = @byDefault true;
	@:constant var draggable:Bool = @byDefault false;
	
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