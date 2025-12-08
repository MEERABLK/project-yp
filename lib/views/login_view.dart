import '../dependencies.dart';
import '../pages.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  String name = '';
  String password = '';

  bool isGoogleSelected = false; // track which button is selected

  Future<void> loginWithEmail() async {
    if (name.isEmpty || password.isEmpty) {
      showMsg("Please fill all fields");
      return;
    }

    QuerySnapshot query = await users
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .get();

    if (query.docs.isNotEmpty) {
      showMsg("Login Successful!");
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeView()));
    } else {
      showMsg("Invalid Username or Password");
    }
  }

  Future<bool> loginWithGoogle() async {
    setState(() => isGoogleSelected = true); // toggle button colors

    final user = await GoogleSignIn().signIn();
    if (user == null) {
      setState(() => isGoogleSelected = false);
      return false; // user cancelled
    }

    final userAuth = await user.authentication;
    var credential = GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    return FirebaseAuth.instance.currentUser != null;
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#0F2F4E"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [HexColor("#0F2F4E"), HexColor("#9380D5")],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 5),
            Image.asset('assets/logo.png', width: 300, height: 300),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(top: 10),
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
                      // Email / Google buttons
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
                                  setState(() => isGoogleSelected = false);
                                  loginWithEmail();
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
                                  bool isLogged = await loginWithGoogle();
                                  if (isLogged) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomeView()));
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
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Iceland',
                        ),
                      ),

                      // Username field
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
                        onChanged: (value) => name = value,
                        decoration: InputDecoration(
                          hintText: 'cardmaster23',
                          hintStyle: TextStyle(color: HexColor("#464951")),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      // Password field
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
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#DACFFF")),
                            onPressed: loginWithEmail,
                            child: Text(
                              'Login',
                              style: TextStyle(color: HexColor("#7C59A7")),
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#9380D5")),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(color: Colors.white),
                            ),
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
}
