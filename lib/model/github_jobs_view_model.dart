import 'package:database_driven_fun/github_jobs_repository.dart';
import 'package:database_driven_fun/model/github_job.dart';
import 'package:database_driven_fun/resource.dart';
import 'package:flutter/foundation.dart';

class GitHubJobsViewModel extends ChangeNotifier {
  final GitHubJobsRepository repository;

  Resource<List<GitHubJob>> _jobs = Resource.success([]);

  Resource<List<GitHubJob>> get jobs => _jobs;

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

  void purgeFetchInsertQuery() {
    _run(() => repository.purgeFetchInsertQuery());
  }

  void insertGitHubJob(GitHubJob gitHubJob) {
    _run(() => repository.insert(gitHubJob));
  }
}
