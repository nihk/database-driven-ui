import 'package:database_driven_fun/data/database_provider.dart';
import 'package:database_driven_fun/github_job_detail.dart';
import 'package:database_driven_fun/github_jobs_repository.dart';
import 'package:database_driven_fun/model/fetched_jobs.dart';
import 'package:database_driven_fun/model/github_job.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GitHubJobsRepository repository =
      GitHubJobsRepository(DatabaseProvider.get);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        builder: (context) {
          FetchedJobs fetchedJobs = FetchedJobs();
          fetchedJobs.setJobs(repository.fetchThenQuery());
          print('Fetching initial jobs');
          return fetchedJobs;
        },
        child: Consumer<FetchedJobs>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Database Driven UI'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      model.setJobs(repository.fetchThenQuery());
                    },
                    tooltip: "Refresh",
                  ),
                  IconButton(
                    icon: Icon(Icons.plus_one),
                    onPressed: () {
                      model.setJobs(repository.insert(createDummyJob()));
                    },
                    tooltip: "Add a dummy job",
                  )
                ],
              ),
              body: Stack(
                children: <Widget>[
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 0.0),
                    itemCount: model.jobs.length,
                    itemBuilder: (context, index) {
                      return createJobTile(context, model.jobs[index]);
                    },
                  ),
                  if (model.state == ResourceState.LOADING)
                    Center(child: CircularProgressIndicator())
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget createJobTile(BuildContext context, GitHubJob job) {
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
  }

  static int _dummyJobId = 0;

  GitHubJob createDummyJob() {
    GitHubJob job = GitHubJob(
      id: _dummyJobId.toString(),
      url: 'http://example.com',
      createdAt: "0",
      company: "The Internet",
      companyUrl: "http://example.com",
      location: "Earth",
      title: "Senior Flutter Developer #$_dummyJobId",
      type: "Full time",
      description: "You will write code like a monkey",
      howToApply: "Carrier pidgeon",
      companyLogo: "https://www.w3schools.com/html/pic_trulli.jpg",
    );

    ++_dummyJobId;

    return job;
  }
}
