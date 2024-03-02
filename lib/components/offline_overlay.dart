import 'package:flutter/material.dart';

class OfflineOverlay extends StatelessWidget {
  const OfflineOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: IgnorePointer(
          child: Stack(alignment: Alignment.center, children: [
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.signal_wifi_statusbar_connected_no_internet_4, size: 100),
            Text("No internet"),
          ],
        ),
        Opacity(opacity: 0.1, child: child)
      ])),
    );
  }
}
