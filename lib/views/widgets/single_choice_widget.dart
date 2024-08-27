import 'package:flutter/material.dart';

class SingleChoiceWidget extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;

  const SingleChoiceWidget({
    Key? key,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

  @override
  _SingleChoiceWidgetState createState() => _SingleChoiceWidgetState();
}

class _SingleChoiceWidgetState extends State<SingleChoiceWidget> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
            });
            widget.onSelected(value!);
          },
        );
      }).toList(),
    );
  }
}