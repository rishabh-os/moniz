import 'package:flutter/material.dart';
import 'package:moniz/small_components/AccountIcon.dart';
import 'package:moniz/components/MoneyDisplay.dart';
import 'package:moniz/data/account.dart';
import 'package:moniz/small_components/deleteRoute.dart';

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
              padding: const EdgeInsets.all(8),
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
                      IconButton(
                          onPressed: () =>
                              handleTap(widget.key, context, widget.account),
                          icon: const Icon(Icons.edit))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        MoneyDisplay(amount: widget.income),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_circle_down),
                            Text(" Income")
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                    child: VerticalDivider(
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        MoneyDisplay(amount: widget.expense),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_circle_up),
                            Text(" Expenses")
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
