import 'dart:convert';

import 'package:CatCultura/models/SessionResult.dart';
import 'package:flutter/material.dart';
import 'package:CatCultura/data/response/apiResponse.dart';
import 'package:CatCultura/models/UserResult.dart';
import 'package:CatCultura/repository/UsersRepository.dart';

import '../utils/Session.dart';

class LoginViewModel with ChangeNotifier{
  final _usersRepo = UsersRepository();
  final sessio = Session();
  final Codec<String, String> stringToBase64 = utf8.fuse(base64);

  ApiResponse<SessionResult> mainUser = ApiResponse.loading();

  bool waiting = true;
  int errorN = 0;


  setUsersSelected(ApiResponse<SessionResult> response, String? auth){
    // mainUser = response;
    mainUser = response;
    if(response.status == Status.COMPLETED)sessio.data = response.data!;
    // if(auth != null) sessio.set("authorization", auth);
    notifyListeners();
  }

  Future<void> iniciarSessio(String name, String pass) async {
    late String encoded = stringToBase64.encode("$name:$pass");
    late String auth = "Basic $encoded";
    sessio.set("authorization", auth);

    debugPrint("before send '/login', authorization for: $name - $pass");

    await _usersRepo.iniSessio().then((value) {
      debugPrint("OK");
      setUsersSelected(ApiResponse.completed(value), auth);
    }).onError((error, stackTrace){
        debugPrint("NOT OK");
        setUsersSelected(ApiResponse.error(error.toString()),null);});
    waiting = false;
    notifyListeners();
  }

  Future<void> crearcompte(String n, String u, String e, String p) async {
    //if(n != "") {
    UserResult user = UserResult();
    user.nameAndSurname = n;
    user.username = u;
    user.email = e;
    user.password = p;
    user.points = "0";
    late String encoded = stringToBase64.encode("$u:$p");

    await _usersRepo.postCreaCompte(user).then((value) {
      setUsersSelected(ApiResponse.completed(value), "completed");
    }).onError((error, stackTrace) =>
        setUsersSelected(ApiResponse.error(error.toString()), null));
    //} else errorN = 1;
    waiting = false;
    // notifyListeners();
  }
}