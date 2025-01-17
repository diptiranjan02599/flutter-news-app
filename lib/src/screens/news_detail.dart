import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;
  const NewsDetail({super.key, required this.itemId});


  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context)!;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('News Details!'),
        ),
        body: buildBody(bloc)
    );
  }

  buildBody(CommentsBloc bloc) {
    return StreamBuilder(
        stream: bloc.itemWithComments,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          }

          final itemFuture = snapshot.data?[itemId];
          return FutureBuilder(
              future: itemFuture,
              builder: (context, itemSnapshot) {
                if (!itemSnapshot.hasData) {
                  return Text('Loading');
                }

                return buildList(itemSnapshot.data, snapshot.data);
              }
          );
        }
    );
  }

  buildTitle(ItemModel? item) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(16),
      child: Text(
        item!.title!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  buildList(ItemModel? item, Map<int, Future<ItemModel>>? itemMap) {
    final commentsList = item?.kids?.map((kidId) {
      return Comment(itemId: kidId, itemMap: itemMap!, depth: 0,);
    }).toList();

    return ListView(
      children: [
        buildTitle(item),
        ...?commentsList
      ],
    );
  }


}