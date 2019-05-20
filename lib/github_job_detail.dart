import 'package:database_driven_fun/model/github_job.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class GitHubJobDetail extends StatelessWidget {
  final GitHubJob gitHubJob;

  const GitHubJobDetail({Key key, @required this.gitHubJob}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gitHubJob.title),
      ),
      body: ListView(
        children: <Widget>[
          Image.network(
            gitHubJob.companyLogo,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Html(
              data: gitHubJob.description,
            ),
          ),
        ],
      ),
    );
  }
}
