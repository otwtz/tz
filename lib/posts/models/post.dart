import 'package:equatable/equatable.dart';

final class Post extends Equatable {
  const Post({required this.url, required this.likes, required this.views});

  final String url;
  final String likes;
  final String views;

  @override
  List<Object> get props => [url, likes, views];
}