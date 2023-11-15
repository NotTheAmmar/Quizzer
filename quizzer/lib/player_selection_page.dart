import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:quizzer/main.dart';
import 'package:quizzer/player.dart';

class PlayerSelectionPage extends StatefulWidget {
  const PlayerSelectionPage({super.key});

  @override
  State<PlayerSelectionPage> createState() => _PlayerSelectionPageState();
}

class _PlayerSelectionPageState extends State<PlayerSelectionPage> {
  final List<Player> players = [];

  @override
  void initState() {
    super.initState();

    db.getPlayers().then((value) => setState(() => players.addAll(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Quizzer', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Center(
          child: Column(
            children: [
              const Text("Who is Playing?"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not on the list? No worries ",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => _AddPlayerDialog(),
                    ).then((_) => refreshPlayers()),
                    child: Text(
                      "add yourself here",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor:
                            Theme.of(context).colorScheme.inverseSurface,
                        color: Theme.of(context).colorScheme.inverseSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: SvgPicture.string(
                          players[index].avatar,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(
                          players[index].name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return _ConfirmDeletePlayerDialog(
                                    name: players[index].name,
                                    callback: () => db
                                        .deletePlayer(players[index].id)
                                        .then((value) => refreshPlayers()),
                                  );
                                },
                              ),
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                  '/playerHomepage',
                                  arguments: {'player': players[index]},
                                );
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refreshPlayers() {
    db.getPlayers().then((value) {
      setState(() {
        players.clear();
        players.addAll(value);
      });
    });
  }
}

class _AddPlayerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String playerName = "";

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text("Add Player"),
      content: TextField(
        decoration: InputDecoration(
          labelText: "Player Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(fontSize: 20),
        ),
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onChanged: (value) => playerName = value,
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            if (playerName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Name Cannot Be Empty',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                duration: const Duration(seconds: 1),
              ));
              return;
            }

            db.isPlayerNameTaken(playerName).then((taken) {
              if (taken) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Player Name already Taken',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  duration: const Duration(seconds: 1),
                ));
                return;
              }

              db.addPlayer(playerName);
              Navigator.of(context).pop();
            });
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

class _ConfirmDeletePlayerDialog extends StatelessWidget {
  final String name;
  final Function callback;

  const _ConfirmDeletePlayerDialog({
    required this.name,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('Delete Player $name'),
      content: Text(
        'Are You Sure?',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        FilledButton(
          onPressed: () {
            callback();
            Navigator.of(context).pop();
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
