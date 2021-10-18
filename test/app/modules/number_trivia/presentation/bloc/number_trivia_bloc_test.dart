import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/failure.dart';
import 'package:resocoder_tdd_clean_arch/app/core/usecases/i_usecase.dart';
import 'package:resocoder_tdd_clean_arch/app/core/util/input_converter.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/presentation/bloc/number_trivia_bloc.dart';

const tNumberString = '1';
const tNumberParsed = 1;
const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

class MockGetConcreteNumerTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumerTrivia mockGetConcreteNumerTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUpAll(() {
    registerFallbackValue(const Params(number: 1));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetConcreteNumerTrivia = MockGetConcreteNumerTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumerTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });
  tearDown(() {
    mockInputConverter;
    mockGetConcreteNumerTrivia;
    mockGetRandomNumberTrivia;
    bloc;
  });

  void setUpMockInputConverterSuccess() =>
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(const Right(tNumberParsed));

  test('initialState should be EmptyState', () {
    // assert
    expect(bloc.state, equals(EmptyState()));
  });

  group('GetTriviaForConcreteNumber |', () {
    test('should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumerTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => mockGetConcreteNumerTrivia(any()));

      // assert
      verify(
        () => mockGetConcreteNumerTrivia(const Params(number: tNumberParsed)),
      ).called(1);
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumerTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // assert
      final expected = [
        EmptyState(),
        LoadingState(),
        const LoadedState(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // assert
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumerTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        EmptyState(),
        LoadingState(),
        const ErrorState(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // assert
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] with proper message for the error when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumerTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert
      final expected = [
        EmptyState(),
        LoadingState(),
        const ErrorState(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // assert
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber |', () {
    test('should get data from the random use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      bloc.add(const GetTriviaForRandomNumber());
      await untilCalled(() => mockGetRandomNumberTrivia(any()));

      // assert
      verify(
        () => mockGetRandomNumberTrivia(NoParams()),
      ).called(1);
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // assert
      final expected = [
        EmptyState(),
        LoadingState(),
        const LoadedState(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // assert
      bloc.add(const GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        EmptyState(),
        LoadingState(),
        const ErrorState(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // assert
      bloc.add(const GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with proper message for the error when getting data fails',
        () async {
      // arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert
      final expected = [
        EmptyState(),
        LoadingState(),
        const ErrorState(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // assert
      bloc.add(const GetTriviaForRandomNumber());
    });
  });
}
