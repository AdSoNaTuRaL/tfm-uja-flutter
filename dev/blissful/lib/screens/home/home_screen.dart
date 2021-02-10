import 'package:blissful/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart";

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng _center = LatLng(37.7797221, -3.7943167);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Container(
            child: FlutterMap(
              options: MapOptions(
                center: _center,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/adsonatural/ckkygyyb12gfp17p7ajayy68d/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                  // https://api.mapbox.com/styles/v1/mapbox/light-v10/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiYWRzb25hdHVyYWwiLCJhIjoiY2tnNmsyaXZyMTUxczJzcjI2ejU1MWo4eSJ9.mV09cP-TAt0zC0lfRF7auw'
                  },
                ),
                MarkerLayerOptions(markers: [
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: _center,
                    builder: (context) => Container(
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 200,
                                color: Colors.transparent,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Lar das meninas'),
                                      ElevatedButton(
                                        child: const Text('Agendar una cita?'),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Image.asset('assets/images/marker.png'),
                      ),
                    ),
                  )
                ])
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Text(
                      '2 Orfanatos encontrados',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8FA7B2),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: bPrimaryColor,
                      onPressed: () {},
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
