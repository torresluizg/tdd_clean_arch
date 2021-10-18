import 'package:resocoder_tdd_clean_arch/app/core/error/exceptions.dart';
import 'package:resocoder_tdd_clean_arch/app/core/network/i_network_info.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/datasources/i_number_trivia_local_data_source.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/datasources/i_number_trivia_remote_data_source.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/repositories/i_number_trivia_repository.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepository implements INumberTriviaRepository {
  final INumberTriviaRemoteDataSource remoteDataSource;
  final INumberTriviaLocalDataSource localDataSource;
  final INetworkInfo networkInfo;

  NumberTriviaRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
