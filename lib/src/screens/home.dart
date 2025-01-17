import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/widgets/news_list_tile.dart';

import '../widgets/refresh.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Top News!'),
      ),
      body: buildList(bloc!)
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
        stream: bloc.topIds,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Refresh(
              ListView.builder(
                  itemBuilder: (context, int index) {
                    bloc.fetchItem(snapshot.data![index]);
                    return NewsListTile(itemId: snapshot.data![index]);
                  },
                  itemCount: snapshot.data?.length
              )
          );
        }
    );
  }
}