package coconut.gmaps;

import js.html.*;
import js.Browser.*;
import google.maps.LatLng;
import google.maps.LatLngBounds;
import coconut.gmaps.Object;
import tink.pure.*;

using tink.CoreApi;

typedef OverlayData = {
	@:optional var type:OverlayType;
}

class Overlay extends ObjectBase<OverlayData> {
	override function toType() return OOverlay(this);
}

enum OverlayType {
	Image(source:String, bounds:LatLngBounds);
}

@:allow(coconut.gmaps)
class ImageOverlay extends google.maps.OverlayView {
	var div:Element;
	
	var source:String;
	var bounds:LatLngBounds;
	
	function new(source, bounds) {
		super();
		this.source = source;
		this.bounds = bounds;
	}
	
	override function onAdd() {
		div = document.createDivElement();
		div.style.borderStyle = 'none';
		div.style.borderWidth = '0';
		div.style.position = 'absolute';
		
		var img = document.createImageElement();
		img.src = source;
		img.style.width = '100%';
		img.style.height = '100%';
		img.style.position = 'absolute';
		div.appendChild(img);
		
		getPanes().overlayLayer.appendChild(div);
	}
	
	override function draw() {
		var projection = getProjection();
		var sw = projection.fromLatLngToDivPixel(bounds.getSouthWest());
		var ne = projection.fromLatLngToDivPixel(bounds.getNorthEast());
		div.style.left = sw.x + 'px';
		div.style.top = ne.y + 'px';
		div.style.width = (ne.x - sw.x) + 'px';
		div.style.height = (sw.y - ne.y) + 'px';
	}
	
	override function onRemove() {
		div.parentNode.removeChild(div);
		div = null;
	}
}

class OverlayTypeTools {
	public static function toGoogle(type:OverlayType):google.maps.OverlayView {
		return switch type {
			case Image(source, bounds): new ImageOverlay(source, bounds);
		}
	}
}