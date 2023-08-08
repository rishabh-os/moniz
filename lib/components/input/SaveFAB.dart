// ? Automatically fades out when the keyboard is visible
import "package:flutter/material.dart";

class SaveFAB extends StatelessWidget {
  const SaveFAB({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Visibility(
      visible: !keyboardIsOpen,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: !keyboardIsOpen ? 1 : 0,
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          label: const Text("Save"),
          icon: const Icon(Icons.save_rounded),
        ),
      ),
    );
  }
}
