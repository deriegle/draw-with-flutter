import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ViewDrawingPage extends StatefulWidget {
  final Picture picture;
  final Size size;

  ViewDrawingPage(this.picture, {@required this.size});

  @override
  _ViewDrawingPageState createState() => _ViewDrawingPageState();
}

class _ViewDrawingPageState extends State<ViewDrawingPage> {
  ByteData imgBytes;

  @override
  void initState() {
    super.initState();

    generateImageBytes();
  }

  void generateImageBytes() async {
    final image =
        await widget.picture.toImage(widget.size.width.toInt(), widget.size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    setState(() {
      imgBytes = pngBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = imgBytes == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? 'Loading...' : 'Check out your drawing'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => Share.file(
              'My Drawing',
              'my-drawing.png',
              imgBytes.buffer.asUint8List(),
              'image/png',
            ),
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Image.memory(
                Uint8List.view(imgBytes.buffer),
                width: widget.size.width,
                height: widget.size.height,
              ),
      ),
    );
  }
}
