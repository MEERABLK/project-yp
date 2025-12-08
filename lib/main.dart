import 'dependencies.dart';
import 'pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize api key like google map key like giving lat long of paris in rl has a api key
  await Firebase.initializeApp(
      //everything come from the JSON file
      //current key is api key app number is appid
      //mobilesdk_app_id is messagingSenderId
      //projectId is projectId
      options: FirebaseOptions(
          apiKey: "AIzaSyD68YP8O-4R1EHl6sOYr69kPYX-Ec5wqvo",
          appId: "379312428600",
          messagingSenderId: "1:379312428600:android:96dc5d30a71d20efa2f8cd",
          projectId: "project-yp-55c23"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  FirebaseAuth.instance.currentUser != null ? HomeView():RegisterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

