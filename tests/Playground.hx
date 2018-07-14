import js.Browser.*;
import coconut.Ui.*;
import coconut.gmaps.*;
import tink.pure.List;
import tink.state.*;

class Playground extends coconut.ui.View {
	static function main() {
		document.body.querySelector('#map').appendChild(hxx('<Playground/>').toElement());
	}
	
	@:state var markers:List<Marker> = [];
	
	function render() {
		trace('Playground render()');
		return @hxx '
			<div style="height:100%;width:100%">
				<if ${markers.length == 0}>
					<GoogleMap style="height:100%;width:100%" defaultCenter=${{lat: 22.4254815, lng: 114.212813}} defaultZoom={15}/>
				<else>
					<GoogleMap style="height:100%;width:100%" defaultCenter=${{lat: 22.4254815, lng: 114.212813}} defaultZoom={15} markers=${markers}/>
				</if>
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
			
			markers = [for(i in 0...count % 3) genMarker()];
			if(++count > 1) timer.stop();
		}
	}
}
