import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:resocoder_tdd_clean_arch/app/core/network/i_network_info.dart';
import 'package:resocoder_tdd_clean_arch/app/core/util/input_converter.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/datasources/i_number_trivia_local_data_source.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/datasources/i_number_trivia_remote_data_source.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/repositories/i_number_trivia_repository.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.I;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        getConcreteNumberTrivia: sl(),
        getRandomNumberTrivia: sl(),
        inputConverter: sl(),
      ));
  // Use Cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<INumberTriviaRepository>(
      () => NumberTriviaRepository(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));
  // Data Souces
  sl.registerLazySingleton<INumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSource(client: sl()));
  sl.registerLazySingleton<INumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSource(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<INetworkInfo>(() => NetworkInfo(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
