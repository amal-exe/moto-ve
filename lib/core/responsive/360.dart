import 'package:flutter/material.dart';

class Car360View extends StatefulWidget {
  final List<String> images;

  const Car360View({super.key, required this.images});

  @override
  State<Car360View> createState() => _Car360ViewState();
}

class _Car360ViewState extends State<Car360View> {
  int currentIndex = 0;

  void onDragUpdate(DragUpdateDetails details) {
    double delta = details.delta.dx;

    if (delta > 0) {
      currentIndex--;
    } else {
      currentIndex++;
    }

    // 🔥 FIX: keep index in range
    if (currentIndex < 0) {
      currentIndex = widget.images.length - 1;
    } else if (currentIndex >= widget.images.length) {
      currentIndex = 0;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: onDragUpdate,
      child: Image.network(
        widget.images[currentIndex],
        fit: BoxFit.cover,
      ),
    );
  }
}

