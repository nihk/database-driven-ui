import 'package:database_driven_fun/data/github_jobs_dao.dart';
import 'package:database_driven_fun/model/github_job.dart';
import 'package:database_driven_fun/remote/github_jobs_api.dart';
import 'package:sqflite/sqlite_api.dart';

import 'data/database_provider.dart';

class GitHubJobsRepository {
  final dao = GitHubJobsDao();

  DatabaseProvider databaseProvider;

  GitHubJobsRepository(this.databaseProvider);

  Future<List<GitHubJob>> insert(GitHubJob gitHubJob) async {
    final db = await databaseProvider.db();
    await db.insert(dao.tableName, dao.toMap(gitHubJob),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return await queryAll();
  }

  Future<List<GitHubJob>> insertAll(List<GitHubJob> jobs) async {
    final db = await databaseProvider.db();
    Batch batch = db.batch();
    jobs.forEach((job) => batch.insert(dao.tableName, dao.toMap(job),
        conflictAlgorithm: ConflictAlgorithm.replace));
    await batch.commit();
    return await queryAll();
  }

  Future<List<GitHubJob>> delete(GitHubJob gitHubJob) async {
    final db = await databaseProvider.db();
    await db.delete(dao.tableName,
        where: "${dao.columnId} = ?", whereArgs: [gitHubJob.id]);
    return await queryAll();
  }

  Future<List<GitHubJob>> _deleteAll() async {
    final db = await databaseProvider.db();
    await db.delete(dao.tableName);
    return await queryAll();
  }

  Future<List<GitHubJob>> update(GitHubJob gitHubJob) async {
    final db = await databaseProvider.db();
    await db.update(dao.tableName, dao.toMap(gitHubJob),
        where: "${dao.columnId} = ?", whereArgs: [gitHubJob.id]);
    return await queryAll();
  }

  Future<List<GitHubJob>> queryAll() async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName);
    return dao.fromList(maps);
  }

  Future<List<GitHubJob>> fetchPurgeInsertQuery() async {
    List<GitHubJob> jobs = await fetchJobs();
    await _deleteAll();
    await insertAll(jobs);
    return await queryAll();
  }
}
