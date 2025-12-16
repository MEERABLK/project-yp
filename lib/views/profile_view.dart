import '../dependencies.dart';
import '../pages.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileView> {
  final GoogleSignIn googleSignIn = GoogleSignIn(); // global/shared instance
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  Future<void> logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
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
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 30),
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

                // Cover Image
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image, size: 50, color: Colors.white),
                ),

                const SizedBox(height: 16),

                // Profile Avatar and Name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[500],
                      child: const Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'User83852098467',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 12),


                  Text(
                    'Bio',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                  ),


                // Bio
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'No bio...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 20),

                // Posts
                const Text(
                  'Posts',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                // Example Post
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: const Icon(Icons.image, size: 50, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'My first post. This is something I thought of overnight. Thoughts?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.favorite_border, color: Colors.white),
                                SizedBox(width: 4),
                                Text('54', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(Icons.comment, color: Colors.white),
                                SizedBox(width: 4),
                                Text('7', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(Icons.share, color: Colors.white),
                                SizedBox(width: 4),
                                Text('Share', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Another post text-only
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'I just updated my old design. Go check it out!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
