// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:resocoder_tdd_clean_arch/app/core/error/failure.dart';
import 'package:resocoder_tdd_clean_arch/app/core/usecases/i_usecase.dart';
import 'package:resocoder_tdd_clean_arch/app/core/util/input_converter.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(EmptyState()) {
    on<NumberTriviaEvent>((event, emit) async {
      emit(EmptyState());
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        inputEither.fold(
          (l) {
            emit(const ErrorState(message: INPUT_FAILURE_MESSAGE));
          },
          (r) async {
            emit(LoadingState());

            final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: r));

            _eitherLoadedOrErrorState(failureOrTrivia, emit);
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        emit(LoadingState());

        final failureOrTrivia = await getRandomNumberTrivia(NoParams());

        _eitherLoadedOrErrorState(failureOrTrivia, emit);
      }
    });
  }

  void _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
    Emitter<NumberTriviaState> emit,
  ) {
    failureOrTrivia.fold(
      (l) {
        emit(ErrorState(message: _mapFailureToMessage(l)));
      },
      (r) async {
        emit(LoadedState(trivia: r));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
