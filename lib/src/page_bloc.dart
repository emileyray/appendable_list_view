part of 'appendable_list_view.dart';

class PageBloc<PageModel, ItemModel>
    extends Bloc<_PageEvent, _PageState<PageModel, ItemModel>> {
  Function getPage;

  PageBloc({required this.getPage})
      : super(_PageLoading<PageModel, ItemModel>(initialLoading: true)) {
    on<_AppendPage>(_appendPage);
    on<_GetPageInitial>(_getPageInitial);

    add(_GetPageInitial());
  }

  FutureOr<void> _appendPage(_AppendPage event, Emitter emit) async {
    emit(_PageLoading<PageModel, ItemModel>(allModels: state.allModels));

    final page = await getPage(event.pageNumber);

    if (page.next == null) {
      emit(_PageEnded<PageModel, ItemModel>(
        page,
        event.pageNumber,
        (state.allModels ?? []) + page.results,
      ));
    } else {
      emit(_PageReady<PageModel, ItemModel>(
        page,
        event.pageNumber,
        (state.allModels ?? []) + page.results,
      ));
    }
  }

  FutureOr<void> _getPageInitial(_GetPageInitial event, Emitter emit) async {
    emit(_PageLoading<PageModel, ItemModel>(initialLoading: true));

    final page = await getPage(1);

    if (page.next == null) {
      emit(_PageEnded<PageModel, ItemModel>(page, 1, page.results));
    } else {
      emit(_PageReady<PageModel, ItemModel>(page, 1, page.results));
    }
  }
}
