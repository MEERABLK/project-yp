import '../dependencies.dart';
import '../pages.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Details overlay (when not null, show details on top of tabs)
  PokemonModel? _selectedPokemon;

  void openPokemonDetails(PokemonModel p) {
    setState(() => _selectedPokemon = p);
  }

  void closeDetails() {
    setState(() => _selectedPokemon = null);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeView(onOpenPokemon: openPokemonDetails),
      const Placeholder(),
      const Placeholder(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          tabs[_currentIndex],

          // DETAILS OVERLAY (keeps nav bar visible)
          if (_selectedPokemon != null)
            CardDetailsView(
              pokemon: _selectedPokemon!,
              // onBack: closeDetails,
            ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: HexColor("#9380D5"),
        elevation: 0,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: "My Concepts"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Create Card"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
