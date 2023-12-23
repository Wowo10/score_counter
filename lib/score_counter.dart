import 'package:flutter/material.dart';
import 'package:score_counter/main.dart';
import 'package:score_counter/player_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

const darkMode = 'darkMode';

class ScoreCounter extends StatefulWidget {
  const ScoreCounter({super.key, required this.title});
  final String title;

  @override
  ScoreCounterState createState() => ScoreCounterState();
}

class ScoreCounterState extends State<ScoreCounter> {
  final _playersList = <PlayerDto>[];
  var _darkMode = false;
  final _biggerFont = const TextStyle(fontSize: 22.0);
  final _myController = TextEditingController(text: 'Player');

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _savePlayer(String name, int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(name, score);
  }

  Future<void> _saveDarkMode(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkMode, val);
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(darkMode) == true) {
      _darkMode = true;
      MyApp.of(context).changeTheme(ThemeMode.dark);
    }

    for (var scoreKey
        in prefs.getKeys().where((element) => element != darkMode)) {
      var scoreVal = prefs.getInt(scoreKey);

      setState(() {
        _playersList.add(PlayerDto(name: scoreKey, score: scoreVal!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _playersList.map((e) => _buildRow(e));
    final dividedTiles = ListTile.divideTiles(context: context, tiles: rows);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_night),
            onPressed: () {
              _darkMode = !_darkMode;
              _saveDarkMode(_darkMode);
              if (_darkMode) {
                MyApp.of(context).changeTheme(ThemeMode.dark);
              } else {
                MyApp.of(context).changeTheme(ThemeMode.light);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Clear?'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              _clearPlayerList();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes')),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('No'))
                      ],
                    );
                  });
            },
            tooltip: 'Clear',
          )
        ],
      ),
      body: ListView(
        children: dividedTiles.toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final playerName = await showDialog(
              context: context,
              builder: (_) {
                _myController.text = 'Player${_playersList.length + 1}';
                _myController.selection = TextSelection(
                    baseOffset: 0, extentOffset: _myController.text.length);

                return SimpleDialog(
                    title: const Text('Input Player Name'),
                    contentPadding: const EdgeInsets.all(24.0),
                    children: [
                      TextField(
                        controller: _myController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final returnValue = _myController.text;
                          Navigator.pop(context, returnValue);
                        },
                        child: const Text('Save'),
                      )
                    ]);
              });

          _savePlayer(playerName, 0);
          setState(() {
            if (playerName != null) {
              _playersList.add(PlayerDto(name: playerName, score: 0));
            }
          });
        },
        tooltip: 'Add Player',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _clearPlayerList() {
    setState(() {
      _playersList.clear();
    });

    () async {
      final prefs = await SharedPreferences.getInstance();

      for (var scoreKey
          in prefs.getKeys().where((element) => element != darkMode)) {
        prefs.remove(scoreKey);
      }
    }();
  }

  Widget _buildRow(PlayerDto dto) {
    return ListTile(
      title: Text(
        '${dto.name}: ${dto.score}',
        style: _biggerFont,
      ),
      trailing: const Icon(
        Icons.add,
      ),
      onTap: () {
        _savePlayer(dto.name, dto.score + 1);

        setState(() {
          dto.score++;
        });
      },
      onLongPress: () {
        _savePlayer(dto.name, dto.score - 1);

        setState(() {
          dto.score--;
        });
      },
    );
  }
}
