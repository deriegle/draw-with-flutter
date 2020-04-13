import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draw with some friends',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Draw with friends'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const MAX_POINT_SIZE = 20.0;
const MIN_POINT_SIZE = 1.0;
const INCREMENT = 2;

const List<Color> COLORS = Colors.primaries;

class Line {
  Color color;
  List<Offset> offsets;
  double strokeWidth;
  Path path;

  Line(this.offsets, this.strokeWidth, this.color);
}

class _MyHomePageState extends State<MyHomePage> {
  List<Line> _lines = [];
  double currentStrokeWidth = 6;
  Color currentStrokeColor = Colors.red;

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

          if (currentLine.offsets.length == 10) {
            return;
          }

          setState(() {
            var path = Path();

            for (var i = 0; i < currentLine.offsets.length; i++) {
              var offset = currentLine.offsets[i];

              if (i == 0) {
                path.moveTo(offset.dx, offset.dy);
              } else {
                path.lineTo(offset.dx, offset.dy);
              }
            }

            currentLine.offsets = [];
            currentLine.path = path;
          });
        },
        child: Center(
          child: CustomPaint(
            painter: LinePainter(this._lines),
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
        }),
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

class ActionButtons extends StatelessWidget {
  final double currentStrokeWidth;
  final Color currentStrokeColor;
  final Function onColorChangePress;
  final Function onStrokeIncrement;
  final Function onStrokeDecrement;
  final Function onClearPress;

  ActionButtons({
    this.currentStrokeColor,
    this.currentStrokeWidth,
    this.onColorChangePress,
    this.onStrokeIncrement,
    this.onStrokeDecrement,
    this.onClearPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: currentStrokeColor,
            onPressed: onColorChangePress,
            child: Icon(Icons.format_paint),
          ),
          FloatingActionButton(
            backgroundColor: currentStrokeWidth == MAX_POINT_SIZE ? Colors.grey : Colors.blue,
            onPressed: onStrokeIncrement,
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            backgroundColor: currentStrokeWidth == MIN_POINT_SIZE ? Colors.grey : Colors.blue,
            onPressed: onStrokeDecrement,
            child: Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: onClearPress,
            child: Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  List<Line> _lines;

  LinePainter(this._lines) : super();

  @override
  void paint(Canvas canvas, Size size) {
    _lines.forEach((line) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;

      if (line.path != null) {
        canvas.drawPath(line.path, paint);
        return;
      }

      if (line.offsets.length > 1) {
        for (var i = 0; i < line.offsets.length - 1; i++) {
          canvas.drawLine(line.offsets[i], line.offsets[i + 1], paint);
        }
      } else {
        canvas.drawPoints(PointMode.points, line.offsets, paint);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
