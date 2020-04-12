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

const MAX_POINT_SIZE = 10.0;
const MIN_POINT_SIZE = 1.0;

const List<Color> COLORS = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.purple,
  Colors.blue,
  Colors.black,
  Colors.grey,
  Colors.blueGrey,
  Colors.amber,
  Colors.orange,
];

class Line {
  Color color;
  List<Offset> offsets;
  double strokeWidth;

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
        onPanEnd: (details) {},
        child: Center(
          child: CustomPaint(
            painter: DrawfulPainter(this._lines),
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
        onColorChangePress: () => setState(() {
          var random = Random();

          currentStrokeColor = COLORS[random.nextInt(COLORS.length)];
        }),
        onStrokeIncrement: () => setState(() {
          if (currentStrokeWidth == MAX_POINT_SIZE) {
            return;
          }
          currentStrokeWidth += 1;
        }),
        onStrokeDecrement: () => setState(() {
          if (currentStrokeWidth == MIN_POINT_SIZE) {
            return;
          }

          currentStrokeWidth -= 1;
        }),
        onClearPress: () => setState(() {
          _lines = [];
        }),
      ),
    );
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
          Container(
            height: currentStrokeWidth,
            width: currentStrokeWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentStrokeColor,
            ),
          ),
          FloatingActionButton(
              backgroundColor: currentStrokeColor,
              onPressed: onColorChangePress,
              child: Icon(Icons.format_paint)),
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

class DrawfulPainter extends CustomPainter {
  List<Line> _lines;

  DrawfulPainter(this._lines) : super();

  @override
  void paint(Canvas canvas, Size size) {
    _lines.forEach((line) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round;

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
