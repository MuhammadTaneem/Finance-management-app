import 'package:flutter/material.dart';

class NavbarItem extends StatefulWidget {
  final Icon icon;
  final String label;
  const NavbarItem({Key? key, required this.icon, required this.label}) : super(key: key);
  @override
  State<NavbarItem> createState() => _NavbarItemState();
}

class _NavbarItemState extends State<NavbarItem> {
  @override
  Widget build(BuildContext context) {
    // return widget.icon;
    return Column(
      children: [
        const SizedBox(height: 20,),
        widget.icon,
        // Text(widget.label, style: Theme.of(context).appBarTheme.titleTextStyle),
        Text(widget.label),
      ],
    );
  }
}
