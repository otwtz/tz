
import 'package:flutter/material.dart';

class BigItem extends StatelessWidget {
  const BigItem({
    super.key,
    required this.post,
  });

  final dynamic post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          transitionOnUserGestures: true  ,
          tag: '${post.hashCode}',
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            child: Image.network(
              post.url,
            ),
          ),
        ),
      ),
    );
  }
}