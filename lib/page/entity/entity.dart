import 'package:flutter/material.dart';

class NavigationItem {
  int index;
  IconData icon;
  String title;

  NavigationItem(this.index, this.icon, this.title);
}

class ArticleData {
  String apkLink;
  String author;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  int superChapterId;
  String superChapterName;
  List<Tag> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  ArticleData(
      {this.apkLink,
      this.author,
      this.chapterId,
      this.chapterName,
      this.collect,
      this.courseId,
      this.desc,
      this.envelopePic,
      this.fresh,
      this.id,
      this.link,
      this.niceDate,
      this.origin,
      this.prefix,
      this.projectLink,
      this.publishTime,
      this.superChapterId,
      this.superChapterName,
      this.tags,
      this.title,
      this.type,
      this.userId,
      this.visible,
      this.zan});

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    var list = json["tags"] as List;
    List<Tag> tags = list.map((i) => Tag.fromJson(i)).toList();

    return ArticleData(
      apkLink: json['apkLink'],
      author: json['author'],
      chapterId: json['chapterId'],
      chapterName: json['chapterName'],
      collect: json['collect'],
      courseId: json['courseId'],
      desc: json['desc'],
      envelopePic: json['envelopePic'],
      fresh: json['fresh'],
      id: json['id'],
      link: json['link'],
      niceDate: json['niceDate'],
      origin: json['origin'],
      prefix: json['prefix'],
      projectLink: json['projectLink'],
      publishTime: json['publishTime'],
      superChapterId: json['superChapterId'],
      superChapterName: json['superChapterName'],
      tags: tags,
      title: json['title'],
      type: json['type'],
      userId: json['userId'],
      visible: json['visible'],
      zan: json['zan'],
    );
  }
}

class Tag {
  String name;
  String url;

  Tag({this.name, this.url});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
      url: json['url'],
    );
  }
}
