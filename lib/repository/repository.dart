import 'package:CatCultura/data/response/apiResponse.dart';
import 'package:CatCultura/models/EventResult.dart';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import 'package:CatCultura/data/network/networkApiServices.dart';
// import '../res/app_url.dart'; DE DONDE SALEN LAS URLS PARA LAS LLAMADAS HTTP

class Repository {
  final baseUrl = "http://10.4.41.41:8081/";
  final NetworkApiServices _apiServices = NetworkApiServices();
  List<EventResult> _cachedEvents = [];

  Future<List<EventResult>> getEvents() async {
    debugPrint("entro a repo.getEvents()");
    try {
      debugPrint("before response = api.get");
      dynamic response = await _apiServices.getGetApiResponse("${baseUrl}events");
      debugPrint("after response = api.get");

      List<EventResult> res = List.from(response.map((e) => EventResult.fromJson(e)).toList());
      _cachedEvents = res;

      return res;

    } catch (e) {
      rethrow;
    }
  }

  Future<EventResult> getEventById(String id) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse("${baseUrl}events/$id");
      return EventResult.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }


}