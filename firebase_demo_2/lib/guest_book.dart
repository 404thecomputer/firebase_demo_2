import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'guest_book_message.dart';
import 'src/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

typedef ColorEntry = DropdownMenuEntry<ColorLabel>;

enum ColorLabel {
  black('Black', Colors.black),
  red('Red', Colors.red),
  blue('Blue', Colors.blue),
  green('Green', Colors.green),
  purple('Purple', Colors.deepPurple);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;

  static final List<ColorEntry> entries = UnmodifiableListView<ColorEntry>(
    values.map<ColorEntry>(
      (ColorLabel color) => ColorEntry(
        value: color,
        label: color.label,
        style: MenuItemButton.styleFrom(
          foregroundColor: color.color,
        ),
      ),
    ),
  );
}

class GuestBook extends StatefulWidget {
  const GuestBook({
    super.key, 
    required this.addMessage, 
    required this.messages,
  });

  final FutureOr<void> Function(String message, String color) addMessage;
  final List<GuestBookMessage> messages; // new

  @override
  _GuestBookState createState() => _GuestBookState();
}


class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();
  Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownMenu<ColorLabel>(
                  initialSelection: ColorLabel.black,
                  label: const Text('Color'),
                  onSelected: (color) {
                    setState(() {
                      selectedColor = color!.color;
                    });
                  },
                  dropdownMenuEntries: ColorLabel.entries)
                ,
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text, selectedColor.toHexString());
                      _controller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('SEND'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var message in widget.messages)
          Paragraph('${message.name}: ${message.message}', message.strColor()),
        const SizedBox(height: 8),
      ],
    );
  }
}
