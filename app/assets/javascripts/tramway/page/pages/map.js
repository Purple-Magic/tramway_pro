function createMap(elemId, centerLat, centerLng, zoom) {
  var map = new L.Map(elemId);

  var osmUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  var osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';

  var osmLayer = new L.TileLayer(osmUrl, {
    minZoom: 4,
    maxZoom: 20,
    attribution: osmAttrib
  });

  // Map
  map.setView(new L.LatLng(centerLat, centerLng), zoom);
  map.addLayer(osmLayer);
  return map;
}
markersLatLng = [
  [-18.586379, 45.878906],
  [-22.311967, 47.373047],
  [-20.61479, 45.922852]
];
function addMarker(map, latLng, onClick) {
  var marker = L.marker(latLng).addTo(map);
  if (onClick !== null) {
    marker.on('click', onClick);
  }
  return marker;
}
document.addEventListener("DOMContentLoaded", function () {
  var map = createMap('map', 58.08, 70.07, 4);
  markersLatLng.forEach(function(latLng) {
    addMarker(map, latLng);
  });
});
