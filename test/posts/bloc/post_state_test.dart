// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:galery_tz/posts/bloc/post_bloc.dart';

void main() {
  group('PostState', () {
    test('supports value comparison', () {
      expect(FetchState(), FetchState());
      expect(
        FetchState().toString(),
        FetchState().toString(),
      );
    });
  });
}