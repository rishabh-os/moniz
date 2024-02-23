import "package:flutter/material.dart";
import "package:moniz/components/MoneyDisplay.dart";
import "package:moniz/components/deleteRoute.dart";
import "package:moniz/data/account.dart";
import "package:moniz/screens/manage/AccountIcon.dart";

class AccountCard extends StatefulWidget {
  const AccountCard({
    required this.key,
    required this.account,
  }) : super(key: key);
  @override
  // ignore: overridden_fields
  final GlobalKey key;
  final Account account;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: ColorScheme.fromSeed(
                          seedColor: Color(widget.account.color),
                          brightness: Theme.of(context).brightness)
                      .primaryContainer,
                  borderRadius: const BorderRadius.all(
                    // ? The number 12 from Card definition
                    Radius.circular(12),
                  )),
              child: Column(
                children: [
                  Row(
                    children: [
                      AccountIcon(
                          color: widget.account.color,
                          iconCodepoint: widget.account.iconCodepoint),
                      Text(
                        widget.account.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Expanded(child: SizedBox()),
                      ReorderableDragStartListener(
                          index: widget.account.order,
                          child: const Icon(Icons.drag_indicator_rounded)),
                      IconButton(
                        onPressed: () =>
                            handleTap(widget.key, context, widget.account),
                        icon: const Icon(Icons.edit),
                        tooltip: "Edit account",
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.6,
                          child: MoneyDisplay(amount: widget.account.balance),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
