import 'package:flutter/material.dart';
import 'package:mcs/Themes/color.dart';
// import 'homepage.dart';
import 'package:mcs/providers/app_provider.dart';
import 'package:mcs/screen/homepage.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';


class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    // with SingleTickerProviderStateMixin
{
  @override
  // late AnimationController _controller;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(vsync: this);
  // }
  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        bool isLampShouldBeOn = provider.currentLight < provider.ldrThreshold;
        Color bgColor = isLampShouldBeOn ? TemaWarna.green : TemaWarna.reverse;
        Color reverseBgColor = isLampShouldBeOn ? TemaWarna.reverse : TemaWarna.green;
        // 2. TRIGGER ANIMATION AUTOMATICALLY
        // We check if the controller has a duration before trying to use it.
        // The duration is set by the Lottie.asset's onLoaded callback.
        // Put this inside the Consumer builder
        // bool isLampShouldBeOn = provider.currentLight < provider.ldrThreshold;
        //
        // if (_controller.duration != null) {
        //   if (isLampShouldBeOn) {
        //     _controller.animateTo(84 / 120); // Move to Dark state
        //   } else {
        //     _controller.animateTo(52 / 120); // Move to Light state
        //   }
        // }

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Text("AUTOMATIC SWITCH", style: provider.font1),
            backgroundColor: TemaWarna.white,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Container(
                // Adjusted size to fit the new controls
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: reverseBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text("LDR Sensor Settings", style: provider.font1),
                    const SizedBox(height: 30),

                    // 1. Visual Gauge for Light Intensity
                    // 1. Visual Gauge for Light Intensity
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            // Ensure we don't divide by zero or pass a null
                            value: (provider.currentLight / 100).clamp(0.0, 1.0),
                            strokeWidth: 15,
                            backgroundColor: TemaWarna.offwhite,
                            color: TemaWarna.day,
                          ),
                        ),
                        Text("${provider.currentLight}%", style: provider.font1),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // 2. Sensitivity Slider (REINSTATED)
                    Text("Sensitivity: ${provider.ldrThreshold.round()}%", style: provider.font1),
                    Slider(
                      value: provider.ldrThreshold.toDouble(),
                      min: 0,
                      max: 100,
                      activeColor: TemaWarna.day,
                      onChanged: (val) {
                        setState(() {
                          // This tells the UI to move the slider immediately
                          provider.setThreshold(val.round());
                        });
                      },
                    ),
                  ],
                ),
              ),

              // const Spacer(), // This is now inside the Column
          //
          //     Lottie.asset(
          //       'assets/catWlamp.json',
          //       controller: _controller,
          //       height: 168,
          //       onLoaded: (composition) {
          //         _controller.duration = composition.duration;
          //         double totalFrames = composition.durationFrames;
          //         _controller.value = 84 / totalFrames;                 },
          //     ),
          //
          //     // const SizedBox(height: 20),
            ],
          ),



       // Padding above the bottom bar

          bottomNavigationBar: BottomAppBar(
            color: TemaWarna.white,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // Turn OFF Auto Mode before switching back
                    provider.setAutoMode(false);

                    // Navigates back to Homepage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.favorite, // Icon changed back to home for navigation clarity
                    color: TemaWarna.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
