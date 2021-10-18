import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControlsWidget extends StatefulWidget {
  const TriviaControlsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControlsWidget> createState() => _TriviaControlsWidgetState();
}

class _TriviaControlsWidgetState extends State<TriviaControlsWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // TextField
      TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Input a number',
        ),
        keyboardType: TextInputType.number,
        controller: _controller,
      ),
      const SizedBox(height: 10),
      Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                addConcrete();
              },
              child: const Text('Search'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () {
                addRandom();
              },
              child: const Text('Get Random Trivia'),
            ),
          ),
        ],
      )
    ]);
  }

  void addConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForConcreteNumber(_controller.text),
    );
    _controller.clear();
  }

  void addRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      const GetTriviaForRandomNumber(),
    );
    _controller.clear();
  }
}
