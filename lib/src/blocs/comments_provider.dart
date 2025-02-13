import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_bloc.dart';
export 'comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  CommentsProvider({super.key, required super.child})
      : bloc = CommentsBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CommentsBloc? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommentsProvider>()?.bloc;
  }
}