import 'package:flutter/foundation.dart';

class GitHubJob {
  final String id;
  final String type;
  final String url;
  final String createdAt;
  final String company;
  final String companyUrl;
  final String location;
  final String title;
  final String description;
  final String howToApply;
  final String companyLogo;

  GitHubJob({
    @required this.id,
    @required this.type,
    @required this.url,
    @required this.createdAt,
    @required this.company,
    @required this.companyUrl,
    @required this.location,
    @required this.title,
    @required this.description,
    @required this.howToApply,
    @required this.companyLogo,
  });

  factory GitHubJob.fromJson(Map<String, dynamic> json) => GitHubJob(
        id: json['id'],
        type: json['type'],
        url: json['url'],
        createdAt: json['created_at'],
        company: json['company'],
        companyUrl: json['company_url'],
        location: json['location'],
        title: json['title'],
        description: json['description'],
        howToApply: json['how_to_apply'],
        companyLogo: json['company_logo']
            ?? "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
      );
}
