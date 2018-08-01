package coconut.gmaps;

import coconut.gmaps.Object;
import google.maps.markerclustererplus.Cluster;

typedef MarkerClustererData = {
	@:optional var onClick:Cluster->Void;
	@:optional var zoomOnClick:Bool;
	@:optional var children:Array<Marker>;
	
}

class MarkerClusterer extends ObjectBase<MarkerClustererData> {
	override function toType() return OMarkerClusterer(this);
}