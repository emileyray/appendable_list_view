part of 'appendable_list_view.dart';

class _PageState<PageModel, ItemModel> {
  final List<ItemModel>? allModels;
  _PageState({this.allModels});
}

class _PageLoading<PageModel, ItemModel>
    extends _PageState<PageModel, ItemModel> {
  final bool initialLoading;
  final PageModel? lastLoadedPage;
  final int? lastPageNumber;

  _PageLoading({
    this.lastLoadedPage,
    this.lastPageNumber,
    final List<ItemModel>? allModels,
    this.initialLoading = false,
  }) : super(allModels: allModels);
}

class _PageReady<PageModel, ItemModel>
    extends _PageState<PageModel, ItemModel> {
  final PageModel lastLoadedPagel;
  final int lastPageNumber;

  _PageReady(this.lastLoadedPagel, this.lastPageNumber,
      final List<ItemModel> allModels)
      : super(allModels: allModels);
}

class _PageEnded<PageModel, ItemModel>
    extends _PageState<PageModel, ItemModel> {
  final PageModel lastLoadedPagel;
  final int lastPageNumber;

  _PageEnded(this.lastLoadedPagel, this.lastPageNumber,
      final List<ItemModel> allModels)
      : super(allModels: allModels);
}
