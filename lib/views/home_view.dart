import '../dependencies.dart';
import 'package:projectyp/pages.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeView(),
    Placeholder(),
    Placeholder(),
    ProfileView(),
  ];

  void fetchLocation() async {
    Position? pos = await getUserLocation();
    if (pos == null) {
      print("Location unavailable");
    } else {
      print("Latitude: ${pos.latitude}, Longitude: ${pos.longitude}");
    }
  }

  List<YugiohModel> cards = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
    fetchLocation();
  }

  void fetchCards() async {
    List<YugiohModel>? data = await ApiService().getUsers();
    if (data != null && data.isNotEmpty) {
      setState(() {
        cards = data.take(2).toList();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                fontFamily: 'Iceland', color: Colors.white, fontSize: 20),
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
                                fontFamily: 'Iceland', color: Colors.white60, fontSize: 20),
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
                                fontFamily: 'Iceland', color: Colors.white60, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Dynamic Cards
                if (loading)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    children: cards.map((card) {
                      return ConceptCard(
                        cardId: (card.id ?? card.name).toString(),
                        title: card.name,
                        type: card.type,
                        description: card.desc,
                        color: Colors.blueGrey,
                        imageUrl: card.card_images.image_url_cropped,
                        username: "User123",
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      )
          : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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

// Concept Card with Likes
class ConceptCard extends StatefulWidget {
  final String cardId;
  final String title, type, description, imageUrl;
  final Color color;
  final String? username;

  const ConceptCard({
    required this.cardId,
    required this.title,
    required this.type,
    required this.description,
    required this.color,
    required this.imageUrl,
    this.username,
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
    if (uid == null) return; // stop if user is not logged in

    if (isLiked) {
      await likesVM.removeLike(widget.cardId, uid); // uid is non-null here
      setState(() {
        isLiked = false;
        likesCount -= 1;
      });
    } else {
      await likesVM.addLike(widget.cardId, uid); // uid is non-null here
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
        color: widget.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(widget.type, style: const TextStyle(color: Colors.white, fontSize: 12)),
                )
              ],
            ),
          ),

          // Image
          Container(
            height: 150,
            width: double.infinity,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.description, style: const TextStyle(color: Colors.white70)),
          ),

          // Footer: Likes + Username
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(widget.username ?? "", style: const TextStyle(color: Colors.white70)),
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
