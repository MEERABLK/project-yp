import '../dependencies.dart';
import '../pages.dart';
// function: UI of the register screen with alert handling
class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterViewModel viewModel = RegisterViewModel();
  bool isGoogleSelected = false;
  String passwordWarning = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#0F2F4E"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor("#0F2F4E"),
              HexColor("#9380D5"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 300,
              height: 200,
            ),

            Padding(
              padding: const EdgeInsets.only(),
              child: Center(
                child: Container(
                  width: 400,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.68),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: HexColor("#292A30").withOpacity(0.44),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(40),
                                onTap: () {
                                  setState(() {
                                    isGoogleSelected = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: !isGoogleSelected
                                        ? Colors.black.withOpacity(0.8)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
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
                            ),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(40),
                                onTap: () async {
                                  bool isLogged = await login();
                                  if (isLogged) {
                                    Navigator.pushReplacement(
                                        context,
                                            MaterialPageRoute(builder: (_) => const MainShell()));
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isGoogleSelected
                                        ? Colors.black.withOpacity(0.8)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
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
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Create your legendary collection",
                        style:
                        TextStyle(color: Colors.white, fontFamily: 'Iceland'),
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
                        onChanged: (value) => viewModel.name = value,
                        decoration: InputDecoration(
                          hintText: 'cardmaster23',
                          hintStyle: TextStyle(color: HexColor("#464951")),
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
                        onChanged: (value) => viewModel.email = value,
                        decoration: InputDecoration(
                          hintText: 'your@email.com',
                          hintStyle: TextStyle(color: HexColor("#464951")),

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
                        obscureText: true,
                        onChanged: (value) {
                          viewModel.password = value;
                          if (!viewModel.isPasswordStrong(value)) {
                            // Show warning immediately
                            setState(() => passwordWarning = "Password must be 8+ chars");
                          } else {
                            setState(() => passwordWarning = "");
                          }
                        },
                        decoration: InputDecoration(
                          hintText: '...................',
                          errorText: passwordWarning.isEmpty ? null : passwordWarning,
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
                        obscureText: true,
                        onChanged: (value) => viewModel.confirmPassword = value,
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
                            style: ElevatedButton.styleFrom(backgroundColor: HexColor("#9380D5")),
                            onPressed: handleRegister,
                            child: Text('Create Account',style: TextStyle(color: Colors.white),),
                          ),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: HexColor("#DACFFF")),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text('Login',style: TextStyle(color: HexColor("#7C59A7"))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//   Future <bool> login() async
//   {
//    final user = await GoogleSignIn;
//    GoogleSignInAuthentication userAuth = await user!.authentication;
// var credential = GoogleAuthProvider.credential(idToken: userAuth.idToken,accessToken:userAuth.accessToken);
//
//  await FirebaseAuth.instance.signInWithCredential(credential);
//  return FirebaseAuth.instance.currentUser !=null ;
//   }


  Future<bool> login() async {
      // Trigger the authentication flow
    setState(() => isGoogleSelected = true);
      final user = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
       GoogleSignInAuthentication userAuth = await user!.authentication;

      // Create a new credential
      var credential = GoogleAuthProvider.credential(
        idToken: userAuth.idToken,
        accessToken: userAuth.accessToken,
      );

      // Once signed in, return the UserCredential
       await FirebaseAuth.instance.signInWithCredential(credential);
       return FirebaseAuth.instance.currentUser != null;
  }
  Future<void> handleRegister() async {
    String result = await viewModel.registerUser();

    if (result == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have successfully created an account!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }
}
