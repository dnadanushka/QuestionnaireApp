
import 'package:flutter/material.dart';

import '../../models/question.dart';

class QuestionDialog extends StatefulWidget {
  final Question? question;

  const QuestionDialog({Key? key, this.question}) : super(key: key);

  @override
  _QuestionDialogState createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  late TextEditingController _textController;
  late TextEditingController _textControllerOption;
  late String _selectedType;
  List<String> _options = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.question?.text ?? '');
    _textControllerOption = TextEditingController(text: '');
    _selectedType = widget.question?.type ?? 'single_choice';
    _options = widget.question?.options ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.question == null ? 'Add Question' : 'Edit Question'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Question',
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(
                height:
                    16), // Add some space between the TextField and DropdownButton
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey[400]!),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedType,
                  hint: Text('Select question type'),
                  items: ['single_choice', 'multiple_choice', 'text_input']
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
              ),
            ),
            if (_selectedType != 'text_input') ...[
              ..._options.asMap().entries.map((entry) {
                return Row(
                  children: [
                    Expanded(child: Text(entry.value)),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _options.removeAt(entry.key);
                        });
                      },
                    ),
                  ],
                );
              }),
              SizedBox(height: 16,),
               Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    'Add Option ➕',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                   onPressed: _addOption,
                ),
              ),
        
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final question = Question(
              id: widget.question?.id ?? DateTime.now().toString(),
              text: _textController.text,
              type: _selectedType,
              options: _selectedType != 'text_input' ? _options : null,
              subQuestions: widget.question?.subQuestions,
            );
            Navigator.of(context).pop(question);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void _addOption() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Option'),
        content: TextField(
          controller: _textControllerOption,
           decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Option',
                filled: true,
                fillColor: Colors.grey[200],
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_textControllerOption.text);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _options.add(result);
      });
    }
  }
}
