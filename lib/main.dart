import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/screens/news_detail.dart';
import 'src/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
        child: StoriesProvider(
          child: MaterialApp(
              title: 'News!',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              onGenerateRoute: routes
          ),
        )
    );
  }

  Route routes(RouteSettings settings) {

    if (settings.name == '/') {
      return MaterialPageRoute(
          builder: (context) {
            final storiedBloc = StoriesProvider.of(context);
            storiedBloc?.fetchTopIds();
            return const MyHomePage();
          }
      );
    } else {
      return MaterialPageRoute(
          builder: (context) {
            final itemId = int.parse(settings.name!.replaceFirst('/', ''));
            final commentsBloc = CommentsProvider.of(context);
            commentsBloc?.fetchItemWithComments(itemId);

            return NewsDetail(
              itemId: itemId
            );
          }
      );
    }
  }
}
