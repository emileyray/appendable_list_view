part of 'appendable_list_view.dart';

class _PageEvent {}

class _AppendPage extends _PageEvent {
  final int pageNumber;

  _AppendPage(this.pageNumber);
}

class _GetPageInitial extends _PageEvent {}
