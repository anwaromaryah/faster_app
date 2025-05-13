import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/getLocationPermission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    required this.setLocation,
    required this.location,
    required this.secondLocation,
    required this.thirdLocation,
    required this.fourthLocation,
   this.enableSelectLocation = true
  });

  final Function setLocation ;
  final LatLng location;
  final LatLng secondLocation;
  final LatLng thirdLocation;
  final LatLng fourthLocation;

  final bool enableSelectLocation;
  @override
  State<CustomMap> createState() => _CustomMapState();

}

class _CustomMapState extends State<CustomMap> {
 LatLng userLocation = LatLng(0, 0);




 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: widget.location.latitude != 0 ? widget.location :
              widget.secondLocation.latitude != 0 ? widget.secondLocation :
              widget.thirdLocation.latitude != 0 ? widget.thirdLocation :
              widget.fourthLocation.latitude != 0 ? widget.fourthLocation :
                  LatLng(0, 0),
              initialZoom: 14,
              onTap: (tapPosition, LatLng point) {
                 if(widget.enableSelectLocation){
                   setState(() {
                     userLocation = LatLng(point.latitude, point.longitude);
                     widget.setLocation(userLocation);
                   });
                 }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            MarkerLayer(
                    markers: [
                      Marker(
                          point: userLocation,
                          child: Image.asset('icons/location1.png',width: 20,height: 20,)
                      ),
                      Marker(
                          point: widget.secondLocation,
                          child: Image.asset('icons/client-location.png',width: 22,height: 22,)
                      ),
                      Marker(
                          point: widget.thirdLocation,
                          child: Image.asset('icons/location2.png',width: 21,height: 21,)
                      ),
                      Marker(
                          point: widget.fourthLocation,
                          child: Image.asset('icons/delivery-truck.png',width: 20,height: 20,)
                      )
                    ]
                ),
            Visibility(
              visible: userLocation.latitude == 0 && userLocation.longitude == 0,
              child: MarkerLayer(
                      markers: [
                        Marker(
                            point: widget.location,
                            child: Image.asset('icons/location1.png',width: 20,height: 20,))
                      ]
                  ),
            )



            ],
          ),

        ],
      ),
    );

  }
}
