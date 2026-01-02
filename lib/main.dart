import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mcs/firebase_options.dart';
import 'package:mcs/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:mcs/screen/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(
          create: (context) {
            final provider = AppProvider();
            provider.listenLamp(); // <-- START LISTENING HERE
            return provider;
          },
        ),
        ],
      child: MaterialApp(
        title: 'Proyek MCS',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
