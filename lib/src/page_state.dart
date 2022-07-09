part of 'page_bloc.dart';

class PageState<PageModel, ItemModel> {
  final List<ItemModel>? allModels;
  PageState({this.allModels});
}

class PageLoading<PageModel, ItemModel>
    extends PageState<PageModel, ItemModel> {
  final bool initialLoading;
  final PageModel? lastLoadedPage;
  final int? lastPageNumber;

  PageLoading({
    this.lastLoadedPage,
    this.lastPageNumber,
    final List<ItemModel>? allModels,
    this.initialLoading = false,
  }) : super(allModels: allModels);
}

class PageReady<PageModel, ItemModel> extends PageState<PageModel, ItemModel> {
  final PageModel lastLoadedPagel;
  final int lastPageNumber;

  PageReady(this.lastLoadedPagel, this.lastPageNumber,
      final List<ItemModel> allModels)
      : super(allModels: allModels);
}

class PageEnded<PageModel, ItemModel> extends PageState<PageModel, ItemModel> {
  final PageModel lastLoadedPagel;
  final int lastPageNumber;

  PageEnded(this.lastLoadedPagel, this.lastPageNumber,
      final List<ItemModel> allModels)
      : super(allModels: allModels);
}
