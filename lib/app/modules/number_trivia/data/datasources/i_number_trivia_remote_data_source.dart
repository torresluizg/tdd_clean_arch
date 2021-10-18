import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/exceptions.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class INumberTriviaRemoteDataSource extends Equatable {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSource implements INumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSource({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final result = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (result.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(result.body));
    } else {
      throw ServerException();
    }
  }

  @override
  List<Object?> get props => [client];

  @override
  bool? get stringify => null;
}
