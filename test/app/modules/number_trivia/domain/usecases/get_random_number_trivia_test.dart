import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/app/core/usecases/i_usecase.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/repositories/i_number_trivia_repository.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaRepositoryMock extends Mock
    implements INumberTriviaRepository {}

void main() {
  NumberTriviaRepositoryMock numberTriviaRepositoryMock =
      NumberTriviaRepositoryMock();
  GetRandomNumberTrivia usecase =
      GetRandomNumberTrivia(numberTriviaRepositoryMock);

  const NumberTrivia tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia from the repository', () async {
    //arrange
    when(() => numberTriviaRepositoryMock.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));
    //act
    final result = await usecase.call(NoParams());
    //assert
    expect(result, const Right(tNumberTrivia));
    verify(() => numberTriviaRepositoryMock.getRandomNumberTrivia()).called(1);
  });
}
