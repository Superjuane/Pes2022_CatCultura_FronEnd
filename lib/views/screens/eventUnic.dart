
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:CatCultura/constants/theme.dart';
import 'package:CatCultura/viewModels/EventUnicViewModel.dart';
import 'package:CatCultura/views/widgets/eventContainer.dart';
import 'package:CatCultura/views/widgets/myDrawer.dart';

import '../../data/response/apiResponse.dart';

class EventUnic extends StatelessWidget {
  EventUnic({super.key, required this.eventId});
  EventUnicViewModel viewModel = EventUnicViewModel();// = EventsViewModel();
  String eventId;

  @override
  void initState() {
    debugPrint("initializing state of EventUnic");
    // viewModel.selectEventById(eventId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("building EventUnic");
    viewModel.selectEventById(eventId);
    return ChangeNotifierProvider<EventUnicViewModel>(
        create: (BuildContext context) => viewModel,
        child: Consumer<EventUnicViewModel>(builder: (context, value, _) {
          return Scaffold(
              appBar: AppBar(
                title: Text("EVENT UNIC"),
                backgroundColor: MyColorsPalette.red,

                actions: <Widget> [
                  IconButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/opcions-Esdeveniment');
                      },
                      icon: Icon(Icons.settings)
                  ),
                ],
              ),
              drawer: MyDrawer(""),
              body: Padding(
                padding: const EdgeInsets.only(top:10.0),
                child:  viewModel.eventSelected.status == Status.LOADING? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(child: CircularProgressIndicator()),
                ):
                        viewModel.eventSelected.status == Status.ERROR? Text(viewModel.eventSelected.toString()):
                        viewModel.eventSelected.status == Status.COMPLETED? Column(
                          children: [
                            Expanded(
                              flex: 2,
                              //padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 1.0),
                              child: Row(
                                children: [
                                  //DATA-ESPAI-COMARCA
                                  Expanded(
                                    //flex: 4,
                                    child:
                                    EventInfoShort(event: viewModel.eventSelected.data!),
                                  ),
                                  //const Padding(padding: EdgeInsets.only(left: 10.0)),
                                ],
                              ),
                            ),
                            //const Padding(padding: EdgeInsets.only(top: 100.0)),
                            Expanded(
                              flex: 3,
                              child:Container(
                                  decoration: const BoxDecoration(
                                    // border: Border(
                                    //   top: BorderSide(
                                    //     color: Colors.grey,
                                    //     style: BorderStyle.solid,
                                    //     width: 3,
                                    //   ),
                                    // ),
                                  ),
                                  //padding: const EdgeInsets.only(top:25.0),
                                  //margin: const EdgeInsets.only(top: 50),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: EventContainerPersonalizedTabs(event: viewModel.eventSelected.data!)),
                                    ],
                                  )),
                            ),
                          ],
                        ):const Text("asdfasdf"),

                //EventContainer(eventId: eventId),
              )
          );
        }));
  }
}
/*switch (viewModel.eventSelected.status) {
                case Status.LOADING:
                  return SizedBox(
                    height: height,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                case Status.ERROR:
                  return Text(viewModel.eventSelected.toString());
                case Status.COMPLETED:
                  return  Column(
                          children: [
                            Expanded(
                              flex: 2,
                              //padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 1.0),
                              child: Row(
                                children: [
                                  //DATA-ESPAI-COMARCA
                                  Expanded(
                                    //flex: 4,
                                    child:
                                        EventInfoShort(event: viewModel.eventSelected.data!),
                                  ),
                                  //const Padding(padding: EdgeInsets.only(left: 10.0)),
                                ],
                              ),
                            ),
                            //const Padding(padding: EdgeInsets.only(top: 100.0)),
                            Expanded(
                              flex: 3,
                              child:Container(
                                  decoration: const BoxDecoration(
                                    // border: Border(
                                    //   top: BorderSide(
                                    //     color: Colors.grey,
                                    //     style: BorderStyle.solid,
                                    //     width: 3,
                                    //   ),
                                    // ),
                                  ),
                                  //padding: const EdgeInsets.only(top:25.0),
                                  //margin: const EdgeInsets.only(top: 50),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: EventContainerPersonalizedTabs(event: viewModel.eventSelected.data!)),
                                    ],
                                  )),
                            ),
                          ],
                        );

                default:
                  return const Text("asdfasdf");
       }*/