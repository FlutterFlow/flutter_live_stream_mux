import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_mux_live/firebase_options.dart';
import 'package:flutter_mux_live/res/app_theme.dart';
import 'package:flutter_mux_live/screens/authentication/login_page.dart';
import 'package:flutter_mux_live/screens/stream/dashboard_page.dart';
import 'package:flutter_mux_live/utils/authentication_client.dart';
import 'package:flutter_mux_live/utils/mux_client.dart';
import 'package:video_stream/camera.dart';

import 'screens/initial_page.dart';

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
      // home: const HomePage(),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : DashboardPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MuxClient _muxClient;
  late final AuthenticationClient _authClient;

  @override
  void initState() {
    _muxClient = MuxClient();
    _authClient = AuthenticationClient();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(),
          ElevatedButton(
            onPressed: () async {
              await _authClient.registerUsingEmailPassword(
                name: 'Test User',
                email: 'test@example.com',
                password: '1234567',
              );
            },
            child: const Text('Authenticate user'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _muxClient.createLiveStream();
            },
            child: const Text('Start stream'),
          ),
        ],
      ),
    );
  }
}
