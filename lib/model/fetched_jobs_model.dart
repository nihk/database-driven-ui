import 'package:database_driven_fun/model/github_job.dart';
import 'package:flutter/foundation.dart';

class FetchedJobsModel extends ChangeNotifier {
  List<GitHubJob> _jobs = [];
  List<GitHubJob> get jobs => _jobs;

  ResourceState _state;
  ResourceState get state => _state;

  Future setJobs(Future<List<GitHubJob>> future) async {
    if (_state == ResourceState.LOADING) {
      return;
    }
    _state = ResourceState.LOADING;
    notifyListeners();
    List<GitHubJob> jobs = await future;
    _jobs = jobs;
    _state = ResourceState.SUCCESS;
    notifyListeners();
  }
}

enum ResourceState {
  LOADING,
  SUCCESS,
  ERROR,
}