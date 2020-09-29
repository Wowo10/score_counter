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

  _ScoreCounterState() {
    _clearPlayerList();
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
        onPressed: () {
          setState(() {
            _playersList.add(PlayerDto(
                name: 'Player' + (_playersList.length + 1).toString(),
                score: 0));
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

      _playersList.add(PlayerDto(name: 'Player1', score: 0));
      _playersList.add(PlayerDto(name: 'Player2', score: 0));
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
