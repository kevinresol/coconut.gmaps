package coconut.gmaps.ref;

import google.maps.*;
import coconut.gmaps.InfoWindow;

@:forward
abstract InfoWindowRef(RefBase<google.maps.InfoWindow, InfoWindowData>) {
	public inline function new() {
		this = new RefBase(
			new google.maps.InfoWindow(),
			function(v) {
				v.close();
				
				if(this.data != null && this.data.children != null) 
					switch Std.instance(cast this.data.children, coconut.vdom.Renderable) {
						case null: // ignore
						case v: v.destroy();
					}
			}
		);
	}
	
	public inline function setup(map, anchor, data:InfoWindowData) {
		this.listen('closeclick', data.onCloseClick);
		this.ref.setContent(switch Std.instance(cast data.children, coconut.vdom.Renderable) {
			case null: data.children.toElement();
			case v: v.toElement();
		});
		this.ref.setZIndex(data.zIndex);
		
		if(anchor == null && data.position != this.ref.getPosition())
			this.ref.setPosition(data.position);
		
		if(this.ref.getMap() != map || this.ref.getAnchor() != anchor)
			this.ref.open(map, anchor);
			
		this.data = data;
	}
}