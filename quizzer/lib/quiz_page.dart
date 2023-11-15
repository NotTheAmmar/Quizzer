import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quizzer/main.dart';
import 'package:quizzer/player.dart';
import 'package:quizzer/question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> _questions = [Question.nullQuestion()];
  int _quesIndex = 0, _score = 0;
  int _count = 30;
  Player _player = Player.nullPlayer();
  Timer _counter = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();

    db.getQuizQuestions().then((questions) {
      _questions.clear();
      _questions.addAll(questions);
      _resetCounter();
    });
  }

  @override
  void didChangeDependencies() {
    Map routeData = ModalRoute.of(context)!.settings.arguments as Map;
    _player = routeData['player'];

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _counter.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: Text('Quiz', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          Text(
            '${_quesIndex + 1} | 100 ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Clock(width: 100, height: 100, count: _count),
            const Gap(20),
            SizedBox(
              width: double.maxFinite,
              child: Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(_questions[_quesIndex].question),
                ),
              ),
            ),
            _OptionTile(
              optionType: 'A',
              option: _questions[_quesIndex].optionA,
              onTap: () => _selectOption('A'),
            ),
            _OptionTile(
              optionType: 'B',
              option: _questions[_quesIndex].optionB,
              onTap: () => _selectOption('B'),
            ),
            _OptionTile(
              optionType: 'C',
              option: _questions[_quesIndex].optionC,
              onTap: () => _selectOption('C'),
            ),
            _OptionTile(
              optionType: 'D',
              option: _questions[_quesIndex].optionD,
              onTap: () => _selectOption('D'),
            ),
          ],
        ),
      ),
    );
  }

  void _resetCounter() {
    _counter.cancel();
    setState(() => _count = 30);

    _counter = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count > 0) {
        setState(() => _count--);
        return;
      }

      timer.cancel();
      if (_quesIndex == 99) {
        db.addScore(_player.id, _score);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => _QuizCompleteDialog(score: _score),
        );
      } else {
        _quesIndex++;
      }

      _resetCounter();
    });
  }

  void _selectOption(String option) {
    if (_questions[_quesIndex].answer == option) _score++;

    if (_quesIndex < 99) {
      setState(() => _quesIndex++);
    } else {
      db.addScore(_player.id, _score);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _QuizCompleteDialog(score: _score),
      );
    }

    _resetCounter();
  }
}

class _Clock extends StatelessWidget {
  final double width, height;
  final int count;

  const _Clock({
    required this.width,
    required this.height,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: (count > 10)
            ? Theme.of(context).colorScheme.tertiaryContainer
            : (count > 5)
                ? Colors.orange
                : Colors.red,
        shape: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FittedBox(child: Text('$count')),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final Function onTap;
  final String optionType, option;

  const _OptionTile({
    required this.optionType,
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        width: double.maxFinite,
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text("$optionType. $option"),
          ),
        ),
      ),
    );
  }
}

class _QuizCompleteDialog extends StatelessWidget {
  final int score;

  const _QuizCompleteDialog({required this.score});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text("Your Score"),
      content: Text(
        "$score out of 100",
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text("Back To Menu"),
        ),
      ],
    );
  }
}
