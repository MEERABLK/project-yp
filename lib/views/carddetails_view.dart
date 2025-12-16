import 'package:flutter/material.dart';
import 'package:projectyp/models/pokemon_model.dart';

class CardDetailsView extends StatelessWidget {
  final PokemonModel pokemon;

  const CardDetailsView({super.key, required this.pokemon});

  int _stat(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final hp = _stat(pokemon.baseStats['hp']);
    final atk = _stat(pokemon.baseStats['atk']);
    final def = _stat(pokemon.baseStats['def']);
    final spa = _stat(pokemon.baseStats['spa']);
    final spd = _stat(pokemon.baseStats['spd']);
    final spe = _stat(pokemon.baseStats['spe']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2F4E), Color(0xFF9380D5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.68)),

          // content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 30),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name + types (same look)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pokemon.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          pokemon.types.join(', '),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  // image
                  Container(
                    height: 260,
                    width: double.infinity,
                    color: Colors.yellow.shade100,
                    child: Image.network(
                      pokemon.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image, size: 60)),
                    ),
                  ),

                  // abilities + stats (same style)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Abilities: ${pokemon.abilities.join(', ')}",
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "HP: $hp  ATK: $atk  DEF: $def",
                          style: const TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        Text(
                          "SpA: $spa  SpD: $spd  SPE: $spe",
                          style: const TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
