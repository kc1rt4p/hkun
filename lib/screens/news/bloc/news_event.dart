part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {}

class GetHomeTimeline extends NewsEvent {}

class NewsGetList extends NewsEvent {}

class NewsAdd extends NewsEvent {
  final NewsModel request;
  final File image;

  NewsAdd(this.request, this.image);
}

class NewsUpdate extends NewsEvent {
  final NewsModel request;
  final File? image;

  NewsUpdate(this.request, this.image);
}

class AddDeleteItem extends NewsEvent {
  final List<NewsModel> newsList;

  AddDeleteItem(this.newsList);
}

class RemoveDeleteItem extends NewsEvent {
  final List<NewsModel> newsList;

  RemoveDeleteItem(this.newsList);
}

class NewsDelete extends NewsEvent {
  final List<String> ids;

  NewsDelete(this.ids);
}

class NewsEdit extends NewsEvent {
  final NewsModel news;

  NewsEdit(this.news);
}
