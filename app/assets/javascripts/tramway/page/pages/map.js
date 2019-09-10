function createMap(elemId, centerLat, centerLng, zoom) {
  var map = new L.Map(elemId);

  var osmUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  var osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';

  var osmLayer = new L.TileLayer(osmUrl, {
    minZoom: 4,
    maxZoom: 20,
    attribution: osmAttrib
  });

  map.setView(new L.LatLng(centerLat, centerLng), zoom);
  map.addLayer(osmLayer);
  return map;
}
cities = {
  ulsk: [54.3080, 48.4879],
  tomsk: [56.4853, 84.9887],
  kzn: [55.7712, 49.1009],
  samara: [53.3218, 50.0683],
  perm: [58.0239, 56.2299]
};
function addMarker(map, city, onClick) {
  var marker = L.marker(cities[city]).addTo(map);
  marker.bindPopup(city);
  if (onClick !== null) {
    marker.on('click', onClick);
  }
  return marker;
}
document.addEventListener("DOMContentLoaded", function () {
  var map = createMap('map', 58.08, 70.07, 4);

  addMarker(map, 'ulsk')
  addMarker(map, 'tomsk')
  addMarker(map, 'kzn')
  addMarker(map, 'samara')
  addMarker(map, 'perm')
});
