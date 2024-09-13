import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:galery_tz/posts/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';

part 'post_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, FetchState> {
  PostBloc({required this.httpClient}) : super(const FetchState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SearchEvent>(
      _onSearchEvent,
      transformer: debounceDroppable(throttleDuration),
    );
  }

  Future<void> _onSearchEvent(
    SearchEvent event,
    Emitter<FetchState> emit,
  ) async {
    if (event.searchText.length < 3) return;
    try {
      final newPosts = await _fetchPosts(tag: event.searchText);
      emit(state.copyWith(posts : newPosts, status: PostStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  final http.Client httpClient;

  final _httpClient = Dio();

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<FetchState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        return emit(
          state.copyWith(
            status: PostStatus.success,
            posts: posts,
            hasReachedMax: false,
          ),
        );
      }
      if (state.posts.length == 500) {
        return emit(state.copyWith(hasReachedMax: true));
      }
      final posts = await _fetchPosts(startIndex: (state.posts.length / 100).toInt() + 1);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts({int startIndex = 1, String tag = ''}) async {
    final response = await httpClient.get(
      Uri.parse(
          'https://pixabay.com/api/?key=45569437-8ee968d361d765095940f5a22&q=$tag&image_type=photo&per_page=100&page=$startIndex&width=120&height=67'),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final hits = body['hits'] as List;
      print(hits);
      return hits.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          url: map['webformatURL'].toString(),
          likes: map['likes'].toString(),
          views: map['views'].toString(),
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
