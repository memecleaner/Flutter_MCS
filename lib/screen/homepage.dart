import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mcs/Themes/color.dart';
import 'package:mcs/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'secondpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late AnimationController _controller; //variabel AnimationController buat set si lottie

  final double nightFrame = 0.25;  // 30 / 120 karna set nya di frame #30
  final double dayFrame   = 0.75;  // 90 / 120 ini set framenya #90

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {}); // update container background smoothly
    });

  }
// buat ganti warna background otomatis
  Color get animatedBackground {
    double t = ((_controller.value - nightFrame) / (dayFrame - nightFrame))
        .clamp(0.0, 1.0);

    return Color.lerp(
      TemaWarna.night, // kalo led mati warna biru (night dr temawarna di color.dart)
      TemaWarna.day, // led nyala warna kuning.
      t,
    )!;
  }


  Color get screenBackground {
    double t = ((_controller.value - nightFrame) / (dayFrame - nightFrame))
        .clamp(0.0, 1.0);

    return Color.lerp(
      TemaWarna.night,
      TemaWarna.day,
      t,
    )!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>( // connect ke app_provider
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: screenBackground,
        appBar: AppBar(
          title: Text("MANUAL SWITCH", // judul
          style: provider.font1, // style nya sesuai yang udah di set di app_provider
          ),
          centerTitle: true,
          backgroundColor: TemaWarna.offwhite, //warna appbar
          automaticallyImplyLeading: false, //ngilangin back button buat ke halaman sebelumnya
        ),
          body:
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10
                ),
                child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                      // Container(
                      //   width: MediaQuery.of(context).size.height /2,
                      //   margin: EdgeInsets.symmetric(
                      //     vertical: 15,
                      //     horizontal: 15,
                      //   ),
                      //   decoration: BoxDecoration(color: TemaWarna.grey,
                      //   borderRadius: BorderRadius.circular(20),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [Center(child: Text("MANUAL", style: provider.font1,))],
                      // )
                      // ),

                              Container(
                                height: 600,
                                width: 300,
                                margin: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: animatedBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50 ),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            final provider = context.read<AppProvider>();
                                            provider.setLamp(!provider.lampState); //kirim command ke firebase

                                            //untuk animasi otomatis ketika di klik
                                            if (!provider.lampState) {
                                              _controller.animateTo(dayFrame,
                                                  duration: const Duration(milliseconds: 1200),
                                                  curve: Curves.easeInOut);
                                            } else {
                                              _controller.animateTo(nightFrame,
                                                  duration: const Duration(milliseconds: 1200),
                                                  curve: Curves.easeInOut);
                                            }
                                          },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: provider.lampState
                                              ? TemaWarna.offwhite : TemaWarna.blue, //buat ganti ganti warna button pas di click
                                          shape: const CircleBorder(), //buttonnya biar bulet (lingkaran)
                                          minimumSize: const Size(170, 170), //uk button
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            provider.lampState
                                                ? Icons.power_settings_new : Icons.power_settings_new, //logo power yg dalem si button
                                            size: 100,
                                            color: provider.lampState
                                                ? TemaWarna.black : TemaWarna.offwhite, //biar logo powernya ganti warna pas di click
                                          ),
                                        ),

                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Transform.scale(
                                          scale: 1.0,
                                          // maxHeight: 500,     // force big height to prevent shrinking
                                          // minHeight: 200,
                                          // maxWidth: 450,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 0.5
                                            ),
                                            //nambah lottie
                                            child: Lottie.asset(
                                              'assets/day_night.json', //path nya
                                              controller: _controller, //animationnya yg tadi udah di set
                                              onLoaded: (composition) {
                                                _controller.duration = composition.duration;
                                                _controller.value = nightFrame; //buat set awalan (starting point)
                                                                            // jadi ga mulai dr frame #0 tapi ke #30
                                              },
                                            ),
                                          ),

                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )

          ],
                  ),
                ]
                ),
                      // Padding(
                        // padding: const EdgeInsets.all(100.0),
                        // child: Lottie.asset('loading.json'),
                      // )
                             ]
                            ),
              ),
          bottomNavigationBar: BottomAppBar(
            color: TemaWarna.grey,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // set si provider ke false
                    final provider = Provider.of<AppProvider>(context, listen: false);
                    //otomatis aktivasi mode auto di firebase
                    provider.setAutoMode(true);
                    // navigasi ke halaman 2 (yg auto mode)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecondPage(),
                      ),
                    ).then((_) {
                      //biar pas balik lagi dari halaman 2 (halaman auto)....
                      //si halaman pertama (manual mode) balik lagi settingannya ke false
                      provider.setAutoMode(false);
                    });
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: TemaWarna.blue,
                  ),
                ),
          ]),
          )
        );
      }
    );
  }
}
