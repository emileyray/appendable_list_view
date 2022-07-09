part of 'page_bloc.dart';

class PageEvent {}

class AppendPage extends PageEvent {
  final int pageNumber;

  AppendPage(this.pageNumber);
}

class GetPageInitial extends PageEvent {}
