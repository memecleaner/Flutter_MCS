import 'package:flutter/material.dart';
import 'package:mcs/Themes/color.dart';
import 'package:mcs/providers/app_provider.dart';
import 'package:provider/provider.dart';

class cobaPage extends StatefulWidget {
  const cobaPage({super.key});

  @override
  State<cobaPage> createState() => _cobaPageState();
}

class _cobaPageState extends State<cobaPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState> ();
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: TemaWarna.blue,
        drawer: Drawer(
          backgroundColor: TemaWarna.blue,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [TemaWarna.night, TemaWarna.day],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(25),
                    ),
                     boxShadow: const[
                       BoxShadow( color: Colors.black26, blurRadius: 5, offset: Offset(0, 5)),
                     ]
                ),
                  child: Container(
                    padding: EdgeInsets.only(top: 30, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 13),
                        child: Text("Profile", style: appProvider.font3,)
                        )
                      ],
                    )
                  ),
              )
            ],
          )
        ),
        body:
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.only(top: 50, bottom: 10, left: 15, right: 15),
            decoration:
          BoxDecoration(
            gradient: LinearGradient(colors: [TemaWarna.night, TemaWarna.day],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
        boxShadow: const[
          BoxShadow( color: Colors.black26, blurRadius: 5, offset: Offset(0, 5)),
        ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){
                        _scaffoldKey.currentState!.openDrawer();

                      },
                          icon:
                      Icon(Icons.menu, color: TemaWarna.offwhite,)
                      ),
                      Text("apa?", style: appProvider.font3,)

                    ])
              ,
        ]),
            )
        ]
    )
        ),
    );
  }
}
