import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:quizzer/player.dart';

class PlayerHomepage extends StatelessWidget {
  const PlayerHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    Map routeData = ModalRoute.of(context)!.settings.arguments as Map;
    Player player = routeData['player'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Quizzer", style: Theme.of(context).textTheme.titleMedium),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/quizzer.png', width: 200, height: 200),
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.string(player.avatar, height: 50, width: 50),
              const Gap(10),
              Text(player.name),
            ],
          ),
          const Gap(20),
          FilledButton.icon(
            onPressed: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => _InstructionDialog(
                callback: () => Navigator.of(context).pushNamed(
                  '/quizPage',
                  arguments: {'player': player},
                ),
              ),
            ),
            icon: const Icon(Icons.play_arrow),
            label: const Text("Play Quiz"),
          ),
          const Gap(10),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(
              '/leaderboardPage',
            ),
            icon: const Icon(Icons.leaderboard),
            label: const Text("Leaderboard"),
          ),
          const Gap(10),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pushReplacementNamed(
              '/playerSelectionPage',
            ),
            icon: const Icon(Icons.swap_calls),
            label: const Text("Switch Player"),
          ),
          const Gap(10),
          FilledButton.icon(
            onPressed: () => SystemNavigator.pop(animated: true),
            icon: const Icon(Icons.exit_to_app),
            label: const Text("Quit"),
          ),
        ],
      ),
    );
  }
}

class _InstructionDialog extends StatelessWidget {
  final Function callback;

  const _InstructionDialog({required this.callback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text("Instructions"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "→ Quiz is of General Knowledge",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          Text(
            "→ Total 100 questions",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          Text(
            "→ Each Questions has time of 30",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          Text(
            "→ You will get a point for every correct answer",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          Text(
            "\nGood Luck :)",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            callback();
          },
          child: const Text('Play Quiz'),
        ),
      ],
    );
  }
}
