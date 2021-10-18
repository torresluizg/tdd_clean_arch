import 'dart:convert';

import 'package:resocoder_tdd_clean_arch/app/core/error/exceptions.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class INumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToChace);
}

// ignore: constant_identifier_names
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSource implements INumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSource({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToChace) async {
    final triviaJson = json.encode(triviaToChace.toJson());
    bool storedInSharedPreferences = await sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      triviaJson,
    );
    if (storedInSharedPreferences) {
      return;
    } else {
      throw CacheException();
    }
  }
}
