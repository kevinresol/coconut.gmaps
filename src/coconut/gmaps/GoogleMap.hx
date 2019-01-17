package coconut.gmaps;

import coconut.data.*;
import coconut.gmaps.ref.*;
import google.maps.Event;
import google.maps.LatLng;

using coconut.gmaps.Marker;
using coconut.gmaps.Polygon;
using coconut.gmaps.InfoWindow;
using coconut.gmaps.DrawingManager;
using tink.CoreApi;
using Lambda;

private typedef Data = {
	@:optional var className(default, never):String;
	@:optional var style(default, never):String;
	var defaultViewport(default, never):Viewport;
	@:optional var children(default, never):Array<Object>;
}

private typedef Context = {
	var markers:Array<MarkerRef>;
	var polygons:Array<PolygonRef>;
	var infoWindows:Array<InfoWindowRef>;
	var overlays:Array<OverlayRef>;
	var markerClusterers:Array<MarkerClustererRef>;
	var drawingManager:DrawingManagerRef;
}

class GoogleMap extends vdom.Foreign {
	
	var data:Data;
	var map:google.maps.Map;
	var ctx:Context;
	
	public function new(data:Data) {
		super(null);
		this.data = data;
	}
	
	function refresh() {
		var markers = [];
		var polygons = [];
		var infoWindows = [];
		var overlays = [];
		var markerClusterers = [];
		var drawingManager = null;
		
		if(data.children != null) for(o in data.children) switch o.toType() {
			case OMarker(v):
				markers.push(v);
				if(v.data.children != null) for(o in v.data.children) switch o.toType() {
					case OInfoWindow(infoWindow):
						infoWindows.push({window: infoWindow, anchor: v});
					case _: // TODO
				}
			case OPolygon(v):
				polygons.push(v);
			case OInfoWindow(v):
				infoWindows.push({window: v, anchor: null});
			case OOverlay(v):
				overlays.push(v);
			case ODrawingManager(v):
				drawingManager = v;
			case OMarkerClusterer(v):
				markerClusterers.push(v);
				if(v.data.children != null)
					for(m in v.data.children) markers.push(m);
		}
		refreshMarkers(markers);
		refreshPolygons(polygons);
		refreshInfoWindows(infoWindows);
		refreshOverlays(overlays);
		refreshDrawingManager(drawingManager);
		refreshMarkerClusterer(markerClusterers);
	}
	
	inline function refreshMarkers(data:Array<Marker>) {
		var i = 0;
		for(v in data) {
			var ref = 
				if(ctx.markers.length > i) {
					var reused = ctx.markers[i];
					reused.reset(false);
					reused;
				} else 
					ctx.markers[i] = new MarkerRef();
					
			ref.setup(map, v.data);
			i++;
		}
		
		// clean up unused marker instances
		for(j in i...ctx.markers.length) ctx.markers[j].reset();
	}
	
	inline function refreshPolygons(data:Array<Polygon>) {
		var i = 0;
		for(v in data) {
			var ref = 
				if(ctx.polygons.length > i) {
					var reused = ctx.polygons[i];
					reused.reset(false);
					reused;
				} else
					ctx.polygons[i] = new PolygonRef();
				
			ref.setup(map, v.data);
			i++;
		}
		
		// clean up unused polygon instances
		for(j in i...ctx.polygons.length) ctx.polygons[j].reset();
	}
	
	
	inline function refreshInfoWindows(data:Array<{window:InfoWindow, anchor:Marker}>) {
		var i = 0;
		for(v in data) {
			var ref = 
				if(ctx.infoWindows.length > i) {
					var reused = ctx.infoWindows[i];
					reused.reset(false);
					reused;
				} else
					ctx.infoWindows[i] = new InfoWindowRef();
				
			var anchor = v.anchor == null ? null : ctx.markers.find(function(m) return m.data == v.anchor.data);
			ref.setup(map, anchor == null ? null : anchor.ref, v.window.data);
			
			i++;
		}
		
		// clean up unused infoWindow instances
		for(j in i...ctx.infoWindows.length) ctx.infoWindows[j].reset();
	}
	
	inline function refreshOverlays(data:Array<Overlay>) {
		var i = 0;
		for(v in data) {
			var ref = 
				if(ctx.overlays.length > i) {
					var reused = ctx.overlays[i];
					reused.reset(false);
					reused;
				} else
					ctx.overlays[i] = new OverlayRef();
				
			ref.setup(map, v.data);
			i++;
		}
		
		// clean up unused polygon instances
		for(j in i...ctx.overlays.length) ctx.overlays[j].reset();
	}
	
	inline function refreshDrawingManager(data:DrawingManager) {
		if(data != null) {
			if(ctx.drawingManager == null)
				ctx.drawingManager = new DrawingManagerRef();
			else
				ctx.drawingManager.reset(false);
			
			ctx.drawingManager.setup(map, data.data);
			
		} else {
			if(ctx.drawingManager != null) ctx.drawingManager.reset();
		}
	}
	
	inline function refreshMarkerClusterer(data:Array<MarkerClusterer>) {
		var i = 0;
		for(v in data) {
			var ref = 
				if(ctx.markerClusterers.length > i) {
					var reused = ctx.markerClusterers[i];
					reused.reset(false);
					reused;
				} else
					ctx.markerClusterers[i] = new MarkerClustererRef();
				
			var markers = [];
			switch v.data.children {
				case null: // skip
				case children: 
					for(c in children)
						switch ctx.markers.find(function(m) return m.data == c.data) {
							case null: // ??
							case m: markers.push(m.ref);
						}
			}
			ref.setup(map, markers, v.data);
			
			i++;
		}
		
		// clean up unused infoWindow instances
		for(j in i...ctx.markerClusterers.length) ctx.markerClusterers[j].reset();
	}
	
	override function init() {
		element = js.Browser.document.createDivElement();
		if(data.className != null) element.className = data.className;
		if(data.style != null) element.style.cssText = data.style;
		
		map = new google.maps.Map(element);
		
		switch data.defaultViewport {
			case Center(c, z): map.setCenter(c); map.setZoom(z);
			case Bounds(b, p): haxe.Timer.delay(map.fitBounds.bind(b, p), 0);
		}
		
		ctx = {
			markers: [],
			polygons: [],
			infoWindows: [],
			overlays: [],
			markerClusterers: [],
			drawingManager: null,
		}
		
		refresh();
		
		return element;
	}
	
	override function update(prev:{}, e) {
		switch Std.instance(prev, GoogleMap) {
			case null:
			case that:
				element = that.element;
				map = that.map;
				ctx = that.ctx;
				that.destroy();
				refresh();
		}
		
		return element;
	}
	
	override function destroy() {
		data = null;
		element = null;
		map = null;
		ctx = null;
	}
}