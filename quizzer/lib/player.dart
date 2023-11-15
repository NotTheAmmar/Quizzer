class Player {
  final int id;
  final String name, avatar;

  Player({required this.id, required this.name, required this.avatar});

  Player.nullPlayer()
      : id = -1,
        name = 'Player Name',
        avatar = '';
}
