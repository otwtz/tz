
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galery_tz/posts/bloc/post_bloc.dart';
import 'package:galery_tz/posts/widgets/bottom_loader.dart';
import 'package:galery_tz/posts/widgets/post_list_item.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, FetchState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return  Center(child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      context.read<PostBloc>().add(SearchEvent(searchText: value));
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Введите запрос для поиска...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.00),
                      ),
                    ),
                  ),
                  SizedBox(height: 320,),
                  Text('no posts'),
                ],
              ),
              );
            }
            final double width = MediaQuery.of(context).size.width;
            final int columns = (width / 120).floor();
            return Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    context.read<PostBloc>().add(SearchEvent(searchText: value));
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter a search query...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.00),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 2,
                        crossAxisCount: columns,
                        childAspectRatio: 1,
                      ),
                      controller: _scrollController,
                      itemCount: state.posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.posts.length
                            ? const BottomLoader()
                            : PostListItem(post: state.posts[index]);
                      }),
                ),
              ],
            );
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
