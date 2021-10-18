import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/repositories/i_number_trivia_repository.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class NumberTriviaRepositoryMock extends Mock
    implements INumberTriviaRepository {}

void main() {
  NumberTriviaRepositoryMock numberTriviaRepositoryMock =
      NumberTriviaRepositoryMock();
  GetConcreteNumberTrivia usecase =
      GetConcreteNumberTrivia(numberTriviaRepositoryMock);

  const int tNumber = 1;
  const NumberTrivia tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia for the number from the repository', () async {
    //arrange
    when(() => numberTriviaRepositoryMock.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(tNumberTrivia));
    //act
    final result = await usecase.call(const Params(number: tNumber));
    //assert
    expect(result, const Right(tNumberTrivia));
    verify(() => numberTriviaRepositoryMock.getConcreteNumberTrivia(tNumber))
        .called(1);
  });
}
