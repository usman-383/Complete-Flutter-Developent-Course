import 'package:flutter/material.dart';
import 'package:todo_app/Utill/my_button.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      content: SizedBox(
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add a new task',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter task name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  label: 'Cancel',
                  elevated: false,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                MyButton(
                  label: 'Add',
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) Navigator.of(context).pop(text);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
