import 'package:flutter/material.dart';

class ActionAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget? content;
  final String? actionText;
  final Function? action;
  final bool showCloseButton;
  final bool loader;

  const ActionAlertDialog(
      {super.key,
      required this.title,
      this.content,
      this.actionText,
      this.action,
      this.showCloseButton = true,
      this.loader = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title,
            (showCloseButton)
                ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                : const SizedBox()
          ],
        ),
        content: (loader)
            ? const Row(
                children: [CircularProgressIndicator(), SizedBox(width: 18), Text("Please wait...")],
              )
            : content,
        actions: (actionText != null)
            ? [
                TextButton(
                  onPressed: () {
                    if (action != null) {
                      action!();
                    }
                  },
                  child: Text(actionText!),
                )
              ]
            : []);
  }
}
