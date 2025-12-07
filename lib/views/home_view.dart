import 'package:flutter/material.dart';
import '../dependencies.dart';
import '../models/yugioh_model.dart';
import '../services/api_service.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeView> {
  List<YugiohModel> cards = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  void fetchCards() async {
    List<YugiohModel>? data = await ApiService().getUsers();
    setState(() {
      cards = data ?? [];
      loading = false;
    });
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
                // Header
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

                // Search Field
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search Concepts ...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: HexColor("#000000").withOpacity(0.50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
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

                // Static Card Example
                ConceptCard(
                  title: "Zoroark",
                  type: "DARK",
                  description:
                  "This Pokémon cares deeply about others of its kind, and it will conjure terrifying illusions to keep its den and pack safe.",
                  color: Colors.teal,
                  imageUrl: "assets/zoroark.png",
                  username: "FireMaster100",
                  likes: 234,
                ),

                // Dynamic Yu-Gi-Oh Cards
                if (loading)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    // children: cards.map((card) {
                      // return ConceptCard(
                      //   title: card.name,
                      //   type: card.type,
                      //   description: card.desc,
                      //   color: Colors.blueGrey,
                      //   // imageUrl: card.card_images.image_url_cropped,
                      //   username: "System",
                      //   likes: 0,
                      // );

                  ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: HexColor("#9380D5"),
        elevation: 0,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home", backgroundColor: Colors.black12),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: "My Concepts"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Create Card"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// Concept Card
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
      margin: const EdgeInsets.only(bottom: 16),
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
          ),

          // Image
          Container(
            height: 150,
            width: double.infinity,
            child: Image.network(
              imageUrl,            // Already the art URL
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) =>
              const Icon(Icons.broken_image, color: Colors.white),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              style: const TextStyle(color: Colors.white70),
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(username, style: const TextStyle(color: Colors.white70)),
                const Spacer(),
                const Icon(Icons.favorite, color: Colors.red, size: 18),
                const SizedBox(width: 5),
                Text(likes.toString(), style: const TextStyle(color: Colors.white70)),
                const SizedBox(width: 8),
                const Icon(Icons.chat_bubble_rounded, color: Colors.black, size: 18),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
