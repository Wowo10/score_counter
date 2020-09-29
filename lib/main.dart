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
  PlayerDto({this.name, this.score});

  String name;
  int score;
}

class ScoreCounter extends StatefulWidget {
  ScoreCounter({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScoreCounterState createState() => _ScoreCounterState();
}

class _ScoreCounterState extends State<ScoreCounter> {
  final _playersList = <PlayerDto>[];
  final _biggerFont = TextStyle(fontSize: 22.0);
  final _myController = TextEditingController(text: 'Player');

  _ScoreCounterState() {
    _initPlayerList();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
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
              builder: (BuildContext context) {
                return SimpleDialog(
                    title: const Text('Input Player Name'),
                    children: [
                      TextField(
                        controller: _myController,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            _myController.text
                          );
                        },
                        color: Colors.blue,
                        child: Text('Save'),
                      )
                    ]);
              });

          setState(() {
            _playersList.add(PlayerDto(
                name: playerName,
                score: 0));
          });
        },
        tooltip: 'Add Player',
        child: Icon(Icons.add),
      ),
    );
  }

  void _initPlayerList() {
    _playersList.add(PlayerDto(name: 'Player1', score: 0));
    _playersList.add(PlayerDto(name: 'Player2', score: 0));
  }

  void _clearPlayerList() {
    setState(() {
      _playersList.clear();

      _initPlayerList();
    });
  }

  Widget _buildRow(PlayerDto dto) {
    return ListTile(
      title: Text(
        dto.name + ': ' + dto.score.toString(),
        style: _biggerFont,
      ),
      trailing: Icon(
        Icons.plus_one,
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
