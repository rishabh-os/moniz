import "package:flutter/material.dart";

SnackBar deleteSnack(
  BuildContext context,
  String type,
  void Function() onPressed,
) {
  final lowercaseType = type.toLowerCase();
  return SnackBar(
    duration: const Duration(seconds: 1),
    content: Text("There are still transactions under this $lowercaseType"),
    action: SnackBarAction(
      label: "Delete",
      onPressed: () => {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Are you sure?"),
            content: Text(
              "This will delete all transactions associated with this $lowercaseType.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressed();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              ),
            ],
          ),
        ),
      },
    ),
  );
}

List<Widget> deleteAction(void Function() onTap) {
  return [
    IconButton.filledTonal(
      onPressed: onTap,
      icon: const Icon(Icons.delete_forever_rounded),
      tooltip: "Delete",
    ),
    const SizedBox(width: 10),
  ];
}
