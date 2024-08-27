import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final Function(String) onChanged;

  const TextInputWidget({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your answer here',
      ),
      maxLines: 3,
    );
  }
}