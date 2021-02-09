import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart";

class HomeScreen extends StatelessWidget {
  static String routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(37.7797221, -3.7943167),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/adsonatural/ckkygyyb12gfp17p7ajayy68d/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoiYWRzb25hdHVyYWwiLCJhIjoiY2tnNmsyaXZyMTUxczJzcjI2ejU1MWo4eSJ9.mV09cP-TAt0zC0lfRF7auw'
          },
        ),
        MarkerLayerOptions(markers: [
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(37.7797221, -3.7943167),
            builder: (context) => Container(
              child: Image.asset('assets/images/marker.png'),
            ),
          )
        ])
      ],
    );
  }
}
