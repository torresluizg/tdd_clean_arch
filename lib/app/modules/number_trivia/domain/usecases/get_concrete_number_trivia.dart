import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/failure.dart';
import 'package:resocoder_tdd_clean_arch/app/core/usecases/i_usecase.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/repositories/i_number_trivia_repository.dart';

class GetConcreteNumberTrivia implements IUseCase<NumberTrivia, Params> {
  final INumberTriviaRepository repository;

  const GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
