import 'package:database_driven_fun/data/dao.dart';
import 'package:database_driven_fun/model/github_job.dart';

class GitHubJobsDao implements Dao<GitHubJob> {
  final tableName = 'github_jobs';
  final columnId = 'id';
  final _columnType = 'type';
  final _columnUrl = 'url';
  final _columnCreatedAt = 'created_at';
  final _columnCompany = 'company';
  final _columnCompanyUrl = 'company_url';
  final _columnLocation = 'location';
  final _columnTitle = 'title';
  final _columnDescription = 'description';
  final _columnHowToApply = 'how_to_apply';
  final _columnCompanyLogo = 'company_logo';

  @override
  String get createTableQuery =>
      "CREATE TABLE $tableName($columnId TEXT PRIMARY KEY, "
      "$_columnType TEXT, "
      "$_columnUrl TEXT, "
      "$_columnCreatedAt TEXT, "
      "$_columnCompany TEXT, "
      "$_columnCompanyUrl TEXT, "
      "$_columnLocation TEXT, "
      "$_columnTitle TEXT, "
      "$_columnDescription TEXT, "
      "$_columnHowToApply TEXT, "
      "$_columnCompanyLogo TEXT)";

  @override
  GitHubJob fromMap(Map<String, dynamic> query) {
    return GitHubJob(
        id: query[columnId],
        type: query[_columnType],
        url: query[_columnUrl],
        createdAt: query[_columnCreatedAt],
        company: query[_columnCompany],
        companyUrl: query[_columnCompanyUrl],
        location: query[_columnLocation],
        title: query[_columnTitle],
        description: query[_columnDescription],
        howToApply: query[_columnHowToApply],
        companyLogo: query[_columnCompanyLogo]);
  }

  @override
  Map<String, dynamic> toMap(GitHubJob gitHubJob) {
    return <String, dynamic>{
      columnId: gitHubJob.id,
      _columnType: gitHubJob.type,
      _columnUrl: gitHubJob.url,
      _columnCreatedAt: gitHubJob.createdAt,
      _columnCompany: gitHubJob.company,
      _columnCompanyUrl: gitHubJob.companyUrl,
      _columnLocation: gitHubJob.location,
      _columnTitle: gitHubJob.title,
      _columnDescription: gitHubJob.description,
      _columnHowToApply: gitHubJob.howToApply,
      _columnCompanyLogo: gitHubJob.companyLogo,
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
