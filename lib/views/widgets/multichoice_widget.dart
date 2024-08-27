import 'package:flutter/material.dart';

class MultipleChoiceWidget extends StatefulWidget {
  final List<String> options;
  final Function(List<String>) onChanged;

  const MultipleChoiceWidget({
    Key? key,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  _MultipleChoiceWidgetState createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  final Set<String> _selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return CheckboxListTile(
          title: Text(option),
          value: _selectedOptions.contains(option),
          onChanged: (bool? value) {
            setState(() {
              if (value!) {
                _selectedOptions.add(option);
              } else {
                _selectedOptions.remove(option);
              }
            });
            widget.onChanged(_selectedOptions.toList());
          },
        );
      }).toList(),
    );
  }
}