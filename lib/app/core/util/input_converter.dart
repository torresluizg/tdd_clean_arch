import 'package:dartz/dartz.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);

      if (integer < 0) return Left(InvalidInputFailure());

      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
