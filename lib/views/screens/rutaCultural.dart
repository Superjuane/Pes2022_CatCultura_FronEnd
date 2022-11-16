import 'dart:async';
import 'dart:ui';

import 'package:CatCultura/data/response/apiResponse.dart';
import 'package:CatCultura/models/Place.dart';
import 'package:CatCultura/viewModels/RutaCulturalViewModel.dart';
import 'package:CatCultura/views/screens/parametersRutaCultural.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';

import '../../utils/auxArgsObjects/argsRouting.dart';
import 'package:CatCultura/utils/auxArgsObjects/argsReturnParametersRutaCultural.dart';
import '../widgets/myDrawer.dart';

class RutaCultural extends StatefulWidget {
  @override
  State<RutaCultural> createState() => RutaCulturalState();
}

class RutaCulturalState extends State<RutaCultural> {
  late ClusterManager _manager;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {const Marker(
        markerId: MarkerId("marker_2"),
        position: LatLng(41.3860, 2.1675),

      ),};
  final CameraPosition _iniCameraPosition =
      const CameraPosition(target: LatLng(41.3874, 2.1686), zoom: 11.0);
  final RutaCulturalViewModel viewModel = RutaCulturalViewModel();
  List<Polyline> polylines = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    _manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    List<Place> a = [];
    return ClusterManager<Place>(a, _updateMarkers,
        markerBuilder: _markerBuilder, stopClusteringZoom: 17.0);
  }

  void _updateMarkers(Set<Marker> markers) {
    debugPrint("markers to set: "+markers.toString());
    setState(() {
      this.markers = markers; //await setMarkers(markers);
      paintPolylines();
    });
  }

  // Future<Set<Marker>> setMarkers(Set<Marker> markers) async {
  //   return {
  //     Marker(
  //         markerId: MarkerId("marker_1"),
  //         position: LatLng(41.3874, 2.1686),
  //         infoWindow: InfoWindow(title: 'Marker 1'),
  //         icon: await _getMarkerBitmap(75,
  //             text: "1",
  //             color: Colors.green)
  //     ),
  //     Marker(
  //       markerId: const MarkerId("marker_2"),
  //       position: const LatLng(41.3860, 2.1675),
  //         icon: await _getMarkerBitmap(75,
  //             text: "2",
  //             color: Colors.yellow)
  //     ),
  //     Marker(
  //         markerId: const MarkerId("marker_3"),
  //         position: const LatLng(41.3850, 2.1650),
  //         icon: await _getMarkerBitmap(75,
  //             text: "3",
  //             color: Colors.purple)
  //     ),
  //   };
  // }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RutaCulturalViewModel>(
        create: (BuildContext context) => viewModel,
        child: Consumer<RutaCulturalViewModel>(builder: (context, value, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Google Maps Demo'),
            ),
            drawer: const MyDrawer("rutaCultural",
                username: "Superjuane", email: "juaneolivan@gmail.com"),
            body: viewModel.eventsListMap.status == Status.LOADING && viewModel.rutaGenerada? SizedBox(
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text("Estem generant la teva ruta...", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),)
                ],
              )),
            )
            : viewModel.eventsListMap.status == Status.COMPLETED ?  GoogleMap(
                myLocationEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: _iniCameraPosition,
                markers: markers,
                polylines: Set<Polyline>.of(polylines),
                onMapCreated: (GoogleMapController controller) {
                  debugPrint("================================== CREANDO MAPA puntos ===========================================");
                  for(Place p in viewModel.eventsListMap.data!) debugPrint("   Event: ${p.event.id}");
                  if (!_controller.isCompleted) _controller.complete(controller);
                  _manager.setMapId(controller.mapId);
                  _manager.setItems(viewModel.eventsListMap.data!);

                },
                onCameraMove: _manager.onCameraMove,
                onCameraIdle: _manager.updateMap)

            : GoogleMap(
                    zoomControlsEnabled: false,
              myLocationEnabled: false,
              mapType: MapType.normal,
                    initialCameraPosition: _iniCameraPosition,
                    markers: markers,
                    onMapCreated: (GoogleMapController controller) {
                      debugPrint("================================== CREANDO MAPA BASE ===========================================");
                      _controller.complete(controller);
                      //_manager.setMapId(controller.mapId);
                    },
                    //onCameraMove: _manager.onCameraMove,
                    //onCameraIdle: _manager.updateMap),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _navigateAndDisplaySelection(context);
              },
              label: Text('Generar Ruta Cultural'),
            ),
          );
        }));
  }
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<RutaCulturalArgs>(builder: (context) => const SelectionScreen()),
    );
    if (!mounted) return;
    setState(() {
      viewModel.rutaGenerada = true;
    });
    viewModel.generateRutaCultural(result);
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
    debugPrint("ENTRO EN MARKER BUILDER");
        if (!cluster.isMultiple) {
          debugPrint("cluster is simple");
          return Marker(
            markerId: MarkerId(cluster.getId()),
            position: cluster.location,
            infoWindow: InfoWindow(
                title: cluster.items.first.event.denominacio!,
                snippet: cluster.items.first.event.descripcio!,
                onTap: () {
                  Navigator.pushNamed(context, "/eventUnic",
                      arguments: EventUnicArgs(cluster.items.first.event.id!));
                }),
            icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
                text: '!',
                color: cluster.items.last.color),
          );
        }
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
            // if(!cluster.isMultiple) Navigator.pushNamed(
            //     context,
            //     "/eventUnic",
            //     arguments: EventUnicArgs(cluster.items.first.event.id!)
            // );
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null,
              color: cluster.items.last.color),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size,
      {String? text, Color? color}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    Paint paint1 = Paint()..color = Colors.red;
    if (color != null) paint1 = Paint()..color = color;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  void paintPolylines() {

  }
  // _addPolyLine() {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(
  //       polylineId: id, color: Colors.red, points: polylineCoordinates);
  //   polylines[id] = polyline;
  //   setState(() {});
  // }
  //
  // _getPolyline() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       googleAPiKey,
  //       PointLatLng(_originLatitude, _originLongitude),
  //       PointLatLng(_destLatitude, _destLongitude),
  //       travelMode: TravelMode.driving,
  //       wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }
  //   _addPolyLine();
  // }
}


