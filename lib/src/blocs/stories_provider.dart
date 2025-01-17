import 'package:flutter/material.dart';
import 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({super.key, required super.child})
      : bloc = StoriesBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static StoriesBloc? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoriesProvider>()?.bloc;
  }
}