import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/failure.dart';

abstract class IUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
