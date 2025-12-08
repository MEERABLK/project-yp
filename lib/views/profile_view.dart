import '../dependencies.dart';
import '../pages.dart';



class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileView> {
  final GoogleSignIn googleSignIn = GoogleSignIn(); // global/shared instance

  Future<void> logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Use shared instance to avoid slow creation
      await Future.wait([
        googleSignIn.signOut(),
        FirebaseAuth.instance.signOut(),
      ]);

      Navigator.pop(context); // remove loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RegisterScreen()),
      );
    } catch (e) {
      Navigator.pop(context); // remove loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [HexColor("#0F2F4E"), HexColor("#9380D5")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.black.withOpacity(0.68),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 20, left: 16, right: 16, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logout Icon
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white, size: 28),
                    onPressed: logout,
                  ),
                ),

                const SizedBox(height: 20),

                // Add more profile info here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
