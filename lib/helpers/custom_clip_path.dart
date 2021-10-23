import 'package:flutter/material.dart';

class WaveShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var p = Path();
    p.moveTo(width * 0.4, height);
    p.cubicTo(width * 0.8, height * 0.5, width * 0.6, 0, width, 0);

    p.lineTo(width, height);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
