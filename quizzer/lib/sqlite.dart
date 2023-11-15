import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:quizzer/player.dart';
import 'package:quizzer/question.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  late final Database _db;

  Future<void> init() async {
    _db = await openDatabase(
      "${await getDatabasesPath()}/quizzer.db",
      version: 1,
      singleInstance: true,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE Questions ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "question TEXT UNIQUE,"
          "optionA TEXT NOT NULL,"
          "optionB TEXT NOT NULL,"
          "optionC TEXT NOT NULL,"
          "optionD TEXT NOT NULL,"
          "answer TEXT NOT NULL"
          ")",
        );

        rootBundle.load('assets/questions/questions.xlsx').then((data) {
          List<int> bytes = data.buffer.asUint8List(
            data.offsetInBytes,
            data.lengthInBytes,
          );
          Excel excel = Excel.decodeBytes(bytes);
          for (var sheet in excel.tables.keys) {
            for (var row in excel.tables[sheet]!.rows) {
              db.insert('Questions', {
                'question': row[0]?.value.toString(),
                'optionA': row[1]?.value.toString(),
                'optionB': row[2]?.value.toString(),
                'optionC': row[3]?.value.toString(),
                'optionD': row[4]?.value.toString(),
                'answer': row[5]?.value.toString(),
              });
            }
          }
        });

        db.execute(
          "CREATE TABLE Players ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT UNIQUE,"
          "avatar TEXT NOT NULL"
          ")",
        );

        db.execute(
          "CREATE TABLE History ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "player INTEGER,"
          "score INTEGER CHECK(score >= 0),"
          "FOREIGN KEY (player) REFERENCES Players(id) ON DELETE CASCADE"
          ")",
        );
      },
      onOpen: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<List<Player>> getPlayers() async {
    return [
      for (Map player in await _db.query('Players', orderBy: 'name'))
        Player(id: player['id'], name: player['name'], avatar: player['avatar'])
    ];
  }

  Future<void> addPlayer(String name) async {
    await _db.insert(
      "Players",
      {'name': name, 'avatar': RandomAvatarString(name)},
    );
  }

  Future<bool> isPlayerNameTaken(String name) async {
    List<Map> result = await _db.query(
      'Players',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [name],
    );

    return result.isNotEmpty;
  }

  Future<void> deletePlayer(int id) async {
    await _db.delete('Players', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Question>> getQuizQuestions() async {
    List<Map> questions = await _db.query(
      'Questions',
      columns: [
        'question',
        'optionA',
        'optionB',
        'optionC',
        'optionD',
        'answer'
      ],
      orderBy: 'RANDOM()',
      limit: 100,
    );

    return [
      for (Map question in questions)
        Question(
          question: question['question'],
          optionA: question['optionA'],
          optionB: question['optionB'],
          optionC: question['optionC'],
          optionD: question['optionD'],
          answer: question['answer'],
        )
    ];
  }

  Future<void> addScore(int playerId, int score) async {
    await _db.insert("History", {'player': playerId, 'score': score});
  }

  Future<List<Map>> getScores() async {
    return await _db.query(
      'History',
      columns: ['player', 'score'],
      orderBy: 'score DESC',
    );
  }

  Future<Map> getPlayer(int id) async {
    List<Map> players = await _db.query(
      'Players',
      columns: ['name', 'avatar'],
      where: 'id = ?',
      whereArgs: [id],
    );

    return players.first;
  }
}
