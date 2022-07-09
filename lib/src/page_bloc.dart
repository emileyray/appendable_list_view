import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc<PageModel, ItemModel>
    extends Bloc<PageEvent, PageState<PageModel, ItemModel>> {
  Function getPage;

  PageBloc({required this.getPage})
      : super(PageLoading<PageModel, ItemModel>(initialLoading: true)) {
    on<AppendPage>(_appendPage);
    on<GetPageInitial>(_getPageInitial);

    add(GetPageInitial());
  }

  FutureOr<void> _appendPage(AppendPage event, Emitter emit) async {
    emit(PageLoading<PageModel, ItemModel>(allModels: state.allModels));

    final page = await getPage(event.pageNumber);

    if (page.next == null) {
      emit(PageEnded<PageModel, ItemModel>(
        page,
        event.pageNumber,
        (state.allModels ?? []) + page.results,
      ));
    } else {
      emit(PageReady<PageModel, ItemModel>(
        page,
        event.pageNumber,
        (state.allModels ?? []) + page.results,
      ));
    }
  }

  FutureOr<void> _getPageInitial(GetPageInitial event, Emitter emit) async {
    emit(PageLoading<PageModel, ItemModel>(initialLoading: true));

    final page = await getPage(1);

    if (page.next == null) {
      emit(PageEnded<PageModel, ItemModel>(page, 1, page.results));
    } else {
      emit(PageReady<PageModel, ItemModel>(page, 1, page.results));
    }
  }
}
