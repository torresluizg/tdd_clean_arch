import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:resocoder_tdd_clean_arch/injection_container.dart';
import '../widgets/widgets_exports.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            // Top half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (_, state) {
                if (state is EmptyState) {
                  return const MessageDisplayWidget(message: 'Start searching');
                }

                if (state is ErrorState) {
                  return MessageDisplayWidget(message: state.message);
                }

                if (state is LoadedState) {
                  return TriviaDisplayWidget(numberTrivia: state.trivia);
                }

                return const LoadingWidget();
              },
            ),
            const SizedBox(height: 20),
            // Bottom half
            const TriviaControlsWidget(),
          ],
        ),
      ),
    );
  }
}
