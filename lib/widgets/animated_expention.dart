import 'package:flutter/material.dart';

class AnimatedExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget body;

  const AnimatedExpansionTile({super.key, required this.title, required this.body});

  @override
  _AnimatedExpansionTileState createState() => _AnimatedExpansionTileState();
}

class _AnimatedExpansionTileState extends State<AnimatedExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.title,
                _isExpanded ?
                Icon(
                  Icons.expand_less,
                  color: Colors.teal,
                ) : Icon(
                  Icons.expand_more,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: _heightFactor,
          // child: Container(color: Colors.grey[200],child: widget.body),
          child: Container(
            color: Colors.grey[200],
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
                elevation: 0,
                margin: const EdgeInsets.only(top: 0, bottom: 10, right: 10, left: 10),
                child: widget.body),
          ),
        ),
      ],
    );
  }
}
