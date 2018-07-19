# Google Map for Coconut

## Usage

#### HTML

Load the google maps API:

```html
<script src="https://maps.googleapis.com/maps/api/js?key=<your-key>"></script>
```

load the drawing library as well if you use the `DrawingManager`:

```html
<script src="https://maps.googleapis.com/maps/api/js?key=<your-api-key>&libraries=drawing"></script>
```

#### HXX

```jsx
<GoogleMap
	style="height:100%;width:100%"
	defaultCenter=${{lat: 22.4254815, lng: 114.212813}}
	defaultZoom=${15}
>
	<!-- Marker -->
	<Marker position=${pos} onClick=${_ -> trace('clicked')}/>
	
	<!-- Polygon -->
	<Polygon editable paths=${paths}/>
	
	<!-- InfoWindow -->
	<InfoWindow position=${pos} onCloseClick=${() -> trace('closed')}>
		<div>Hey</div>
	</InfoWindow>
	
	<!-- InfoWindow using a Marker as anchor -->
	<Marker position=${pos}>
		<InfoWindow>
			<div>Hey</div>
		</InfoWindow>
	</Marker>
		
	<!-- DrawingManager -->
	<DrawingManager
		drawingMode=${POLYGON}
		drawingControlOptions=${{drawingModes: [POLYGON]}}
		onPolygonComplete=${polygon -> trace(polygon.getPaths())}
	/>
</GoogleMap>
```


## Attributes

For the time being, please refer to the corresponding source files. (e.g. `Marker.hx` for `Marker`)