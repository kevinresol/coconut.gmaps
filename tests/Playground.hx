import js.Browser.*;
import coconut.Ui.*;
import coconut.gmaps.*;
import google.maps.LatLng;
import tink.pure.List;
import tink.state.*;

using tink.CoreApi;

class Playground extends coconut.ui.View {
	static function main() {
		document.body.querySelector('#map').appendChild(hxx('<Playground/>').toElement());
	}
	
	@:state var markers:List<LatLngLiteral> = null;
	@:state var polygons:List<List<List<LatLngLiteral>>> = null;
	
	function render() {
		return @hxx '
			<div style="height:100%;width:100%">
				<GoogleMap
					style="height:100%;width:100%"
					defaultCenter=${{lat: 22.4254815, lng: 114.212813}}
					defaultZoom=${15}
				>
					<for ${pos in markers}>
						<Marker position=${pos}>
							<InfoWindow>
								<div>Hey</div>
							</InfoWindow>
						</Marker>
					</for>
					
					<switch ${markers.first()}>
						<case ${Some(pos)}>
							<InfoWindow position=${pos}>
								<div>Hey</div>
							</InfoWindow>
						<case ${_}>
					</switch>
				</GoogleMap>
			</div>
		';
	}
	
	override function afterInit(e) {
		var timer = new haxe.Timer(5000);
		var count 	= 1;
		timer.run = function() {
			inline function rand(f:Float) return (Math.random() - 0.5) * f;
			markers = [for(i in 0...count % 3) {lat: 22.4254815 + rand(0.01), lng: 114.212813 + rand(0.01)}];
			polygons = [[[for(i in 0...3) {lat: 22.4254815 + rand(0.01), lng: 114.212813 + rand(0.01)}]]];
			count++;
		}
	}
}
