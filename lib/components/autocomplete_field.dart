// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:thapar_pyqs/utils/api_calls.dart';

class AutocompleteField extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  AutocompleteField({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      controller: textEditingController,
      autoFlipMinHeight: 200,
      hideOnEmpty: true,
      autoFlipDirection: true,
      onSelected: (suggestion) {
        textEditingController.text = suggestion;
      },
      debounceDuration: const Duration(milliseconds: 500),
      suggestionsCallback: (pattern) async {
        return await APICalls.fetchSuggestions(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      builder: (context, controller, focusNode) {
        textEditingController = controller;
        return TextField(
          textCapitalization: TextCapitalization.characters,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Enter course code',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      decorationBuilder: (context, child) {
        return Material(
          borderRadius: BorderRadius.circular(12),
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: 4.0,
          child: child,
        );
      },
      listBuilder: (context, children) {
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            return children.elementAt(index);
          },
        );
      },
      errorBuilder: (context, error) {
        return const Text("Error fetching suggestions");
      },
    );
  }
}
