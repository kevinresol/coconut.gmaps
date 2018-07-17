package coconut.gmaps;

import google.maps.*;
import google.maps.LatLng;
import tink.pure.*;

class Polygon implements coconut.data.Model {
	@:constant var draggable:Bool = @byDefault false;
	@:constant var editable:Bool = @byDefault false;
	@:external var paths:List<List<LatLngLiteral>>;
	@:constant var visible:Bool = @byDefault true;
	
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