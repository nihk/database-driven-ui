import 'package:database_driven_fun/data/dao.dart';
import 'package:database_driven_fun/model/github_job.dart';

class GitHubJobsDao implements Dao<GitHubJob> {
  final tableName = 'github_jobs';
  final columnId = 'id';
  final _columnType = 'type';
  final _columnTitle = 'title';

  @override
  String get createTableQuery =>
      "CREATE TABLE $tableName($columnId TEXT PRIMARY KEY, "
      "$_columnType TEXT, "
      "$_columnTitle TEXT)";

  @override
  GitHubJob fromMap(Map<String, dynamic> query) {
    return GitHubJob(
      id: query[columnId],
      type: query[_columnType],
      title: query[_columnTitle],
    );
  }

  @override
  Map<String, dynamic> toMap(GitHubJob gitHubJob) {
    return <String, dynamic>{
      columnId: gitHubJob.id,
      _columnType: gitHubJob.type,
      _columnTitle: gitHubJob.title
    };
  }

  @override
  List<GitHubJob> fromList(List<Map<String, dynamic>> query) {
    List<GitHubJob> gitHubJobs = List<GitHubJob>();
    for (Map map in query) {
      gitHubJobs.add(fromMap(map));
    }
    return gitHubJobs;
  }
}
