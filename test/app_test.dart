
import 'package:flutter_test/flutter_test.dart';
import 'package:galery_tz/app.dart';
import 'package:galery_tz/posts/view/posts_page.dart';

void main() {
  group('App', () {
    testWidgets('renders PostsPage', (tester) async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
      expect(find.byType(PostsPage), findsOneWidget);
    });
  });
}