import "package:flutter/material.dart";
import "package:flutter/services.dart";

class AmountField extends StatefulWidget {
  const AmountField({
    super.key,
    required this.amountController,
    required this.amountCallback,
  });

  final void Function(double amount) amountCallback;
  final TextEditingController amountController;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key("amount"),
      onChanged: (value) {
        // ? Handles the case when the input field is empty and just - or .
        double returnAmount = 0;
        if (value.isNotEmpty && value != "-" && value != ".") {
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
        FilteringTextInputFormatter.allow(RegExp(r"^-?(\d+)?\.?\d{0,2}")),
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        counterText: "",
        border: InputBorder.none,
        hintText: "00.00",
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
