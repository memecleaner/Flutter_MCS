// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mcs/Themes/color.dart';
//
// class AppProvider extends ChangeNotifier {
//   TextStyle font1 = GoogleFonts.outfit(
//   fontSize: 20, fontWeight: FontWeight.w700, color: TemaWarna.black);
//   TextStyle font2 = GoogleFonts.outfit(
//     fontSize: 15, fontWeight: FontWeight.w400, color: TemaWarna.blue);
//   TextStyle font3 = GoogleFonts.akatab(
//     fontSize: 15, fontWeight: FontWeight.w400, color: TemaWarna.offwhite);
//
// }
//
// Future () async {
//   final dataled = database.child('DataLed');
//   dataled.onValue.listen((event) {
//     final getDataLed = event.snapshot;
//     OutputLed = getDataLed.value;
//     notifyListeners();
//   }
//   );
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcs/Themes/color.dart';
import 'package:firebase_database/firebase_database.dart';

class AppProvider extends ChangeNotifier {

  // ===== YOUR EXISTING STYLES =====
  TextStyle font1 = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: TemaWarna.black,
  );

  TextStyle font2 = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: TemaWarna.offwhite,
  );

  TextStyle font3 = GoogleFonts.akatab(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: TemaWarna.offwhite,
  );

  // // ===== IOT STATE =====
  // final DatabaseReference _db =
  // FirebaseDatabase.instance.ref();
  //
  // bool outputLed = false;
  //
  // bool get lampState => outputLed;
  //
  // // ===== LISTEN FROM FIREBASE =====
  // void listenLamp() {
  //   _db.child('dataLed').onValue.listen((event) {
  //     final value = event.snapshot.value;
  //     if (value != null) {
  //       outputLed = value as bool;
  //       notifyListeners();
  //     }
  //   });
  // }
  //
  // // ===== SEND TO FIREBASE =====
  // void setLamp(bool value) {
  //   _db.child('dataLed').set(value);
  // }

  // ===== IOT STATE =====
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  bool outputLed = false;     // Manual LED Status
  bool autoMode = false;      // Auto Mode Toggle
  int currentLight = 0;       // Live Sensor Value (0-100)
  int ldrThreshold = 40;      // Sensitivity (0-100)

  bool get lampState => outputLed;

  // Constructor starts the listener automatically
  AppProvider() {
    listenLamp();
  }

  // ===== LISTEN FROM FIREBASE =====
  void listenLamp() {
    // 1. Manual LED Switch
    _db.child('dataLed').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        outputLed = value as bool;
        notifyListeners();
      }
    });

    // 2. Auto Mode Switch
    _db.child('AutoMode').onValue.listen((event) {
      if (event.snapshot.value != null) {
        autoMode = event.snapshot.value as bool;
        notifyListeners();
      }
    });

    // 3. Real-time Light Percentage
    // 3. Real-time Light Percentage
    _db.child('CurrentLightLevel').onValue.listen((event) {
      final value = event.snapshot.value;
      print("DEBUG: Firebase received: $value"); // ADD THIS LINE
      if (value != null) {
        currentLight = (value as num).toInt();
        notifyListeners();
      } else {
        print("DEBUG: Value is NULL at this path!");
      }
    });

    // 4. Threshold Percentage
    _db.child('LdrThreshold').onValue.listen((event) {
      if (event.snapshot.value != null) {
        ldrThreshold = int.tryParse(event.snapshot.value.toString()) ?? 40;
        notifyListeners();
      }
    });
  }

  // ===== SEND TO FIREBASE =====
  void setLamp(bool value) {
    _db.child('dataLed').set(value);
  }

  void setAutoMode(bool value) {
    _db.child('AutoMode').set(value);
  }

  // void setThreshold(int value) {
  //   _db.child('LdrThreshold').set(value);
  // }

  // Inside app_provider.dart
  void setThreshold(int value) {
    ldrThreshold = value; // Update local variable first
    notifyListeners();    // Tell the UI to rebuild immediately
    _db.child('LdrThreshold').set(value); // Then send to Firebase
  }



}

