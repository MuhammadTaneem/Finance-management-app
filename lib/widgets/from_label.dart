import 'package:flutter/material.dart';

class CustomFromLabel extends StatelessWidget {
  final String label;
  final bool isRequired;
  const CustomFromLabel({Key? key, required this.label,  this.isRequired = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isRequired? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("  $label", style: Theme.of(context).textTheme.labelLarge,),
            Text("*",style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.redAccent),),
            ]) : Text("  $label", style: Theme.of(context).textTheme.labelLarge,),
        const SizedBox( height: 4),
      ],
    );
  }
}
