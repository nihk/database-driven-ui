import 'package:database_driven_fun/data/database_provider.dart';
import 'package:database_driven_fun/github_job_detail.dart';
import 'package:database_driven_fun/github_jobs_repository.dart';
import 'package:database_driven_fun/model/future_model.dart';
import 'package:database_driven_fun/model/github_job.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GitHubJobsRepository repository =
      GitHubJobsRepository(DatabaseProvider.get);
  static int _jobId = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        builder: (context) {
          return FutureModel<GitHubJob>(repository.fetchThenQuery());
        },
        child: Consumer<FutureModel<GitHubJob>>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Database Driven UI'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      model.setFuture(repository.fetchThenQuery());
                    },
                    tooltip: "Refresh",
                  ),
                  IconButton(
                    icon: Icon(Icons.plus_one),
                    onPressed: () {
                      model.setFuture(repository.insert(createDummyJob()));
                    },
                    tooltip: "Add a dummy job",
                  )
                ],
              ),
              body: FutureBuilder<List<GitHubJob>>(
                future: model.future,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<GitHubJob> jobs = snapshot.data;
                        return ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                                  height: 0.0,
                                  color: Colors.black,
                                ),
                            itemCount: jobs.length,
                            itemBuilder: (context, index) {
                              final GitHubJob job = jobs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          GitHubJobDetail(gitHubJob: job)));
                                },
                                child: ListTile(
                                  title: Text(
                                    job.title,
                                  ),
                                  subtitle: Text(job.company),
                                  leading: Image.network(
                                    job.companyLogo,
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Text('Error: ${snapshot.error}');
                      }
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  GitHubJob createDummyJob() {
    GitHubJob job = GitHubJob(
      id: _jobId.toString(),
      url: 'http://example.com',
      createdAt: "0",
      company: "The Internet",
      companyUrl: "http://example.com",
      location: "Earth",
      title: "Senior Flutter Developer #$_jobId",
      type: "Full time",
      description: "You will write code like a monkey",
      howToApply: "Carrier pidgeon",
      companyLogo: "https://www.w3schools.com/html/pic_trulli.jpg",
    );

    ++_jobId;

    return job;
  }
}
