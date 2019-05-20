import 'package:flutter/foundation.dart';

class GitHubJob {
  final String id;
  final String type;
  final String title;

  GitHubJob({@required this.id, @required this.type, @required this.title});

  factory GitHubJob.fromJson(Map<String, dynamic> json) => GitHubJob(
    id: json['id'],
    type: json['type'],
    title: json['title'],
  );
}