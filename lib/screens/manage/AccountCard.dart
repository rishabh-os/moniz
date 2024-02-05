import "package:flutter/material.dart";
import "package:moniz/components/MoneyDisplay.dart";
import "package:moniz/components/deleteRoute.dart";
import "package:moniz/data/account.dart";
import "package:moniz/screens/manage/AccountIcon.dart";

class AccountCard extends StatefulWidget {
  const AccountCard({
    required this.key,
    required this.account,
    required this.income,
    required this.expense,
  }) : super(key: key);
  @override
  // ignore: overridden_fields
  final GlobalKey key;
  final Account account;
  final double income;
  final double expense;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        surfaceTintColor: Color(widget.account.color),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: ColorScheme.fromSeed(
                          seedColor: Color(widget.account.color),
                          brightness: Theme.of(context).brightness)
                      .primaryContainer,
                  borderRadius: const BorderRadius.only(
                      // ? The number 12 from Card definition
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
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
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: MoneyDisplay(amount: widget.account.balance),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Icon(Icons.arrow_circle_down),
                    const SizedBox(
                      width: 4,
                    ),
                    MoneyDisplay(amount: widget.income),
                  ],
                ),
                const SizedBox(
                  height: 60,
                  child: VerticalDivider(
                    thickness: 2,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.arrow_circle_up),
                    const SizedBox(
                      width: 4,
                    ),
                    MoneyDisplay(amount: widget.expense),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
