import 'dependencies.dart';
import 'pages.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize api key like google map key like giving lat long of paris in rl has a api key
  await Firebase.initializeApp(
    //everything come from the JSON file
    //curent key is api key app number is appid
    //mobilesdk_app_id is messagingSenderId
    //projectId is projectId
      options: FirebaseOptions(apiKey:"AIzaSyD68YP8O-4R1EHl6sOYr69kPYX-Ec5wqvo",
          appId: "379312428600",
          messagingSenderId: "1:379312428600:android:96dc5d30a71d20efa2f8cd",
          projectId: "project-yp-55c23"));
  runApp( MyApp());

}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // we are creating a db folder that is being referred as Users
  // which is created as Instance (Root Collection/folder)
  // CollectionReference contains all reference points from firebase
  //the entire store data could be accessed through the instance names USERS
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  //what we want to add to the db
  String name = '';
  String email ='';
  String password = '';
  String confirmPassword = '';

  //function to add the data to the cloud
  Future<void> adduser() async {
    if (name.isNotEmpty && password.isNotEmpty && email.isNotEmpty
        && confirmPassword.isNotEmpty) {
      //access by the name of the key
      //so that fetching would be feasible by using Map
      await users.add({'name': name, 'email':email, 'password': password,'confirmPassword':confirmPassword});
      //change to the null value to write the second data
      setState(() {
        name = '';
        email='';
        password = '';
        confirmPassword='';
      }
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have Successfully Created An Account, \nPlease Login to Continue')));

      Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:   HexColor("#0F2F4E"),

      ),
      body:
      Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor("#0F2F4E"),
              HexColor("#9380D5"),

            ],
            begin: Alignment.topCenter, // Start of the gradient
            end: Alignment.bottomCenter, // End of the gradient
          ),
        ),
        child:
        Column(

          children: [

           Image.asset('asset/logo.png',width: 300,height: 200,),

        Padding(
          padding: const EdgeInsets.only(),
          child: Center(
            child: Container(
            width: 600,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  // 68% opacity
                  color: Colors.black.withOpacity(0.68),
                borderRadius: BorderRadius.circular(5)
              ),


child:
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

    Container(
    padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: HexColor("#292A30").withOpacity(0.44),   // Light background behind both
                borderRadius: BorderRadius.circular(40),
              ),
     child:
     Row(
    children: [

    Expanded(
        child: Container(
        decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(40),
            ),
        alignment: Alignment.center,
        child: Text(
          "Email",
          style: TextStyle(
              fontFamily: 'Iceland', color: Colors.white, fontSize: 20),
        ),
      ),
    ),
    Expanded(
    child: Container(
    alignment: Alignment.center,
    child: Text(
    "Google",
    style: TextStyle(
    fontFamily: 'Iceland',
    color: Colors.white60,
    fontSize: 20),
    ),
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 15),
              Text("Create your legendary collection",style: TextStyle(color: Colors.white,fontFamily:'Iceland' ),),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Username",
                  style: TextStyle(
                    fontFamily: "Iceland",
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
              //store in the variable the value
              onChanged: (value) => name = value,
              decoration: InputDecoration(

                  hintText: 'cardmaster23',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

              ),
              ),
            ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontFamily: "Iceland",
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                //store in the variable the value
                onChanged: (value) => email = value,
                decoration: InputDecoration(

                  hintText: 'your@email.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),

                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: TextStyle(
                    fontFamily: "Iceland",
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            TextField(
              style: TextStyle(color: Colors.white),
              onChanged: (value) => password = value,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: '...................',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              ),

            ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Confirm Password",
                  style: TextStyle(
                    fontFamily: "Iceland",
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                onChanged: (value) => confirmPassword = value,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '...................',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

              ),
              SizedBox(height: 20,),

              Row(
                children: [


              ElevatedButton(onPressed: adduser, child: Text('Create Account')),
SizedBox(height: 20,),


              ElevatedButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
                  child: Text('Login')),
      ],
      ),

            ],
            ),
            ),
            //


            ),
        ),
        ],
      ),
    ),
    );
  }
}
