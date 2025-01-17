import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  const NewsListTile({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
        stream: bloc?.items, 
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }
          return FutureBuilder(
              future: snapshot.data?[itemId],
              builder: (context, itemSnapshot) {
                if (!itemSnapshot.hasData) {
                  return LoadingContainer();
                } else {
                  return buildTile(context, itemSnapshot.data!);
                }
              }
          );
        }
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(item.title ?? 'NA'),
          subtitle: Text('${item.score} points'),
          trailing: Column(
            children: [
              Icon(Icons.comment),
              Text(item.descendants.toString() ?? 'NA')
            ],
          ),
        ),

        Divider(
          height: 8,
        )
      ]
    );
  }
}