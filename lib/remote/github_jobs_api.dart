import 'dart:async';
import 'dart:convert';

import 'package:database_driven_fun/model/github_job.dart';
import 'package:http/http.dart' as http;

// todo: allow passing in of query params
Future<List<GitHubJob>> fetchJobs() async {
  final response = await http.get('https://jobs.github.com/positions.json');

  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);
    return list.map((job) => GitHubJob.fromJson(job)).toList();
  } else {
    return throw Exception('Failed to fetch positions remotely');
  }
}
