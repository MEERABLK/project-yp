import '../dependencies.dart';
import '../pages.dart';

class MyConceptView extends StatefulWidget {
  const MyConceptView({super.key});

  @override
  State<MyConceptView> createState() => _MyConceptViewScreenState();
}

class _MyConceptViewScreenState extends State<MyConceptView> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? "No email";
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  int _selectedTab = 0; // 0=All, 1=Pokémon, 2=Yu-Gi-Oh
  String searchQuery = "";

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

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Please login first.",
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ),
      );
    }

    final pokemonStream = FirebaseFirestore.instance
        .collection('PokemonCards')
        .where('createdBy', isEqualTo: uid)
        .snapshots();

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


                // “My concepts” header block
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "My concepts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Search bar
                TextField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) => setState(() => searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search Concepts ...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  ),
                ),

                const SizedBox(height: 12),

                // Filter tabs
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: HexColor("#292A30").withOpacity(0.44),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      _buildTab("All Cards", 0),
                      const SizedBox(width: 10),
                      _buildTab("Pokémon", 1),
                      const SizedBox(width: 10),
                      _buildTab("Yu-Gi-Oh !", 2),
                    ],
                  ),
                ),

                const SizedBox(height: 18),


                const SizedBox(height: 10),

                // Cards list
                StreamBuilder<QuerySnapshot>(
                  stream: pokemonStream,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Text(
                        "Error: ${snap.error}",
                        style: const TextStyle(color: Colors.white),
                      );
                    }

                    final docs = snap.data?.docs ?? [];

                    // Convert to PokemonModel
                    final allPokemon = docs.map((d) {
                      final data = d.data() as Map<String, dynamic>;
                      //abilities as List, make sure fromJson handles it
                      return PokemonModel.fromJson(data);
                    }).toList();

                    // Tabs: MyConceptView should show created Pokémon.
                    final filtered = allPokemon.where((p) {
                      final matchesSearch =
                      p.name.toLowerCase().contains(searchQuery.toLowerCase());
                      final matchesTab = (_selectedTab == 0 || _selectedTab == 1);
                      return matchesSearch && matchesTab;
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text(
                            "No concepts yet. Create one!",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: filtered.map((p) {
                        return _MyPokemonCardExact(pokemon: p);
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    bool selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white60,
              fontSize: 16,
              fontFamily: 'Iceland',
            ),
          ),
        ),
      ),
    );
  }
}

class _MyPokemonCardExact extends StatelessWidget {
  final PokemonModel pokemon;
  const _MyPokemonCardExact({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final stats = pokemon.baseStats;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0B6C78),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(blurRadius: 8, color: Colors.black26),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Text(
                    "POKÉMON",
                    style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.1),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      (pokemon.types.isNotEmpty ? pokemon.types.first : "—").toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),

            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                pokemon.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Image block
            Container(
              height: 170,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                pokemon.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            // Abilities + stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Abilities: ${pokemon.abilities.join(', ')}",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _stat("HP", stats['hp'] ?? 0),
                  _stat("Atk", stats['atk'] ?? 0),
                  _stat("Def", stats['def'] ?? 0),
                  _stat("Sp Atk", stats['spa'] ?? 0),
                  _stat("Sp Def", stats['spd'] ?? 0),
                  _stat("Speed", stats['spe'] ?? 0),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Footer
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "This Pokémon concept was created by you.",
                      style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10),
                    ),
                  ),
                  const Icon(Icons.edit, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  const Icon(Icons.delete, color: Colors.redAccent, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, int value) {
    final v = value.clamp(0, 255);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              "$label $v",
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: v / 255.0,
                minHeight: 10,
                backgroundColor: Colors.white.withOpacity(0.20),
                valueColor: AlwaysStoppedAnimation(
                  (v >= 120) ? const Color(0xFF7CFF6B) : const Color(0xFFFFD34D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
