import "package:flutter/material.dart";
import "package:moniz/components/MoneyDisplay.dart";
import "package:moniz/components/deleteRoute.dart";
import "package:moniz/data/account.dart";
import "package:moniz/screens/manage/AccountIcon.dart";

class AccountCard extends StatefulWidget {
  const AccountCard({
    required this.globalKey,
    required this.account,
  }) : super(key: globalKey);
  final GlobalKey globalKey;
  final Account account;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  GlobalKey infoKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ColorScheme.fromSeed(
            dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
            seedColor: Color(widget.account.color),
            brightness: Theme.of(context).brightness,
          ).primaryContainer,
          borderRadius: const BorderRadius.all(
            // ? The number 12 from Card definition
            Radius.circular(12),
          ),
        ),
        child: AccountInfo(
          widget: widget,
          key: infoKey,
        ),
      ),
    );
  }
}

class AccountInfo extends StatelessWidget {
  const AccountInfo({
    super.key,
    required this.widget,
  });

  final AccountCard widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountIcon(
              color: widget.account.color,
              iconCodepoint: widget.account.iconCodepoint,
              showBgColor: false,
            ),
            Text(
              widget.account.name,
              style: const TextStyle(fontSize: 20),
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              onPressed: () =>
                  handleTap(widget.globalKey, context, widget.account),
              icon: const Icon(Icons.edit),
              tooltip: "Edit account",
            ),
            ReorderableDragStartListener(
              index: widget.account.order,
              child: const Icon(Icons.drag_indicator_rounded),
            ),
            const SizedBox(
              width: 6,
            ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
