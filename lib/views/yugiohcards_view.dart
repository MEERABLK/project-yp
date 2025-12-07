import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectyp/models/yugioh_model.dart';
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
  // create a list container that stores the list of userModel
  List<YugiohModel>? _userModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // write a function to get the data
    _getData();
  }

  void _getData() async {
    _userModel = (await ApiService()
        .getUsers())!; // assert that this obj is not null at that instant
    Future.delayed(Duration(seconds: 2)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listing Users from REST API'),
      ),
      body: _userModel == null || _userModel!.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _userModel!.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_userModel![index].id.toString()),
                    Text(_userModel![index].name)
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_userModel![index].name),
                    Text(_userModel![index].type),
                    // Text(_userModel![index].card_images.image_url_cropped),
                    Text(_userModel![index].desc),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
