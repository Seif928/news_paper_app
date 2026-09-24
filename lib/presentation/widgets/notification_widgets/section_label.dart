import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
