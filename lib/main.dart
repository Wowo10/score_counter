import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Counter',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScoreCounter(title: 'Score Counter'),
    );
  }
}

class PlayerDto {
  PlayerDto({required this.name, required this.score});

  String name;
  int score;
}

class ScoreCounter extends StatefulWidget {
  ScoreCounter({super.key, required this.title});
  final String title;

  @override
  _ScoreCounterState createState() => _ScoreCounterState();
}

class _ScoreCounterState extends State<ScoreCounter> {
  final _playersList = <PlayerDto>[];
  final _biggerFont = TextStyle(fontSize: 22.0);
  final _myController = TextEditingController(text: 'Player');

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
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
            icon: Icon(Icons.delete),
            onPressed: _clearPlayerList,
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
                _myController.text =
                    'Player' + (_playersList.length + 1).toString();

                return SimpleDialog(
                    title: const Text('Input Player Name'),
                    contentPadding: EdgeInsets.all(24.0),
                    children: [
                      TextField(
                        controller: _myController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final returnValue = _myController.text;
                          Navigator.pop(context, returnValue);
                        },
                        // color: Colors.blue,
                        child: Text('Save'),
                      )
                    ]);
              });
          setState(() {
            if (playerName != null)
              _playersList.add(PlayerDto(name: playerName, score: 0));
          });
        },
        tooltip: 'Add Player',
        child: Icon(Icons.add),
      ),
    );
  }

  void _clearPlayerList() {
    setState(() {
      _playersList.clear();
    });
  }

  Widget _buildRow(PlayerDto dto) {
    return ListTile(
      title: Text(
        dto.name + ': ' + dto.score.toString(),
        style: _biggerFont,
      ),
      trailing: Icon(
        Icons.add,
        color: Colors.black,
      ),
      onTap: () {
        setState(() {
          dto.score += 1;
        });
      },
      onLongPress: () {
        setState(() {
          dto.score -= 1;
        });
      },
    );
  }
}
