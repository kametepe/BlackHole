/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 * 
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2023, Ankit Sangwan
 */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextInputDialog extends StatelessWidget {
  final String title;
  final String? initialText;
  final TextInputType keyboardType;
  final Function(String, BuildContext) onSubmitted;

  const TextInputDialog({
    required this.title,
    this.initialText,
    required this.keyboardType,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialText);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          TextField(
            autofocus: true,
            controller: controller,
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.bottom,
            onSubmitted: (value) {
              onSubmitted(value, context);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[700],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor:
                Theme.of(context).colorScheme.secondary == Colors.white
                    ? Colors.black
                    : Colors.white,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            onSubmitted(controller.text.trim(), context);
          },
          child: Text(
            AppLocalizations.of(context)!.ok,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}

void showTextInputDialog({
  required String title,
  required BuildContext context,
  String? initialText,
  required TextInputType keyboardType,
  required Function(String, BuildContext) onSubmitted,
}) {
  showDialog(
    context: context,
    builder: (BuildContext ctxt) {
      return TextInputDialog(
        title: title,
        initialText: initialText,
        keyboardType: keyboardType,
        onSubmitted: onSubmitted,
      );
    },
  );
}
