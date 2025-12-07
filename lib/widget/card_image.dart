import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class CardImage extends StatefulWidget {
  final String url;
  const CardImage({super.key, required this.url});

  @override
  State<CardImage> createState() => _CardImageState();
}

class _CardImageState extends State<CardImage> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  void fetchImage() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        setState(() {
          imageBytes = response.bodyBytes;
        });
      } else {
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageBytes == null) {
      return const CircularProgressIndicator();
    } else {
      return Image.memory(imageBytes!);
    }
  }
}
