import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hkun/models/news_model.dart';

class NewsRepository {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance.ref();

  late CollectionReference _newsCollection;

  NewsRepository() {
    this._newsCollection = db.collection('news');
  }

  Future<bool> addNews(NewsModel news, File image) async {
    try {
      final snapshot = await storage
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(image);
      final imgURL = await snapshot.ref.getDownloadURL();
      news.imgUrl = imgURL;
      print(news.toJson());
      await _newsCollection.add(news.toJson());
      return true;
    } catch (e) {
      print('ERROR ADDING NEWS: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateNews(NewsModel news, File? image) async {
    try {
      if (image != null) {
        await FirebaseStorage.instance.refFromURL(news.imgUrl!).delete();
        final snapshot = await storage
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(image);
        news.imgUrl = await snapshot.ref.getDownloadURL();
      }

      await _newsCollection.doc(news.id).set(news.toJson());
      return true;
    } catch (e) {
      print('ERROR UPDATING NEWS: ${e.toString()}');
      return false;
    }
  }

  Future<List<NewsModel>> getNews() async {
    try {
      final querySnapshot =
          await _newsCollection.orderBy('date', descending: true).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((item) => NewsModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('ERROR GETTING NEWS: ${e.toString()}');
      return [];
    }
  }

  Future<bool> deleteNews(String id) async {
    try {
      await _newsCollection.doc(id).delete();
      return true;
    } catch (e) {
      print("ERROR DELETING NEWS: ${e.toString()}");
      return false;
    }
  }
}
