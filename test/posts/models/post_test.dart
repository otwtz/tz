// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:galery_tz/posts/models/post.dart';

void main() {
  group('Post', () {
    test('supports value comparison', () {
      expect(
        Post(url: 'posts url', likes: 'post likes', views: 'post views'),
        Post(url: 'posts url', likes: 'post likes', views: 'post views'),
      );
    });
  });
}