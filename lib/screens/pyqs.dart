// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:thapar_pyqs/components/action_alert_dialog.dart';
import 'package:thapar_pyqs/components/colored_button.dart';
import 'package:thapar_pyqs/components/default_scaffold.dart';
import 'package:thapar_pyqs/utils/api_calls.dart';

class PYQsPage extends StatefulWidget {
  final String courseCode;
  const PYQsPage({super.key, required this.courseCode});

  @override
  State<PYQsPage> createState() => _PYQsPageState();
}

class _PYQsPageState extends State<PYQsPage> {
  Future<List>? _fetchPYQs;

  void downloadFile(String link, String name, String subtitle) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ActionAlertDialog(
          title: Text("Downloading"),
          loader: true,
          showCloseButton: false,
        );
      },
    );
    var file = await APICalls.downloadPDFFromServer(link, name, subtitle);

    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context2) {
        return ActionAlertDialog(
          title: const Text('Download complete'),
          content: Text('Downloaded to ${file.path}'),
          showCloseButton: true,
          actionText: "Open",
          action: () async {
            Navigator.pop(context2);
            OpenFilex.open(file.path);
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchPYQs = APICalls.fetchPYQs(widget.courseCode);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: "Thapar PYQs for ${widget.courseCode}",
      child: Center(
        child: FutureBuilder<List>(
          future: _fetchPYQs,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data!.isEmpty) {
                return const Text('No PYQs found for this course code');
              }
              return ListView.separated(
                clipBehavior: Clip.none,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final name = snapshot.data![index]['name'];
                  final year = snapshot.data![index]['year'];
                  final semester = snapshot.data![index]['semester'];
                  final type = snapshot.data![index]['type'];
                  final link = snapshot.data![index]['link'];
                  final subtitle = year + ' ' + semester + ' ' + type;
                  return ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          constraints: const BoxConstraints(maxHeight: 220),
                          context: context,
                          showDragHandle: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 16.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      name,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Year: $year"),
                                        Text("Semester: $semester"),
                                        Text("Type: $type"),
                                      ],
                                    ),
                                    ColoredButton(
                                        additionalStyle:
                                            ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
                                        child: const Text('Download PDF'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          downloadFile(link, name, subtitle);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      leading: Text((index + 1).toString()),
                      title: Text(name),
                      subtitle: Text(subtitle),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          downloadFile(link, name, subtitle);
                        },
                      ));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
