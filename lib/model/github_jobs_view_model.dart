import 'package:database_driven_fun/github_jobs_repository.dart';
import 'package:database_driven_fun/model/github_job.dart';
import 'package:database_driven_fun/resource.dart';
import 'package:flutter/foundation.dart';

class GitHubJobsViewModel extends ChangeNotifier {
  Resource<List<GitHubJob>> _jobs = Resource.success([]);
  Resource<List<GitHubJob>> get jobs => _jobs;

  final GitHubJobsRepository repository;
  GitHubJobsViewModel({@required this.repository});

  Future<void> _run(Future<List<GitHubJob>> Function() runnable) async {
    if (_jobs.state == ResourceState.LOADING) {
      return;
    }

    _jobs = Resource.loading(_jobs.data);
    notifyListeners();

    _jobs = Resource.loading(await repository.queryAll());
    notifyListeners();

    _jobs = await runnable()
        .then((data) => Resource.success(data))
        .catchError((error) => Resource.error(_jobs.data, error));
    notifyListeners();
  }

  void fetchPurgeInsertQuery() {
    _run(() => repository.fetchPurgeInsertQuery());
  }

  void insertGitHubJob(GitHubJob gitHubJob) {
    _run(() => repository.insert(gitHubJob));
  }
}
