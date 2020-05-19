import 'package:flutter/material.dart';

class SimpleCheckBox extends StatefulWidget {
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool value;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final Function(bool) onChange;
  final Text text;

  const SimpleCheckBox({
    Key key,
    this.size = 45,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.transparent,
    this.value = false,
    this.borderRadius = 0,
    this.borderColor = Colors.grey,
    this.borderWidth = 1,
    this.onChange,
    this.text,
  }) : super(key: key);

  @override
  _SimpleCheckBoxState createState() => _SimpleCheckBoxState();
}

class _SimpleCheckBoxState extends State<SimpleCheckBox> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            color: _value ? widget.activeColor : widget.inactiveColor,
            border: Border.all(
              width: widget.borderWidth,
              color: widget.borderColor,
            ),
          ),
          child: RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            ),
            elevation: 0.0,
            onPressed: onTap,
            child: const SizedBox(),
          ),
        ),
        widget.text != null
            ? const SizedBox(
                width: 10,
              )
            : const SizedBox(),
        widget.text != null
            ? InkWell(
                onTap: onTap,
                child: widget.text,
              )
            : const SizedBox()
      ],
    );
  }

  void onTap() {
    setState(() {
      _value = !_value;
      if (widget.onChange != null) {
        widget.onChange(_value);
      }
    });
  }
}
