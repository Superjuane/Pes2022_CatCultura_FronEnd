import 'package:CatCultura/models/EventResult.dart';
import 'package:flutter/cupertino.dart';
import 'package:CatCultura/data/response/apiResponse.dart';
import 'package:CatCultura/repository/EventsRepository.dart';

class EventsViewModel with ChangeNotifier{
  final _eventsRepo = EventsRepository();

  ApiResponse<List<EventResult>> eventsList = ApiResponse.loading();
  List<String> suggestions = [];
  int count = 0;
  Set<int> loadedPages = {};

 void refresh(){
   eventsList.status = Status.LOADING;
   notifyListeners();
 }

  setEventsList(ApiResponse<List<EventResult>> response){
    //debugPrint("before eventlist = response (with exit)");
    //notifyListeners();
    eventsList = response;
    //debugPrint("------------list of eventList-------------");
    //for(EventResult e in eventsList.data!) debugPrint(e.denominacio!);
    // suggestions = [];
    // int suggestLength = 1;// = eventsList.data!.length%10;
    // for (int e = 0; e < suggestLength; ++e) {
    //   suggestions.add(eventsList.data![e].id!);
    // }
    notifyListeners();
  }

  void addToEventsList(ApiResponse<List<EventResult>> apiResponse) {
    if(apiResponse.status == Status.COMPLETED && eventsList.status == Status.COMPLETED){
      List<EventResult> aux = eventsList.data!;
      aux.addAll(apiResponse.data!);
      eventsList = ApiResponse.completed(aux);
      int a = 0;
    }
    else {

    }
    notifyListeners();
  }

  Future<void> fetchEvents() async {
      await _eventsRepo.getEvents().then((value) {
      setEventsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) =>
        setEventsList(ApiResponse.error(error.toString())));
      loadedPages.add(0);
      count++;
      debugPrint("EvViewModel. times accesed fetchEvents: $count");
  }

  Future<void> redrawWithFilter(String filter) async{
    await _eventsRepo.getEventsWithFilter(filter).then((value) {
      debugPrint("---------------LIST WITH FILTER---------------------");
      for(EventResult e in value) debugPrint("  -${e.denominacio!}");
      setEventsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) =>
        setEventsList(ApiResponse.error(error.toString())));
    debugPrint("EvViewModel, accesed from filter redraw");
  }

  Future<void> fetchEventsNextPage() async {
    await _eventsRepo.getEventsWithParameters(loadedPages.last+1,null, null).then((value) {
      addToEventsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) =>
        setEventsList(ApiResponse.error(error.toString())));
    loadedPages.add(loadedPages.last+1);
    count++;
    debugPrint("EvViewModel. times accesed fetchEvents: $count");
  }


  // @override
  // void dispose() {
  // }

}