//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/response/apiResponse.dart';
import '../../models/UserResult.dart';
import 'package:CatCultura/viewModels/UsersViewModel.dart';

import '../../constants/theme.dart';
//import 'package:flutter/services.dart';
//import 'package:tryproject2/constants/theme.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: StatefulLogin(),
    );
  }
}

class StatefulLogin extends StatefulWidget {
  const StatefulLogin({Key? key}) : super(key: key);

  @override
  State<StatefulLogin> createState() => _StatefulLoginState();
}

class _StatefulLoginState extends State<StatefulLogin> {
  final UsersViewModel viewModel = UsersViewModel();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    viewModel.fetchUsersListApi();
    return ChangeNotifierProvider<UsersViewModel>(
        create: (BuildContext context) => viewModel,
        child: Consumer<UsersViewModel>(builder: (context, value, _) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0,0,0,0),
        child: GestureDetector(
          onTap: () {
          FocusScope.of(context).unfocus();
          },
          child:
          viewModel.waiting? ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 400,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                  //child: Image.network("https://cdn.logo.com/hotlink-ok/logo-social.png", height: 18.0 ,scale: 1.0,),
                  //child: Image.file(File("C:/Users/Juane Olivan/Documents/FlutterTest/tryproject2/resources/img/logo.png"), height: 18.0 ,scale: 1.0,),
                  child: Image.asset('resources/img/logo.png', scale: 2.0,)
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration (
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Nom d'usuari"
                  ),
                ),
              ),
              viewModel.errorN == 1? const Text("No funciona"): Text(""),

              Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: TextField(
                  obscureText: !showPassword,
                  decoration: InputDecoration (
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = ! showPassword;
                        });
                      },
                      icon: const Icon (
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    labelText: "Contrasenya",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  child: const Text('Has oblidat la contrassenya?',
                      style: TextStyle (
                      color:Colors.deepOrangeAccent
                  )),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: ElevatedButton(
                    style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent)),
                    child: const Text('Iniciar sessió',
                      style: TextStyle (
                          color:Colors.white
                      ),
                    ),
                    onPressed: () {
                      print(nameController.text);
                      print(passwordController.text);
                      viewModel.iniciarSessio(nameController.text, passwordController.text);
                      //Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                      //Navigator.popAndPushNamed(context, '/home');
                      //Navigator.pushReplacementNamed(context, '/home');
                    },
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Encara no tens un compte?'),
                  TextButton(
                    child: const Text(
                      'Crear compte',
                      style: TextStyle (
                          color:Colors.deepOrangeAccent
                      ),
                    ),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/createUser');
                    },
                  )
                ],
              ),
              TextButton(
                child: const Text(
                  'Entrar com convidat',
                  style: TextStyle (
                      color:Colors.deepOrangeAccent
                  ),
                ),
                onPressed: () {
                  //signup screen
                },
              ),
            ],
          )
              : viewModel.mainUser.status == Status.LOADING? const SizedBox(
            child: Center(child: CircularProgressIndicator()),
          )
              : viewModel.mainUser.status == Status.ERROR? Text(viewModel.mainUser.toString())
              : viewModel.mainUser.status == Status.COMPLETED? A(): Text("d")
        )
    );
        }));
  }
}

class A extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Navigator.popAndPushNamed(context, '/home');
        return Container();
  }
}
