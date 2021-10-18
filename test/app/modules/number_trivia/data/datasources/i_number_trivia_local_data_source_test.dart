import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/exceptions.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/datasources/i_number_trivia_local_data_source.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        NumberTriviaLocalDataSource(sharedPreferences: mockSharedPreferences);
  });

  tearDown(() {
    mockSharedPreferences;
    dataSource;
  });

  group('getLastNumberTrivia |', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .called(1);
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is no cached value',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia |', () {
    const tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: 'test trivia',
    );
    test('should call SharedPreferences to cache the data', () async {
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      // arrange
      when(
        () => mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonString),
      ).thenAnswer((_) async => true);
      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      verify(() => mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA,
            expectedJsonString,
          )).called(1);
    });
  });
}
