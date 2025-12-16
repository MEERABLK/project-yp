import 'package:projectyp/dependencies.dart';
import 'package:projectyp/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyD68YP8O-4R1EHl6sOYr69kPYX-Ec5wqvo",
        appId: "379312428600",
        messagingSenderId: "1:379312428600:android:96dc5d30a71d20efa2f8cd",
        projectId: "project-yp-55c23"),
  );
  runApp(const MaterialApp(home: CreateView()));
}

// 1. Renamed Widget to CreateView
class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  // 2. Simplified to a single controller for Ability "0"
  final TextEditingController _abilityController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // Types
  final List<String> _pokemonTypes = [
    'Normal', 'Fire', 'Water', 'Grass', 'Electric', 'Ice', 'Fighting',
    'Poison', 'Ground', 'Flying', 'Psychic', 'Bug', 'Rock', 'Ghost',
    'Dragon', 'Steel', 'Dark', 'Fairy'
  ];
  String? _type1;
  String? _type2;

  // Stats
  double _hp = 50, _atk = 50, _def = 50, _spa = 50, _spd = 50, _spe = 50;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _abilityController.dispose();
    _imageController.dispose();

    super.dispose();
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Construct Types Array
        List<String> typesArray = [_type1!];
        if (_type2 != null && _type2 != _type1) {
          typesArray.add(_type2!);
        }

        final pokemonData = {
          'id': int.parse(_idController.text),
          'name': _nameController.text,
          'image': _imageController.text.trim(),
          'abilities': {
            '0': _abilityController.text,
          },
          'types': typesArray,
          'baseStats': {
            'hp': _hp.round(),
            'atk': _atk.round(),
            'def': _def.round(),
            'spa': _spa.round(),
            'spd': _spd.round(),
            'spe': _spe.round(),
          },
        };


        await FirebaseFirestore.instance.collection('PokemonCards').add(pokemonData);

        // Reset UI
        _nameController.clear();
        _idController.clear();
        _abilityController.clear();
        _imageController.clear();

        setState(() {
          _type1 = null;
          _type2 = null;
          _hp = _atk = _def = _spa = _spd = _spe = 50;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pokemon added successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
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
      child:
      Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Identity ---
              const SectionHeader(title: "Identity"),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(labelText: 'ID #',labelStyle:TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: HexColor("#464951")),
                      ),
                      validator: (val) => val!.isEmpty ? 'Req' : null,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _nameController,
                      decoration:  InputDecoration(labelText: 'Name',labelStyle:TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: HexColor("#464951")),
                  ),
                      style: TextStyle(color: Colors.white),
                      validator: (val) => val!.isEmpty ? 'Req' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Types ---
              const SectionHeader(title: "Types"),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _type1,
                      hint: const Text("Primary", style: const TextStyle(color: Colors.white),),
                      items: _pokemonTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setState(() => _type1 = v),
                      validator: (val) => val == null ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _type2,
                      hint: const Text("Secondary", style: const TextStyle(color: Colors.white),),
                      items: _pokemonTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setState(() => _type2 = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Ability (Simplified) ---
              const SectionHeader(title: "Ability"),
              // 4. Single Ability Input hooked to "0" logic
              TextFormField(
                controller: _abilityController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Primary Ability',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flash_on, color: Colors.white,),
                ),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const SectionHeader(title: "Image"),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: "Image URL (web link)",labelStyle:TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image, color: Colors.white,),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Required';
                  final uri = Uri.tryParse(val.trim());
                  if (uri == null || !uri.hasAbsolutePath || !(uri.scheme == 'http' || uri.scheme == 'https')) {
                    return 'Enter a valid http/https URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16,),
              // --- Stats ---
              const SectionHeader(title: "Base Stats"),
              StatRow(label: "HP", value: _hp, onChanged: (v) => setState(() => _hp = v)),
              StatRow(label: "Attack", value: _atk, onChanged: (v) => setState(() => _atk = v)),
              StatRow(label: "Defense", value: _def, onChanged: (v) => setState(() => _def = v)),
              StatRow(label: "Sp. Atk", value: _spa, onChanged: (v) => setState(() => _spa = v)),
              StatRow(label: "Sp. Def", value: _spd, onChanged: (v) => setState(() => _spd = v)),
              StatRow(label: "Speed", value: _spe, onChanged: (v) => setState(() => _spe = v)),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor:  HexColor("#7C59A7"),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Data', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// --- Helper Widgets ---

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class StatRow extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<StatRow> createState() => _StatRowState();
}

class _StatRowState extends State<StatRow> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value.round().toString());
  }

  @override
  void didUpdateWidget(covariant StatRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final newValStr = widget.value.round().toString();
      if (_ctrl.text != newValStr) {
        _ctrl.text = newValStr;
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
        Expanded(
          child: Slider(
            value: widget.value,
            min: 0,
            max: 255,
            divisions: 255,
            onChanged: widget.onChanged,
          ),
        ),
        SizedBox(
          width: 50,
          child: TextField(
            style: const TextStyle(color: Colors.white),
            controller: _ctrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration:  InputDecoration(isDense: true, contentPadding: EdgeInsets.all(4),
              hintStyle: TextStyle(color: HexColor("#464951")),
            ),
            onChanged: (val) {
              final n = double.tryParse(val);
              if (n != null && n >= 0 && n <= 255) {
                widget.onChanged(n);
              }
            },
          ),
        ),
      ],
    );
  }
}
