import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:thapar_pyqs/components/colored_button.dart';
import 'package:thapar_pyqs/components/default_scaffold.dart';

import 'package:thapar_pyqs/screens/pyqs.dart';

import '../components/autocomplete_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: "Thapar PYQs",
      child: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              ColorFiltered(
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcATop),
                  child: Image.asset('assets/images/ti_logo.png', height: 200, width: 200)),
              const SizedBox(height: 20),
              AutocompleteField(
                textEditingController: controller,
              ),
              // Autocomplete<String>(
              //   optionsBuilder: (TextEditingValue textEditingValue) async {
              //     final query = textEditingValue.text;
              //     if (query.isNotEmpty) {
              //       return await fetchSuggestions(query);
              //     } else {
              //       return [];
              //     }
              //   },
              //   onSelected: (String selection) {
              //     FocusScope.of(context).unfocus();
              //     _controller.text = selection;
              //   },
              //   fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
              //       FocusNode focusNode, VoidCallback onFieldSubmitted) {
              //     _controller = textEditingController;
              //     return TextField(
              //       controller: textEditingController,
              //       textCapitalization: TextCapitalization.characters,
              //       focusNode: focusNode,
              //       onTap: onFieldSubmitted,
              //       decoration: InputDecoration(
              //         hintText: 'Enter course code',
              //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              //       ),
              //     );
              //   },
              //   optionsViewBuilder:
              //       (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
              //     return Material(
              //       borderRadius: BorderRadius.circular(12),
              //       surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              //       elevation: 4.0,
              //       child: ListView.builder(
              //         padding: EdgeInsets.zero,
              //         itemCount: options.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           final option = options.elementAt(index);
              //           return ListTile(
              //             dense: true,
              //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //             title: Text(option),
              //             onTap: () {
              //               onSelected(option);
              //             },
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),
              const SizedBox(height: 20),
              ColoredButton(
                child: const Text("Search for PYQs"),
                onPressed: () {
                  log(controller.text);
                  if (controller.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Please enter a course code')));
                    return;
                  }
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PYQsPage(courseCode: controller.text)));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
