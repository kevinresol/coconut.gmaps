import js.Browser.*;
import coconut.Ui.*;
import coconut.gmaps.*;
import google.maps.LatLng;
import tink.pure.List;
import tink.state.*;

class Playground extends coconut.ui.View {
	static function main() {
		document.body.querySelector('#map').appendChild(hxx('<Playground/>').toElement());
	}
	
	@:state var markers:List<Marker> = [];
	@:state var polygons:List<Polygon> = [];
	
	function render() {
		trace('Playground render()');
		return @hxx '
			<div style="height:100%;width:100%">
				<GoogleMap
					style="height:100%;width:100%"
					defaultCenter=${{lat: 22.4254815, lng: 114.212813}}
					defaultZoom=${15}
					markers=${markers}
					polygons=${polygons}
				/>
			</div>
		';
	}
	
	override function afterInit(e) {
		var timer = new haxe.Timer(500);
		var count = 1;
		timer.run = function() {
			trace('update data');
			var now = Date.now().toString();
			
			inline function rand(f:Float) return (Math.random() - 0.5) * f;
			
			function genMarker() {
				var position = new State({lat: 22.4254815 + rand(0.01), lng: 114.212813 + rand(0.01)});
				new haxe.Timer(16).run = function() position.set({lat: position.value.lat + rand(0.0001), lng: position.value.lng + rand(0.0001)});
				
				return new Marker({
					position: position.observe(),
					onClick: function(_) trace('clicked'),
					onRightClick: function(_) trace('rightclicked'),
					onDoubleClick: function(_) trace('dblclicked'),
					draggable: true,
					onDrag: function(e) trace(e.latLng.lat(), e.latLng.lng()),
				});
			}
			
			function genPolygon() {
				var paths = new State<List<List<LatLngLiteral>>>([[
					{lat: 22.4254815, lng: 114.212813},
					{lat: 22.4354815, lng: 114.212813},
					{lat: 22.4254815, lng: 114.222813},
				]]);
				new haxe.Timer(16).run = function() 
					paths.set(paths.value.map(function(v) return v.map(function(v) return {lat: v.lat + rand(0.0001), lng: v.lng + rand(0.0001)})));
				
				paths.observe().bind(null, function(v) trace([for(v in v) [for(v in v) v]]));
				return new Polygon({
					paths: paths.observe(),
					onClick: function(_) trace('clicked'),
					onRightClick: function(_) trace('rightclicked'),
					onDoubleClick: function(_) trace('dblclicked'),
					draggable: true,
					onDrag: function(e) trace(e.latLng.lat(), e.latLng.lng()),
				});
			}
			
			markers = [for(i in 0...count % 3) genMarker()];
			polygons = [genPolygon()];
			if(++count > 1) timer.stop();
		}
	}
}
