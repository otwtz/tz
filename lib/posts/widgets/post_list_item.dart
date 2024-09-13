import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:galery_tz/posts/models/post.dart';
import 'package:galery_tz/posts/view/view.dart';

class PostListItem extends StatefulWidget {
  const PostListItem({required this.post, super.key});

  final Post post;

  @override
  State<PostListItem> createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  @override
  void didChangeDependencies() {
    precacheImage(NetworkImage(widget.post.url), context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black12
          ),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BigItem(post: widget.post)),
              );
            },
            child: Hero(
              tag: '${widget.post.hashCode}',
              child: CachedNetworkImage(
                width: 120,
                height: 67,
                fit: BoxFit.cover,
                placeholder: (context, url) => Transform.scale(
                  scale: 0.3,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
                imageUrl: widget.post.url,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'Images/heart.png',
                width: 11,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                '${widget.post.likes}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                'Images/view.png',
                width: 11,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                '${widget.post.views}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
