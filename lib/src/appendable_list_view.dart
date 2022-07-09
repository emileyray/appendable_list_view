import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appendable_list_view/src/page_bloc.dart';

class AppendableListView<PageModel, ItemModel> extends StatefulWidget {
  final Widget Function(BuildContext, List, int) itemBuilder;
  final Future<PageModel> Function(int) getPage;
  final Widget? onEmpty;
  final Color? refreshIndicatorColor;
  final ScrollPhysics? physics;
  final int? itemCount;
  final int scrollOffset;
  final Widget loadingIndicator;
  const AppendableListView({
    required this.itemBuilder,
    required this.getPage,
    this.onEmpty,
    this.refreshIndicatorColor,
    this.physics,
    this.itemCount,
    this.scrollOffset = 1000,
    this.loadingIndicator = const CircularProgressIndicator(),
    Key? key,
  }) : super(key: key);

  @override
  State<AppendableListView> createState() =>
      _AppendableListViewState<PageModel, ItemModel>();
}

class _AppendableListViewState<PageModel, ItemModel>
    extends State<AppendableListView> {
  final ScrollController _scrollController = ScrollController();
  bool _scrollToDown = false;
  late PageBloc<PageModel, ItemModel> _bloc;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PageBloc<PageModel, ItemModel>>(
      create: (context) {
        _bloc = PageBloc<PageModel, ItemModel>(getPage: widget.getPage);
        return _bloc;
      },
      child: BlocBuilder<PageBloc<PageModel, ItemModel>,
          PageState<PageModel, ItemModel>>(
        builder: (context, state) {
          if (modelsFetched(state)) {
            final List<ItemModel> models = state.allModels!;
            if (models.isEmpty) {
              return widget.onEmpty ?? Wrap();
            }
            return Expanded(
              child: RefreshIndicator(
                color: widget.refreshIndicatorColor,
                onRefresh: () async {
                  _bloc.add(GetPageInitial());
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == models.length) {
                      return state is PageLoading
                          ? Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(bottom: 10),
                              child: widget.loadingIndicator,
                            )
                          : Wrap();
                    }
                    return widget.itemBuilder(context, models, index);
                  },
                  physics:
                      widget.physics ?? const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: models.length + 1,
                ),
              ),
            );
          }
          return Expanded(child: Center(child: widget.loadingIndicator));
        },
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (_scrollController.position.pixels < currentScroll) {
      if (_scrollToDown) {
        _scrollToDown = false;
      }
    }
    if (_bloc.state is PageReady) {
      if (maxScroll - currentScroll <= widget.scrollOffset) {
        _bloc.add(AppendPage((_bloc.state as PageReady).lastPageNumber + 1));
      }
    }
  }

  bool modelsFetched(PageState state) {
    return state is PageReady<PageModel, ItemModel> ||
        state is PageEnded<PageModel, ItemModel> ||
        (state is PageLoading<PageModel, ItemModel> && !state.initialLoading);
  }
}
