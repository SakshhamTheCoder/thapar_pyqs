import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:thapar_pyqs/components/default_scaffold.dart';
import 'dart:convert';

import 'package:thapar_pyqs/screens/pyqs.dart';
import 'package:thapar_pyqs/utils/http_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();

  Future<List<String>> fetchSuggestions(String query) async {
    if (query.isEmpty || query == "") return [];
    final response = await MyHttpClient().get('https://cl.thapar.edu/search1.php?term=$query');
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return List<String>.from(data);
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

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
              TypeAheadField(
                autoFlipMinHeight: 200,
                hideOnEmpty: true,
                autoFlipDirection: true,
                onSelected: (suggestion) {
                  _controller.text = suggestion;
                },
                debounceDuration: const Duration(milliseconds: 500),
                suggestionsCallback: (pattern) async {
                  return await fetchSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                builder: (context, controller, focusNode) {
                  _controller = controller;
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Please enter a course code')));
                    return;
                  }
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PYQsPage(courseCode: _controller.text)));
                },
                child: const Text('Search for PYQs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
