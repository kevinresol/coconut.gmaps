package coconut.gmaps.ref;

import google.maps.*;

using coconut.gmaps.Marker;

@:forward
abstract MarkerRef(RefBase<google.maps.Marker, MarkerData>) {
	public inline function new() {
		this = new RefBase(
			new google.maps.Marker(),
			function(v) v.setMap(null)
		);
	}
	
	public inline function setup(map:google.maps.Map, data:MarkerData) {
		this.listen('click', data.onClick);
		this.listen('dblclick', data.onDoubleClick);
		this.listen('rightclick', data.onRightClick);
		this.listen('mousedown', data.onMouseDown);
		this.listen('mouseout', data.onMouseOut);
		this.listen('mouseup', data.onMouseUp);
		this.listen('mouseover', data.onMouseOver);
		this.listen('dragstart', data.onDragStart);
		this.listen('drag', data.onDrag);
		this.listen('dragend', data.onDragEnd);
		this.ref.setAnimation(data.animation);
		this.ref.setClickable(data.clickable);
		this.ref.setCursor(data.cursor);
		this.ref.setDraggable(data.draggable);
		this.ref.setIcon(data.icon);
		this.ref.setLabel(data.label);
		this.ref.setOpacity(data.opacity);
		this.ref.setPosition(data.position);
		this.ref.setShape(data.shape.toGoogle());
		this.ref.setTitle(data.title);
		this.ref.setVisible(data.visible);
		this.ref.setZIndex(data.zIndex);
		if(this.ref.getMap() != map) this.ref.setMap(map);
		this.data = data;
	}
}