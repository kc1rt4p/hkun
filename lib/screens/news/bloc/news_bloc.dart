import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:hkun/models/news_model.dart';
import 'package:hkun/repositories/news_repository.dart';
import 'package:meta/meta.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial());
  final _newsRepo = NewsRepository();

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    try {
      yield LoadingNews();
      if (event is NewsGetList) {
        final list = await _newsRepo.getNews();
        yield NewsGetListSuccess(list);
      }

      if (event is NewsAdd) {
        final result = await _newsRepo.addNews(event.request, event.image);
        if (result)
          yield NewsAddSuccess();
        else
          yield NewsAddError();
      }

      if (event is NewsUpdate) {
        final result = await _newsRepo.updateNews(event.request, event.image);
        if (result)
          yield NewsUpdateSuccess();
        else
          yield NewsUpdateError();
      }

      if (event is NewsDelete) {
        event.ids.forEach((id) async {
          await _newsRepo.deleteNews(id);
        });
        yield NewsDeleteSuccess();
      }

      if (event is AddDeleteItem) {
        yield AddedDeleteItem(event.newsList);
      }
    } catch (e) {
      yield ErrorNews(e.toString());
    }
  }
}
