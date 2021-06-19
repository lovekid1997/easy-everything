library easy_everything;

import 'package:flutter/material.dart';

class EasyEverythingButton extends StatefulWidget {
  final Widget child;

  const EasyEverythingButton({required this.child});
  @override
  _EasyEverythingButtonState createState() => _EasyEverythingButtonState();
}

class _EasyEverythingButtonState extends State<EasyEverythingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(width: 15, height: 15, child: widget.child);
  }
}
