import 'package:CatCultura/models/EventResult.dart';
import 'package:flutter/cupertino.dart';
import 'package:CatCultura/data/response/apiResponse.dart';
import 'package:CatCultura/repository/EventsRepository.dart';
import 'package:flutter/material.dart';
import 'package:CatCultura/utils/auxArgsObjects/argsReturnParametersRutaCultural.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/Place.dart';

class RutaCulturalViewModel with ChangeNotifier {

  //INI
  final CameraPosition iniCameraPosition = const CameraPosition(target: LatLng(42.0, 1.6), zoom: 7.2);

  //VARIABLES
  final _eventsRepo = EventsRepository();
  ApiResponse<List<EventResult>> eventsList = ApiResponse.loading();
  ApiResponse<List<Place>> eventsListMap = ApiResponse.loading();

  //MAP {markers, lines...}
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  ApiResponse<Map<PolylineId, Polyline>> polylines = ApiResponse(Status.LOADING, <PolylineId, Polyline>{}, null) ;
  PolylineId? selectedPolyline;
  late PolylinePoints polylinePoints;
  String googleAPiKey = "AIzaSyAC-HdDDHsSjsvdpvVBoqhDHaGI0khcdyo";

  //STATES
  bool rutaGenerada = false;

  void mantaintEventsListToMap() {
    List<Place> aux = [];
    eventsList.data!.forEach((e) {aux.add(Place(event: e, color: Colors.blue));});
    eventsListMap = ApiResponse.completed(aux);
  }

  setEventsList(ApiResponse<List<EventResult>> response){
    eventsList = response;
    mantaintEventsListToMap();
    //paintRoute();
    //notifyListeners();
  }

  Future<void> generateRutaCultural(RutaCulturalArgs? args) async {
    eventsListMap.status = Status.LOADING;
    notifyListeners();
    await _eventsRepo.getRutaCultural(args!.longitud,args.latitud,args.radio).then ((value) async {
      setEventsList(ApiResponse.completed(value));
      await paintRoute().then((value){
        polylines.status = value;
        notifyListeners();
      });
    }).onError((error, stackTrace) =>
        setEventsList(ApiResponse.error(error.toString())));
  }

  _createPolylines(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude,
      Color c,
      int nId,
      ) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      polylineCoordinates = [];
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    String polyIDx = "polyID+$nId";
    // Defining an ID
    PolylineId id = PolylineId(polyIDx);

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: c,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines.data![id] = polyline;
  }

  Future<Status> paintRoute() async {
    List<Color> c = [Colors.blue, Colors.red];
    for(int i = 0; i < eventsListMap.data!.length - 1; ++i) {
      _createPolylines(eventsListMap.data![i].location.latitude,
          eventsListMap.data![i].location.longitude,
          eventsListMap.data![i+1].location.latitude,
          eventsListMap.data![i+1].location.longitude,c[i],i);
    }
    return Status.COMPLETED;
  }
}