import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  String? id;
  String? title;
  String? content;
  String? imgUrl;
  DateTime? date;
  Timestamp? dateAdded;

  NewsModel({
    this.id,
    this.title,
    this.content,
    this.imgUrl,
    this.date,
    this.dateAdded,
  });

  factory NewsModel.fromJson(QueryDocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    print(json);
    return NewsModel(
      id: doc.id,
      title: json['title'] as String?,
      content: json['content'] as String?,
      imgUrl: json['imgUrl'] as String?,
      date: (json['date'] as Timestamp).toDate(),
      dateAdded: json['dateAdded'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'content': this.content,
      'imgUrl': this.imgUrl,
      'date': this.date,
      'dateAdded': FieldValue.serverTimestamp(),
    };
  }
}
