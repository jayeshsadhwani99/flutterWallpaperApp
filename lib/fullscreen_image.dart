import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imgSrc;
  FullScreenImagePage(this.imgSrc);

  final LinearGradient backgroundGradient = new LinearGradient(
    colors: [Color(0x10000000), Color(0x30000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
          child: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: new Hero(
                tag: imgSrc,
                child: Image.network(imgSrc),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(
                        Icons.close,
                      ),
                      color: Colors.black,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
