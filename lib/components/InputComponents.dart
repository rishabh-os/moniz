// ? Automatically fades out when the keyboard is visible
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class AmountField extends StatefulWidget {
  const AmountField({
    super.key,
    required this.amountController,
    required this.amountCallback,
  });

  final Function(double amount) amountCallback;
  final TextEditingController amountController;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      onChanged: (value) {
        // ? Handles the case when the input field is empty and just -
        double returnAmount = 0;
        if (value.isNotEmpty && value != "-") {
          returnAmount = double.parse(value);
        }
        setState(() {
          widget.amountCallback(returnAmount);
        });
      },
      maxLength: 12,
      textAlign: TextAlign.center,
      controller: widget.amountController,
      style: const TextStyle(fontFamily: "VictorMono", fontSize: 50),
      inputFormatters: [
        // ? Allows only proper decimals upto 2 places
        FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+)?\.?\d{0,2}'))
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
          hintText: "00.00",
          floatingLabelBehavior: FloatingLabelBehavior.never),
    );
  }
}
