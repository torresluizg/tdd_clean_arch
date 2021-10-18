import 'package:flutter/material.dart';
import 'package:resocoder_tdd_clean_arch/app/modules/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:resocoder_tdd_clean_arch/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
