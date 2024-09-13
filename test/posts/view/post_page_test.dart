import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galery_tz/posts/view/post_list.dart';
import 'package:galery_tz/posts/view/posts_page.dart';

void main() {
  group('PostsPage', () {
    testWidgets('renders PostList', (tester) async {
      await tester.pumpWidget(MaterialApp(home: PostsPage()));
      await tester.pumpAndSettle();
      expect(find.byType(PostsList), findsOneWidget);
    });
  });
}