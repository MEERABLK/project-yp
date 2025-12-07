import '../dependencies.dart';
import '../pages.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // we are creating a db folder that is being referred as Users
  // which is created as Instance (Root Collection/folder)
  // CollectionReference contains all reference points from firebase
  //the entire store data could be accessed through the instance names USERS
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  //what we want to add to the db
  String name = '';
  String password = '';

  Future<void> login() async {
    if (name.isEmpty || password.isEmpty) {
      showMsg("Please fill all fields");
      return;
    }
    //check first if it matches one of the pass and name in db
    QuerySnapshot query = await users
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        // fetch the content from db
        .get();

    // get all list in the snapshot of query
    if (query.docs.isNotEmpty) {
      showMsg("Login Successful!");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    } else {
      showMsg("Invalid Username or Password");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: HexColor("#0F2F4E"),
        //to remove back arrow for returning to the previous page
        automaticallyImplyLeading: false,),


      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [HexColor("#0F2F4E"), HexColor("#9380D5")],
            begin: Alignment.topCenter, // Start of the gradient
            end: Alignment.bottomCenter, // End of the gradient
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 5),
            Image.asset('asset/logo.png', width: 300, height: 300),

            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Container(
                  width: 400,

                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(

                    // 68% opacity
                    color: Colors.black.withOpacity(0.68),
                    borderRadius: BorderRadius.circular(5),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: HexColor("#292A30").withOpacity(0.44),   // Light background behind both
                    borderRadius: BorderRadius.circular(40),
                  ),child:
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
                                  fontFamily: 'Iceland',
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
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
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
                      const SizedBox(height: 15),
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Iceland',
                        ),
                      ),
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
                          hintStyle: TextStyle(color: HexColor("#464951")),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
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
                          hintStyle: TextStyle(color: HexColor("#464951")),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: HexColor("#DACFFF")),

                        onPressed: login,
                        child: Text('Login',style: TextStyle(color: HexColor("#7C59A7"))),
                      ),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: HexColor("#9380D5")),

                            onPressed: ()
                              {
                                Navigator.pop(context);
                              },
                              child: Text('Create Account',style: TextStyle(color: Colors.white),),),


                        ],
                  ),
      ],
                ),

                //
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
