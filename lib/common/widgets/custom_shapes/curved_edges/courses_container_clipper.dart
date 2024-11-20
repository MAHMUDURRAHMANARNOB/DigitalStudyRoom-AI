import 'package:flutter/material.dart';

class CoursesContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 60)
      ..arcToPoint(
        Offset(size.width - 70, size.height),
        radius: Radius.circular(20),
        clockwise: false,
      )
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
