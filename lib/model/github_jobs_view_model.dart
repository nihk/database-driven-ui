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

    List<GitHubJob> gitHubJobs = await repository.queryAll();
    _jobs = Resource.loading(gitHubJobs);
    notifyListeners();

    gitHubJobs = await runnable().catchError((error) {
      _jobs = Resource.error(_jobs.data, error);
    });
    if (gitHubJobs != null) {
      _jobs = Resource.success(gitHubJobs);
    }
    notifyListeners();
  }

  void purgeFetchInsertQuery() {
    Future<List<GitHubJob>> Function() runnable = () {
        return repository.purgeFetchInsertQuery();
    };
    _run(runnable);
  }

  void insertGitHubJob(GitHubJob gitHubJob) {
    Future<List<GitHubJob>> Function() runnable = () {
        return repository.insert(gitHubJob);
    };
    _run(runnable);
  }
}
