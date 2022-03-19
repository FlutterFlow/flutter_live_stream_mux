import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_mux_live/firebase_options.dart';
import 'package:flutter_mux_live/res/app_theme.dart';
import 'package:flutter_mux_live/screens/authentication/login_page.dart';
import 'package:flutter_mux_live/screens/stream/dashboard_page.dart';
import 'package:video_stream/camera.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint(e.toString());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Stream',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.primary,
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const DashboardPage(),
    );
  }
}
