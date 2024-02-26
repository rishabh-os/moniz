import "dart:ui";

import "package:flutter/material.dart";
import "package:glass_kit/glass_kit.dart";
import "package:moniz/components/MoneyDisplay.dart";
import "package:moniz/components/deleteRoute.dart";
import "package:moniz/data/account.dart";
import "package:moniz/screens/manage/AccountIcon.dart";

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

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

class _AccountCardState extends State<AccountCard>
    with SingleTickerProviderStateMixin {
  GlobalKey infoKey = GlobalKey();
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..repeat(min: -1.5, max: 1.5, period: const Duration(milliseconds: 5000));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ? It will be null on the first frame or so
    // ? As a result the frosted glass effect flickers while resizing but this is such a niche edge case idc
    final RenderBox? renderBox =
        infoKey.currentContext?.findRenderObject() as RenderBox?;
    final cardW = renderBox == null ? 0.0 : renderBox.size.width;
    final cardH = renderBox == null ? 0.0 : renderBox.size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          ShaderMask(
            // blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: const [
                  Color.fromRGBO(255, 255, 255, 0.8),
                  Colors.white,
                  Color.fromRGBO(255, 255, 255, 0.8),
                ],
                stops: const [
                  0.1,
                  0.3,
                  0.5,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform:
                    _SlidingGradientTransform(slidePercent: _controller.value),
              ).createShader(bounds);
            },
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  // padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: ColorScheme.fromSeed(
                              seedColor: Color(widget.account.color),
                              brightness: Theme.of(context).brightness)
                          .primaryContainer,
                      borderRadius: const BorderRadius.all(
                        // ? The number 12 from Card definition
                        Radius.circular(12),
                      )),
                  child: GlassContainer.frostedGlass(
                    color: Colors.transparent,
                    borderWidth: 0,
                    frostedOpacity: 0.1,
                    // ? Get this from parent
                    height: cardH,
                    width: cardW,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
          ),
          AccountInfo(
            widget: widget,
            key: infoKey,
          ),
        ],
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
            ReorderableDragStartListener(
                index: widget.account.order,
                child: const Icon(Icons.drag_indicator_rounded)),
            IconButton(
              onPressed: () => handleTap(widget.key, context, widget.account),
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
    );
  }
}
