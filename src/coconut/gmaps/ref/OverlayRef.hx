package coconut.gmaps.ref;

import js.html.Element;
import js.Browser.*;
import google.maps.*;

using coconut.gmaps.Overlay;

@:forward
abstract OverlayRef(RefBase<OverlayView, OverlayData>) {
	public inline function new() {
		this = new RefBase(
			new OverlayView(),
			function(v) v.setMap(null)
		);
	}
	
	public inline function setup(map:google.maps.Map, data:OverlayData) {
		this.ref.bounds = data.bounds; // TODO: might need to call draw() manually here
		this.ref.content = data.children.toElement();
		if(this.ref.getMap() != map) this.ref.setMap(map);
	}
}

class OverlayView extends google.maps.OverlayView {
	
	public var content(never, set):Element;
	public var bounds:LatLngBounds;
	
	var div:Element;
	
	public function new(?bounds) {
		super();
		this.bounds = bounds;
		div = document.createDivElement();
		div.style.borderStyle = 'none';
		div.style.borderWidth = '0';
		div.style.position = 'absolute';
	}
	
	override function onAdd() {
		getPanes().overlayLayer.appendChild(div);
	}
	
	override function draw() {
		if(bounds != null) {
			var projection = getProjection();
			var sw = projection.fromLatLngToDivPixel(bounds.getSouthWest());
			var ne = projection.fromLatLngToDivPixel(bounds.getNorthEast());
			div.style.left = sw.x + 'px';
			div.style.top = ne.y + 'px';
			div.style.width = (ne.x - sw.x) + 'px';
			div.style.height = (sw.y - ne.y) + 'px';
		}
	}
	
	override function onRemove() {
		div.parentNode.removeChild(div);
	}
	
	function set_content(e:Element):Element {
		while(div.firstChild != null) div.removeChild(div.firstChild);
		console.log(e);
		if(e != null) div.appendChild(e);
		return e;
	}
}