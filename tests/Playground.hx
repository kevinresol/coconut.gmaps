import js.Browser.*;
import coconut.Ui.*;
import coconut.gmaps.*;
import tink.pure.List;

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
		var timer = new haxe.Timer(2000);
		var count = 0;
		timer.run = function() {
			trace('update data');
			var now = Date.now().toString();
			
			function genMarker() return new Marker({
				position: {lat: 22.4254815 + Math.random() * 0.01 - 0.005, lng: 114.212813 + Math.random() * 0.01 - 0.005},
				onClick: function() trace(now),
			});
			
			markers = [for(i in 0...count % 3) genMarker()];
			if(++count == 10) timer.stop();
		}
	}
}
