import 'package:database_driven_fun/data/database_provider.dart';
import 'package:database_driven_fun/github_job_detail.dart';
import 'package:database_driven_fun/github_jobs_repository.dart';
import 'package:database_driven_fun/model/github_jobs_view_model.dart';
import 'package:database_driven_fun/model/github_job.dart';
import 'package:database_driven_fun/resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        builder: (context) {
          final GitHubJobsRepository repository =
              GitHubJobsRepository(DatabaseProvider.get);
          GitHubJobViewModel viewModel =
              GitHubJobViewModel(repository: repository);
          viewModel.purgeFetchInsertQuery();
          return viewModel;
        },
        child: Consumer<GitHubJobViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Database Driven UI'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      viewModel.purgeFetchInsertQuery();
                    },
                    tooltip: "Refresh",
                  ),
                  IconButton(
                    icon: Icon(Icons.plus_one),
                    onPressed: () {
                      viewModel.insertGitHubJob(createDummyJob());
                    },
                    tooltip: "Add a dummy job",
                  )
                ],
              ),
              body: Stack(
                children: <Widget>[
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 0.0),
                    itemCount: viewModel.jobs.data.length,
                    itemBuilder: (context, index) {
                      return createJobTile(context, viewModel.jobs.data[index]);
                    },
                  ),
                  if (viewModel.jobs.state == ResourceState.LOADING)
                    Center(child: CircularProgressIndicator()),
                  if (viewModel.jobs.state == ResourceState.ERROR)
                    Center(
                      child: Text(
                        'FAILURE',
                        style: TextStyle(backgroundColor: Colors.red),
                      ),
                    ),
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
        leading: FadeInImage.memoryNetwork(
          image: job.companyLogo,
          width: 100.0,
          height: 100.0,
          fit: BoxFit.contain,
          placeholder: kTransparentImage,
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
