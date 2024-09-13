
part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class PostFetched extends PostEvent {}

final class SearchEvent extends PostEvent {
  final String searchText;

  SearchEvent({required this.searchText});
}