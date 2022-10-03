import 'package:flutter/material.dart';


import 'package:tryproject2/constants/theme.dart';
import 'package:tryproject2/viewModels/HomeViewModel.dart';
import 'package:tryproject2/views/widgets/cardSmall.dart';
import 'package:tryproject2/views/widgets/CardSquare.dart';
import 'package:tryproject2/views/widgets/cardHorizontal.dart';
import 'package:tryproject2/views/widgets/myDrawer.dart';

// import 'package:tryproject2/lib/widgets/navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(viewModel.namePage),
          backgroundColor: MyColorsPalette.lightBlue,
        ),
        backgroundColor: MyColors.bgColorScreen,
        // key: _scaffoldKey,
        drawer: const MyDrawer("Home", username:"Superjuane", email:"juaneolivan@gmail.com"),
        body: Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CardHorizontal(
                      cta: "Ver articulo de ejemplo",
                      title: "Este es un articulo de ejemplo que al clicarlo aparece un popUp",
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/pro');
                      }),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardSmall(
                        cta: "View article",
                        title: "b",
                        tap: () {
                          Navigator.pushNamed(context, '/pro');
                        }),
                    CardSmall(
                        cta: "View article",
                        title: "c",
                        tap: () {
                          Navigator.pushNamed(context, '/pro');
                        })
                  ],
                ),
                const SizedBox(height: 8.0),
                CardHorizontal(
                    cta: "View article",
                    backcolor: MyColors.lightRed,
                    title: "b",
                    img: "https://media.istockphoto.com/photos/giant-wheel-on-the-funfair-picture-id1140409109?k=20&m=1140409109&s=612x612&w=0&h=IggXib0wrGp48wP4dell1fCWazveLOSsxu-i--kZeho=",
                    onTap: () {
                      Navigator.pushNamed(context, '/pro');
                    }),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: CardSquare(
                      cta: "View article",
                      title: "d",
                      tap: () {
                        Navigator.pushNamed(context, '/pro');
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
