import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:quizzer/main.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Leaderboards',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: FutureBuilder(
        initialData: const [],
        future: db.getScores(),
        builder: (context, scoreSnap) {
          if (!scoreSnap.hasData) return Container();

          if (scoreSnap.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  'No Previous Scores :(\nBe the first one to have to have a score on board',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: scoreSnap.data!.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                initialData: const {'name': 'Name', 'Avatar': null},
                future: db.getPlayer(scoreSnap.data![index]['player']),
                builder: (context, playerSnap) {
                  if (!playerSnap.hasData) return const SizedBox();

                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Gap(20),
                        SvgPicture.string(
                          playerSnap.data?['avatar'] ??
                              '<svg xmlns="http://www.w3.org/2000/svg" width="0" height="0"></svg>',
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    title: Text(
                      playerSnap.data!['name'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      '${scoreSnap.data![index]['score']} out of 100',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Theme.of(context).colorScheme.tertiary,
                height: 10,
                thickness: 0.675,
                indent: 2.5,
                endIndent: 2.5,
              );
            },
          );
        },
      ),
    );
  }
}
