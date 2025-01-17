import 'package:flutter_test/flutter_test.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('fetchTopIds', () async {
    // setup of test case
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4, 5]), 200);
    });
    final ids = await newsApi.fetchTopIds();

    // expectation
    expect(ids, [1, 2, 3, 4, 5]);
  });

  test('fetchItem', () async {
    // setup of test case
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });
    final ItemModel item = await newsApi.fetchItem(999);

    // expectation
    expect(item.id, 123);
  });
}