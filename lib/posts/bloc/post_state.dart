part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }


final class FetchState extends Equatable {
  const FetchState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
  });

  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;

  FetchState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return FetchState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [
        status,
        posts,
        hasReachedMax,
      ];
}


