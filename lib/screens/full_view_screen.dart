import 'package:flutter/material.dart';

class FullViewScreen extends StatelessWidget {
  final imageUrl;
  const FullViewScreen({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.fitWidth
          ) ,
        ),
      ),
    );
  }
}
