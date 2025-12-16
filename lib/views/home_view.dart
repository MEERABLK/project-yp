import '../dependencies.dart';
import 'package:projectyp/pages.dart';


class HomeView extends StatefulWidget {


  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeView> {
  int _currentIndex = 0;
  int _selectedTab = 0; // 0 = All, 1 = Pokémon, 2 = Yu-Gi-Oh
  String searchQuery = "";

  List<YugiohModel> cards = [];
  List<PokemonModel> pokemonCards = [];
  bool loading = true;
  bool loadingPokemon = true;

  final List<Widget> _screens = [
    Container(),
    Placeholder(),
    Placeholder(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    fetchCards();
    fetchPokemonCards();
    fetchLocation();
  }
  void _goToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileView()),
    );
  }

  void fetchLocation() async {
    Position? pos = await getUserLocation();
    if (pos == null) {
      print("Location unavailable");
    } else {
      print("Latitude: ${pos.latitude}, Longitude: ${pos.longitude}");
    }
  }

  void fetchCards() async {
    List<YugiohModel>? data = await ApiService().getYugioh();
    if (data != null && data.isNotEmpty) {
      setState(() {
        cards = data.take(5).toList();
        loading = false;
      });
    }
  }

  void fetchPokemonCards() async {
    List<PokemonModel>? data = await ApiService().getPokemon();
    if (data != null && data.isNotEmpty) {
      setState(() {
        pokemonCards = data.take(5).toList();
        loadingPokemon = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter Yugioh
    List<YugiohModel> filteredYugioh = cards.where((card) {
      final matchesSearch = card.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch && (_selectedTab == 0 || _selectedTab == 2);
    }).toList();

    // Filter Pokémon
    List<PokemonModel> filteredPokemon = pokemonCards.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch && (_selectedTab == 0 || _selectedTab == 1);
    }).toList();

    return Scaffold(
        body: _currentIndex == 0
          ? Stack(
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
                  onChanged: (val) => setState(() => searchQuery = val),
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
                      _buildTab("All Cards", 0),
                      const SizedBox(width: 10),
                      _buildTab("Pokémon", 1),
                      const SizedBox(width: 10),
                      _buildTab("Yu-Gi-Oh !", 2),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Dynamic Cards
                if (loading || loadingPokemon)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    children: [
                      ...filteredPokemon.map((p) => GestureDetector(

                        child: PokemonConceptCard(pokemon: p),
                      )),
                      ...filteredYugioh.map((c) => ConceptCard(
                        cardId: (c.id ?? c.name).toString(),
                        title: c.name,
                        type: c.type,
                        description: c.desc,
                        // color: HexColor("#c2924d"),
                        color: HexColor("#5c2e1a"),
                        imageUrl: c.card_images.image_url_cropped,
                      )),
                    ],
                  ),
              ],
            ),
          ),
        ],
      )
            : _screens[_currentIndex],
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) => setState(() => _currentIndex = index),
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: HexColor("#9380D5"),
      //   elevation: 0,
      //   unselectedItemColor: Colors.white,
      //   selectedItemColor: Colors.white,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.collections), label: "My Concepts"),
      //     BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Create Card"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
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
              fontSize: 20,
              fontFamily: 'Iceland',
            ),
          ),
        ),
      ),
    );
  }
}


class PokemonConceptCard extends StatefulWidget {
  final PokemonModel pokemon;
  final String? username;

  const PokemonConceptCard({required this.pokemon, this.username, super.key});

  @override
  State<PokemonConceptCard> createState() => _PokemonConceptCardState();
}

class _PokemonConceptCardState extends State<PokemonConceptCard> {
  int likesCount = 0;
  bool isLiked = false;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final LikesViewModel likesVM = LikesViewModel();

  @override
  void initState() {
    super.initState();
    fetchLikes();
  }

  void fetchLikes() async {
    if (widget.pokemon.name.isEmpty) return;
    LikesModel? likes = await likesVM.getLikes(
        widget.pokemon.name); // use unique id
    setState(() {
      likesCount = likes?.userIds.length ?? 0;
      isLiked = userId != null && (likes?.userIds.contains(userId) ?? false);
    });
  }

  void toggleLike() async {
    final uid = userId;
    if (uid == null) return;

    if (isLiked) {
      await likesVM.removeLike(widget.pokemon.name, uid);
      setState(() {
        isLiked = false;
        likesCount -= 1;
      });
    } else {
      await likesVM.addLike(widget.pokemon.name, uid);
      setState(() {
        isLiked = true;
        likesCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                CardDetailsView(
                  pokemon: widget.pokemon,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.yellow.shade700,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name & Types
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.pokemon.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    widget.pokemon.types.join(', '),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            // Image
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.yellow.shade100,
              child: Image.network(
                widget.pokemon.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
            // Stats
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Abilities: ${widget.pokemon.abilities.join(', ')}"),
                  const SizedBox(height: 5),
                  Text(
                    "HP: ${widget.pokemon.baseStats['hp']} "
                        " ATK: ${widget.pokemon.baseStats['atk']} "
                        " DEF: ${widget.pokemon.baseStats['def']}\n"
                        "SpA: ${widget.pokemon.baseStats['spa']} "
                        " SpD: ${widget.pokemon.baseStats['spd']} "
                        " SPE: ${widget.pokemon.baseStats['spe']}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            // Username + Likes
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(widget.username ?? "",
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 12)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red),
                    onPressed: toggleLike,
                  ),
                  Text(likesCount.toString(),
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Concept Card with Likes
class ConceptCard extends StatefulWidget {
  final String cardId;
  final String title, type, description, imageUrl;
  final Color color;

  const ConceptCard({
    required this.cardId,
    required this.title,
    required this.type,
    required this.description,
    required this.color,
    required this.imageUrl,
    super.key,
  });

  @override
  State<ConceptCard> createState() => _ConceptCardState();
}

class _ConceptCardState extends State<ConceptCard> {
  int likesCount = 0;
  bool isLiked = false;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final LikesViewModel likesVM = LikesViewModel();

  @override
  void initState() {
    super.initState();
    fetchLikes();
  }

  void fetchLikes() async {
    if (widget.cardId.isEmpty) return;
    LikesModel? likes = await likesVM.getLikes(widget.cardId);
    setState(() {
      likesCount = likes?.userIds.length ?? 0;
      isLiked = userId != null && (likes?.userIds.contains(userId) ?? false);
    });
  }

  void toggleLike() async {
    final uid = userId;
    if (uid == null) return;

    if (isLiked) {
      await likesVM.removeLike(widget.cardId, uid);
      setState(() {
        isLiked = false;
        likesCount -= 1;
      });
    } else {
      await likesVM.addLike(widget.cardId, uid);
      setState(() {
        isLiked = true;
        likesCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.color, // brown background for Yu-Gi-Oh
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
          ),
        ],

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: title & type
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(widget.type,
                      style: const TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),

// Middle: Cropped Image - Full width, centered
          // Image container with fixed image size and spacing
          Container(
            width: double.infinity, // full width container
            // color: Colors.brown.shade700, // dark brown background
            // color: HexColor("#c2924d"),
            // color: HexColor("#8a3f20"),
            color: HexColor("#2c1b12"),
            padding: const EdgeInsets.all(16), // space on all sides
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.imageUrl,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover, // fills the 150x150 box
                  errorBuilder: (c, e, s) =>
                  const Icon(Icons.broken_image, color: Colors.white),
                ),
              ),
            ),
          ),


          // Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.description, style: const TextStyle(color: Colors.black)),
          ),

          // Likes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: toggleLike,
                ),
                Text(likesCount.toString(), style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

