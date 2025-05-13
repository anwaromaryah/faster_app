import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;


Map getCityNameByCoordinates(LatLng point) {
  bool isInSelectedArea =false;
  Map<String, List<LatLng>> coordinates = {
    "qalqilya" :[
      LatLng(32.19795, 34.96395),
      LatLng(32.18636, 34.95635),
      LatLng(32.1754, 34.9621),
      LatLng(32.18026, 34.98888),
      LatLng(32.19817, 34.98476),
    ],
    'nablus':[
      LatLng(32.27015, 35.18921),
      LatLng(32.20932, 35.16209),
      LatLng(32.1605, 35.27143),
      LatLng(32.21542, 35.37014),
      LatLng(32.26745, 35.25444),
    ],
    'tulkarm':[
      LatLng(32.33936, 35.0172),
      LatLng(32.28062, 35.01489),
      LatLng(32.2806, 35.02896),
      LatLng(32.31971, 35.06973),
      LatLng(32.34806, 35.04664),
      LatLng(32.33936, 35.0172),
    ],
    "ramallah":[
      LatLng(31.93439, 35.23281),
      LatLng(31.93628, 35.15505),
      LatLng(31.86196, 35.15299),
      LatLng(31.83309, 35.25908),
      LatLng(31.93439, 35.23281),
    ]


  };


  for(var cityCoordinates in coordinates.entries){

      List<map_tool.LatLng> convertedPolygonPoints = cityCoordinates.value.map(
            (point) => map_tool.LatLng(point.latitude,point.longitude),
      ).toList();

      isInSelectedArea = map_tool.PolygonUtil.containsLocation(
          map_tool.LatLng(point.latitude,point.longitude),
          convertedPolygonPoints,
          false);
      if(isInSelectedArea) {
        return {"condition" : true, "cityName" : cityCoordinates.key};
      }
  }

      return {"condition" : false, "cityName" : ""};
}


