import 'package:flutter/material.dart';

class ColoredButton extends StatelessWidget {
  final Function? onPressed;
  final Widget child;
  final ButtonStyle? additionalStyle;
  const ColoredButton({super.key, this.onPressed, required this.child, this.additionalStyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ).merge(additionalStyle),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: child,
    );
  }
}
