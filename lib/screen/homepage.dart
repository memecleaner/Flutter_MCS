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
  // bool lampOn = false;
  late AnimationController _controller;

  final double nightFrame = 0.25;  // 30 / 120
  final double dayFrame   = 0.75;  // 90 / 120

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {}); // update container background smoothly
    });

  }

  Color get animatedBackground {
    double t = ((_controller.value - nightFrame) / (dayFrame - nightFrame))
        .clamp(0.0, 1.0);

    return Color.lerp(
      TemaWarna.night,
      TemaWarna.day,
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
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: screenBackground,
        appBar: AppBar(
          title: Text("MANUAL SWITCH",
          style: provider.font1,
          ),
          backgroundColor: TemaWarna.offwhite,
          automaticallyImplyLeading: false,
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
                                height: 620,
                                width: 450,
                                margin: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: animatedBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 67, bottom: 100),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            final provider = context.read<AppProvider>();
                                            provider.setLamp(!provider.lampState);

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
                                              ? TemaWarna.offwhite : TemaWarna.blue,
                                          shape: const CircleBorder(),
                                          minimumSize: const Size(170, 170),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            provider.lampState
                                                ? Icons.power_settings_new : Icons.power_settings_new,
                                            size: 100,
                                            color: provider.lampState
                                                ? TemaWarna.black : TemaWarna.offwhite,
                                          ),
                                        ),

                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: OverflowBox(
                                          maxHeight: 500,     // force big height to prevent shrinking
                                          minHeight: 200,
                                          maxWidth: 450,
                                          child: Lottie.asset(
                                            'assets/day_night.json',
                                            controller: _controller,
                                            fit: BoxFit.contain,
                                            onLoaded: (composition) {
                                              _controller.duration = composition.duration;
                                              _controller.value = nightFrame;
                                            },
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
                    // 1. Get the provider (set listen to false since we are in a function)
                    final provider = Provider.of<AppProvider>(context, listen: false);

                    // 2. Automatically activate Auto Mode in Firebase
                    provider.setAutoMode(true);

                    // 3. Navigate to the Second Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecondPage(),
                      ),
                    ).then((_) {
                      // 4. THIS IS THE TRICK:
                      // This code runs when the user comes BACK from the second page.
                      // We automatically turn Auto Mode OFF.
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
