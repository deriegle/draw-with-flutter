import 'dart:math';
import 'dart:ui';
import 'dart:convert' as json;

import 'package:drawful_impl/action_buttons.dart';
import 'package:drawful_impl/line_painter.dart';
import 'package:drawful_impl/pages/view_drawing_page.dart';
import 'package:flutter/material.dart';
import 'package:drawful_impl/models/line.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(MyApp());

const MAX_POINT_SIZE = 20.0;
const MIN_POINT_SIZE = 1.0;
const INCREMENT = 2;
const List<Color> COLORS = Colors.primaries;
const SERVER_LINE_OPACITY = 80;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draw with Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Draw with Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final channel = IOWebSocketChannel.connect('ws://192.168.1.10:8080');
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Line> _lines = [];
  List<Line> _serverLines = [];
  double currentStrokeWidth = 6;
  Color currentStrokeColor = Colors.red;

  @override
  void initState() {
    super.initState();

    widget.channel.stream.listen((data) {
      setState(() {
        var response = parseWebsocketMessage(data);

        if (response != null) {
          _serverLines.addAll(
              response.map((Line line) => line..color = line.color.withAlpha(SERVER_LINE_OPACITY)));
        }
      });
    }, onError: (err) => print(err));
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  void sendLineToServer(Line line) {
    print([line.toJson()].toString());

    widget.channel.sink.add(json.jsonEncode([
      line.toJson(),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: GestureDetector(
        onPanStart: (details) {
          print(details.localPosition);

          setState(() {
            _lines.add(Line([details.localPosition], this.currentStrokeWidth, currentStrokeColor));
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _lines.last.offsets.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          Line currentLine = _lines.last;
          setState(() {
            currentLine.getPathFromOffset();
            sendLineToServer(currentLine);
          });
        },
        child: Center(
          child: CustomPaint(
            painter: LinePainter(List.from([
              ..._serverLines,
              ..._lines,
            ])),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
      floatingActionButton: ActionButtons(
        currentStrokeColor: currentStrokeColor,
        currentStrokeWidth: currentStrokeWidth,
        onColorChangePress: () => setState(() => currentStrokeColor = getRandomColor()),
        onStrokeIncrement: () => setState(() {
          if (currentStrokeWidth == MAX_POINT_SIZE) {
            return;
          }
          currentStrokeWidth = currentStrokeWidth + INCREMENT > MAX_POINT_SIZE
              ? MAX_POINT_SIZE
              : currentStrokeWidth + INCREMENT;
        }),
        onStrokeDecrement: () => setState(() {
          if (currentStrokeWidth == MIN_POINT_SIZE) {
            return;
          }
          currentStrokeWidth = currentStrokeWidth - INCREMENT < MIN_POINT_SIZE
              ? MIN_POINT_SIZE
              : currentStrokeWidth - INCREMENT;
        }),
        onClearPress: () => setState(() {
          _lines = [];
          _serverLines = [];
        }),
        onViewPress: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ViewDrawingPage(
              getPictureFromCanvas(_lines),
              size: MediaQuery.of(context).size,
            ),
            maintainState: true,
          ),
        ),
      ),
    );
  }

  Color getRandomColor() {
    var random = Random();
    int currentColorIndex = COLORS.indexOf(currentStrokeColor);
    int randomIndex = random.nextInt(COLORS.length);

    while (randomIndex == currentColorIndex) {
      randomIndex = random.nextInt(COLORS.length);
    }

    return COLORS[randomIndex];
  }
}

List<Line> parseWebsocketMessage(String message) {
  print('Parsing new message: $message');

  try {
    Map<String, dynamic> parsedMessage = json.jsonDecode(message);

    if (parsedMessage == null || parsedMessage['lines'] == null) {
      print('returning early');
      return [];
    }

    return List.from(parsedMessage['lines']).map((el) => Line.fromJSON(el)).toList();
  } catch (e) {
    print('error parsing websocket');
    print(e);
    return [];
  }
}
