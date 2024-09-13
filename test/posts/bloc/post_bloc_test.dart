import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galery_tz/posts/bloc/post_bloc.dart';
import 'package:galery_tz/posts/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

Uri _postsUrl({required int start}) {
  return Uri.https(
    'jsonplaceholder.typicode.com',
    '/posts',
    <String, String>{'_start': '$start', '_limit': '20'},
  );
}

void main() {
  group('PostBloc', () {
    const mockPosts = [Post(url: 'posts url', likes: 'post likes', views: 'post views')];
    const extraMockPosts = [
      Post(url: 'posts url', likes: 'post likes', views: 'post views'),
    ];

    late http.Client httpClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockClient();
    });

    test('initial state is PostState()', () {
      expect(PostBloc(httpClient: httpClient).state, const FetchState());
    });

    group('PostFetched', () {
      blocTest<PostBloc, FetchState>(
        'emits nothing when posts has reached maximum amount',
        build: () => PostBloc(httpClient: httpClient),
        seed: () => const FetchState(hasReachedMax: true),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => <FetchState>[],
      );

      blocTest<PostBloc, FetchState>(
        'emits successful status when http fetches initial posts',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "post title", "body": "post body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => const <FetchState>[
          FetchState(status: PostStatus.success, posts: mockPosts),
        ],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 0))).called(1);
        },
      );

      blocTest<PostBloc, FetchState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "post title", "body": "post body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (bloc) => bloc
          ..add(PostFetched())
          ..add(PostFetched()),
        expect: () => const <FetchState>[
          FetchState(status: PostStatus.success, posts: mockPosts),
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<PostBloc, FetchState>(
        'throttles events',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "post title", "body": "post body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (bloc) async {
          bloc.add(PostFetched());
          await Future<void>.delayed(Duration.zero);
          bloc.add(PostFetched());
        },
        expect: () => const <FetchState>[
          FetchState(status: PostStatus.success, posts: mockPosts),
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<PostBloc, FetchState>(
        'emits failure status when http fetches posts and throw exception',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
                (_) async => http.Response('', 500),
          );
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => <FetchState>[const FetchState(status: PostStatus.failure)],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 0))).called(1);
        },
      );

      blocTest<PostBloc, FetchState>(
        'emits successful status and reaches max posts when '
            '0 additional posts are fetched',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
                (_) async => http.Response('[]', 200),
          );
        },
        build: () => PostBloc(httpClient: httpClient),
        seed: () => const FetchState(
          status: PostStatus.success,
          posts: mockPosts,
        ),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => const <FetchState>[
          FetchState(
            status: PostStatus.success,
            posts: mockPosts,
            hasReachedMax: true,
          ),
        ],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 1))).called(1);
        },
      );

      blocTest<PostBloc, FetchState>(
        'emits successful status and does not reach max posts '
            'when additional posts are fetched',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 2, "title": "post title", "body": "post body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        seed: () => const FetchState(
          status: PostStatus.success,
          posts: mockPosts,
        ),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => const <FetchState>[
          FetchState(
            status: PostStatus.success,
            posts: [...mockPosts, ...extraMockPosts],
          ),
        ],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 1))).called(1);
        },
      );
    });
  });
}