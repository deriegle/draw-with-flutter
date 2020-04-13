import 'package:flutter/material.dart';
import 'main.dart';

class ActionButtons extends StatelessWidget {
  final double currentStrokeWidth;
  final Color currentStrokeColor;
  final Function onColorChangePress;
  final Function onStrokeIncrement;
  final Function onStrokeDecrement;
  final Function onClearPress;
  final Function onViewPress;

  ActionButtons({
    this.currentStrokeColor,
    this.currentStrokeWidth,
    this.onColorChangePress,
    this.onStrokeIncrement,
    this.onStrokeDecrement,
    this.onClearPress,
    this.onViewPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: currentStrokeColor,
            onPressed: onColorChangePress,
            heroTag: 'color-change',
            child: Icon(Icons.format_paint),
          ),
          FloatingActionButton(
            backgroundColor: currentStrokeWidth == MAX_POINT_SIZE ? Colors.grey : Colors.blue,
            onPressed: onStrokeIncrement,
            heroTag: 'stroke-increment',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            backgroundColor: currentStrokeWidth == MIN_POINT_SIZE ? Colors.grey : Colors.blue,
            onPressed: onStrokeDecrement,
            heroTag: 'stroke-decrement',
            child: Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: onClearPress,
            heroTag: 'clear-page',
            child: Icon(Icons.delete),
          ),
          FloatingActionButton(
            onPressed: onViewPress,
            heroTag: 'view-drawing',
            child: Icon(Icons.tv),
          ),
        ],
      ),
    );
  }
}
