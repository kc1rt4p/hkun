part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}

class ErrorNews extends NewsState {
  final String message;

  ErrorNews(this.message);
}

class LoadingNews extends NewsState {}

class NewsGetListSuccess extends NewsState {
  final List<NewsModel> list;

  NewsGetListSuccess(this.list);
}

class NewsAddSuccess extends NewsState {}

class NewsUpdateSuccess extends NewsState {}

class NewsUpdateError extends NewsState {}

class NewsDeleteSuccess extends NewsState {}

class NewsEditSuccess extends NewsState {}

class NewsAddError extends NewsState {}

class AddedDeleteItem extends NewsState {
  final List<NewsModel> newsList;

  AddedDeleteItem(this.newsList);
}

class RemovedDeleteItem extends NewsState {
  final List<NewsModel> newsList;

  RemovedDeleteItem(this.newsList);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}
