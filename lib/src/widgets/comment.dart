import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';


class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;
  const Comment({super.key, required this.itemId, required this.itemMap, required this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
        future: itemMap[itemId],
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }
          final item = snapshot.data!;
          final children = <Widget> [
            ListTile(
              title: buildText(item),
              subtitle: Text.rich(TextSpan(text: item.by ?? 'NA')),
              contentPadding: EdgeInsets.only(
                right: 16,
                left: (depth + 1) * 16
              ),
            ),
            Divider()
          ];
          item.kids?.forEach((kidId) {
            children.add(
              Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              )
            );
          });
          return Column(
            children: children
          );
        }
    );
  }

  buildText(ItemModel item) {
    final text = item.text?.replaceAll('&#x2F;', "/").replaceAll('<p>', '\n\n').replaceAll('</p>', '');
    return Text(text ?? 'NA');
  }

}