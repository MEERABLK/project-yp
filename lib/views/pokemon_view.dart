import 'package:flutter/material.dart';
import 'package:projectyp/models/pokemon_model.dart';
import 'package:projectyp/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: APIDEMO(),
    );
  }
}

class APIDEMO extends StatefulWidget {
  const APIDEMO({super.key});

  @override
  State<APIDEMO> createState() => _APIDEMOState();
}

class _APIDEMOState extends State<APIDEMO> {
  List<PokemonModel>? _pokemonModel = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    List<PokemonModel>? allCards = await ApiService().getPokemon();
    if (allCards != null && allCards.isNotEmpty) {
      setState(() {
        _pokemonModel = allCards.take(2).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listing Cards from REST API'),
      ),
      body: _pokemonModel == null || _pokemonModel!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _pokemonModel!.length,
        itemBuilder: (context, index) {
          final card = _pokemonModel![index];
          final imageUrl = card.poke_images.image_url_cropped; // directly use cropped image
          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.network(card.poke_images.image_url_cropped, width: 50),
                  // Image.network(
                  //   imageUrl,
                  //   height: 150,
                  //   fit: BoxFit.contain,
                  // ),
                  const SizedBox(height: 10),
                  Text("Types: ${card.types.join('/')}"),
                  const SizedBox(height: 5),
                  Text("Abilities:\n${card.abilities.join('\n- ')}"),
                  const SizedBox(height: 5),
                  Text("Stats:"),
                  Text("""
                  HP: ${card.baseStats['hp']}
                  Attack: ${card.baseStats['atk']}
                  Defense: ${card.baseStats['def']}
                  Sp. Attack: ${card.baseStats['spa']}
                  Sp. Defense: ${card.baseStats['spd']}
                  Speed: ${card.baseStats['spe']}
                  """),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
