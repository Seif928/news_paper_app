import 'package:flutter/material.dart';

class InputSearch extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String> onTaped;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final FocusNode? focusNode;
  const InputSearch({
    super.key,
    required this.onTaped,
    required this.focusNode,
    required this.controller,
    required this.onBack,
    this.onSubmitted,
    this.autoFocus = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: const Icon(Icons.arrow_back, size: 28),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
        ),

        Expanded(
          child: TextField(
            focusNode: focusNode,
            onChanged: onChanged,
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: onSubmitted,
            autofocus: autoFocus,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search news, topics, or sources...',
              prefixIcon: InkWell(
                onTap: () {
                  onTaped(controller.text);
                },
                child: Icon(Icons.search, size: 25),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            ),
          ),
        ),
      ],
    );
  }
}
