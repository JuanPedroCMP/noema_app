import 'package:flutter/material.dart';
import 'package:noema/shared/floating_card/floating_card.dart';

void showPopup(BuildContext context, Widget child) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: entry.remove,
              child: Container(color: const Color.fromARGB(77, 0, 0, 0)),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: FloatingCard(
              width: 600,
              height: 420,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => entry.remove(),

                      icon: Icon(Icons.close_rounded),
                    ),
                  ),
                  Divider(),
                  child,
                ],
              ),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(entry);
}
