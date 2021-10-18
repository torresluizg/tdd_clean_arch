import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/exceptions.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/failure.dart';
import 'package:resocoder_tdd_clean_arch/app/core/network/i_network_info.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/datasources/i_number_trivia_local_data_source.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/datasources/i_number_trivia_remote_data_source.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/entities/number_trivia.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements INumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements INumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements INetworkInfo {}

void main() {
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;
  late NumberTriviaRepository repository;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDatasource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });
  tearDown(() {
    mockRemoteDataSource;
    mockLocalDatasource;
    mockNetworkInfo;
    repository;
  });

  void runTestsOnline(Function body) async {
    group('[device is online] ', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) async {
    group('[device is offline] ', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('[getConcreteNumberTrivia] ', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => 1);

      //act
      repository.getConcreteNumberTrivia(tNumber);

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should retrun server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
      test(
          'should retrun remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => 1);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => 1);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      });
    });

    runTestsOffline(() {
      test('should return CacheFailure when there is no data present',
          () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTriviaModel)));
      });
    });
  });

  group('[getRandomNumberTrivia] ', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 123);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => 1);

      //act
      repository.getRandomNumberTrivia();

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should retrun server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
      test(
          'should retrun remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => 1);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => 1);
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      });
    });

    runTestsOffline(() {
      test('should return CacheFailure when there is no data present',
          () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTriviaModel)));
      });
    });
  });
}
