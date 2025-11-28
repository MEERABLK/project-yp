import 'dependencies.dart';
import 'pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // gradient behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // let gradient show through
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: HexColor("#786868").withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Discover",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Search field
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Concepts ...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: HexColor("#000000").withOpacity(0.50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
            ),

            const SizedBox(height: 20),


                      // Filter Tabs
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: HexColor("#292A30").withOpacity(0.44),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "All Cards",
                                  style: TextStyle(
                                      fontFamily: 'Iceland',
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Text(
                                  "Pokémon",
                                  style: TextStyle(
                                      fontFamily: 'Iceland',
                                      color: Colors.white60,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Text(
                                  "Yu-Gi-Oh !",
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

                      const SizedBox(height: 20),

                      // Concept Cards
                      ConceptCard(
                        title: "Zoroark",
                        type: "DARK",
                        description:
                        "This Pokémon cares deeply about others of its kind, and it will conjure terrifying illusions to keep its den and pack safe.",
                        color: Colors.teal,
                        imageUrl: "asset/zoroark.png",
                        username: "FireMaster100",
                        likes: 234,
                      ),
                      ConceptCard(
                        title: "Dark Blade",
                        type: "DARK",
                        description: "A powerful dark warrior from the shadows.",
                        color: Colors.brown,
                        imageUrl: "asset/darkblade.png",
                        username: "YuGiFan",
                        likes: 112,
                      ),
                    ],
                  ),
                ),

    ],
              ),

// Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.68),


      selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",backgroundColor: HexColor("#4B4B4B")),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "My Concepts"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Create Card"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),




    );
  }
}


class ConceptCard extends StatelessWidget {
  final String title, type, description, imageUrl, username;
  final int likes;
  final Color color;
  const ConceptCard({
    required this.title,
    required this.type,
    required this.description,
    required this.color,
    required this.imageUrl,
    required this.username,
    required this.likes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header: Title + Type
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
          ),

          // Image
          Container(
            height: 150,
            child: Image.asset(imageUrl, fit: BoxFit.contain),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              style: TextStyle(color: Colors.white70),
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(username, style: TextStyle(color: Colors.white70)),
                Spacer(),
                Icon(Icons.favorite, color: Colors.red, size: 18),
                SizedBox(width: 4),
                Text(likes.toString(), style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
