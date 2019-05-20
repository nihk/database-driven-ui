import 'package:database_driven_fun/github_jobs_repository.dart';
import 'package:database_driven_fun/model/github_job.dart';
import 'package:database_driven_fun/resource.dart';
import 'package:flutter/foundation.dart';

class GitHubJobViewModel extends ChangeNotifier {
  final GitHubJobsRepository repository;

  Resource<List<GitHubJob>> _jobs = Resource.success([]);

  Resource<List<GitHubJob>> get jobs => _jobs;

  GitHubJobViewModel({@required this.repository});

  Future<void> _run(Future<List<GitHubJob>> Function() run) async {

    if (_jobs.state == ResourceState.LOADING) {
      return;
    }
    _jobs = Resource.loading(_jobs.data);
    notifyListeners();

    // fixme: why is this empty? the future is being started at the moment _run is called
    List<GitHubJob> gitHubJobs = await repository.queryAll();
    _jobs = Resource.loading(gitHubJobs);
    notifyListeners();

    gitHubJobs = await run().catchError((error) {
      _jobs = Resource.error(_jobs.data, error);
    });
    if (gitHubJobs != null) {
      _jobs = Resource.success(gitHubJobs);
    }
    notifyListeners();
  }

  void purgeFetchInsertQuery() {
    Future<List<GitHubJob>> Function() run = () {
        return repository.purgeFetchInsertQuery();
    };
    _run(run);
  }

  void insertGitHubJob(GitHubJob gitHubJob) {
    Future<List<GitHubJob>> Function() run = () {
        return repository.insert(gitHubJob);
    };
    _run(run);
  }
}
