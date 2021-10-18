import 'package:dartz/dartz.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/failure.dart';
import 'package:resocoder_tdd_clean_arch/app/core/usecases/i_usecase.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/repositories/i_number_trivia_repository.dart';

class GetRandomNumberTrivia implements IUseCase<NumberTrivia, NoParams> {
  final INumberTriviaRepository repository;

  const GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return repository.getRandomNumberTrivia();
  }
}
