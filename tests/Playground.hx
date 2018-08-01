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
	
	@:state var clustered:List<LatLngLiteral> = [for(i in 0... 3) new LatLngLiteral(22.4254815 +i * (0.005), 114.205813 + i*(-0.005))];
	@:state var markers:List<LatLngLiteral> = [for(i in 0... 3) new LatLngLiteral(22.4254815 +i * (0.01), 114.212813 + i*(0.01))];
	@:state var polygons:List<Paths> = null;
	
	function render() {
		return @hxx '
			<div style="height:100%;width:100%">
				<GoogleMap
					style="height:100%;width:100%"
					defaultViewport=${Bounds({north: 22.5254815, east: 114.312813, south: 22.4254815, west: 114.212813}, null)}
				>
					<MarkerClusterer averageCenter zoomOnClick=${false} onClick=${c -> trace('cluster clicked')}>
						<for ${pos in clustered}>
							<Marker position=${pos}>
								<InfoWindow>
									<div>Hey</div>
								</InfoWindow>
							</Marker>
						</for>
					</MarkerClusterer>
					<for ${pos in markers}>
						<Marker position=${pos}>
							<InfoWindow>
								<div>Hey</div>
							</InfoWindow>
						</Marker>
					</for>
					
					<for ${paths in polygons}>
						<Polygon
							editable
							draggable
							paths=${paths}
							fillColor="red"
							strokeColor="red"
							onChange=${v -> {trace('change'); polygons = polygons.filter(p -> p != paths).prepend(v);}}
							onDoubleClick=${e -> if(e.path != null && e.vertex != null) polygons = polygons.filter(p -> p != paths).prepend(paths.deleteVertex(e.path, e.vertex))}
							onDrag=${_ -> trace('drag')}
						/>
					</for>
					
					<switch ${markers.first()}>
						<case ${Some(pos)}>
							<InfoWindow position=${pos}>
								<div>Hey</div>
							</InfoWindow>
						<case ${_}>
					</switch>
					
					<DrawingManager
						drawingControlOptions=${{drawingModes: [POLYGON]}}
						onPolygonComplete=${v -> polygons = polygons.append(v)}
					/>
				</GoogleMap>
			</div>
		';
	}
	
	override function afterInit(e) {
		var timer = new haxe.Timer(1000);
		var count 	= 1;
		timer.run = function() {
			inline function rand(f:Float) return (Math.random() - 0.5) * f;
			// markers = [for(i in 0...count%3) new LatLngLiteral(22.4254815 + rand(0.01), 114.212813 + rand(0.01))];
			// polygons = [[[for(i in 0...3) {lat: 22.4254815 + rand(0.01), lng: 114.212813 + rand(0.01)}]]];
			count++;
		}
	}
}
