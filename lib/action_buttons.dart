import 'package:flutter/material.dart';

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
