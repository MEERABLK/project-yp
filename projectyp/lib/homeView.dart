import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#1B2A47"), // dark blue background
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Project YP",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Discover",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search Concepts ...",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: HexColor("#0F1A2C"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FilterButton(label: "All Cards", selected: true),
                  SizedBox(width: 8),
                  FilterButton(label: "Pokémon"),
                  SizedBox(width: 8),
                  FilterButton(label: "Yu-Gi-Oh!"),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Cards List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
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
                    description:
                    "A powerful dark warrior from the shadows.",
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
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor("#0F1A2C"),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "My Concepts"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Create Card"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// Filter button widget
class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  const FilterButton({required this.label, this.selected = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.amber : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white54),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}

// Concept Card Widget
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
