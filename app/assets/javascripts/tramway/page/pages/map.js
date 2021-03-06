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
  ulsk: {
    coordinates: [54.3080, 48.4879],
    text: 'Ульяновск: 11 мероприятий за 4 года'
  },
  tomsk: {
    coordinates: [56.4853, 84.9887],
    text: 'Томск: 4 мероприятия за 9 месяцев'
  },
  kzn: {
    coordinates: [55.7712, 49.1009],
    text: 'Казань: 3 мероприятия за 8 месяцев'
  },
  samara: {
    coordinates: [53.3218, 50.0683],
    text: 'Самара: 2 мероприятия за 6 месяцев',
  },
  perm: {
    coordinates: [58.0239, 56.2299],
    text: 'Пермь: 1 мероприятие за 2 месяца'
  }
};
function addMarker(map, city, onClick) {
  var marker = L.marker(cities[city].coordinates).addTo(map);
  marker.bindPopup(cities[city].text);
  if (onClick !== null) {
    marker.on('click', onClick);
  }
  return marker;
}
function loadEvents() {
  axios.get('http://it-way.test:3000/api/v1/records?model=Tramway::Event::Event').then(function(response) {
    console.log(response);
  });
}
document.addEventListener("DOMContentLoaded", function () {
  var map = createMap('map', 58.08, 70.07, 4);

  addMarker(map, 'ulsk')
  addMarker(map, 'tomsk')
  addMarker(map, 'kzn')
  addMarker(map, 'samara')
  addMarker(map, 'perm')

  loadEvents()
});
