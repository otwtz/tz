// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:galery_tz/posts/bloc/post_bloc.dart';

void main() {
  group('PostEvent', () {
    group('PostFetched', () {
      test('supports value comparison', () {
        expect(PostFetched(), PostFetched());
      });
    });
  });
}