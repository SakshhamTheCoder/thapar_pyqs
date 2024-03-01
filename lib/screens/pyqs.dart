// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thapar_pyqs/components/default_scaffold.dart';
import 'package:html/parser.dart';
import 'package:thapar_pyqs/utils/http_client.dart';

class PYQsPage extends StatefulWidget {
  final String courseCode;
  const PYQsPage({super.key, required this.courseCode});

  @override
  State<PYQsPage> createState() => _PYQsPageState();
}

class _PYQsPageState extends State<PYQsPage> {
  Future<List>? _fetchPYQs;

  Future<List> fetchPYQs() async {
    final List pyqs = [];
    final response =
        await MyHttpClient().post('https://cl.thapar.edu/view1.php', {'ccode': widget.courseCode, 'submit': ''});
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final table = document.getElementsByTagName('table');
      final rows = table[0].getElementsByTagName('tr');
      for (var i = 0; i < rows.length; i++) {
        if (i == 0 || i == 1) continue;
        final cells = rows[i].getElementsByTagName('td');
        pyqs.add({
          'code': cells[0].text,
          'name': cells[1].text,
          'year': cells[2].text,
          'semester': cells[3].text,
          'type': cells[4].text,
          'link': cells[5].getElementsByTagName('a')[0].attributes['href'],
        });
      }
      return pyqs;
    } else {
      throw Exception('Failed to fetch PYQs');
    }
  }

  void downloadFile(String link, String name, String subtitle) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Downloading'),
          content: Row(
            children: [CircularProgressIndicator(), SizedBox(width: 18), Text("Please wait...")],
          ),
        );
      },
    );

    final response = await MyHttpClient().get('https://cl.thapar.edu/$link');
    bool dirDownloadExists = true;
    var dir = "/storage/emulated/0/Download/";
    dirDownloadExists = await Directory(dir).exists();
    if (dirDownloadExists) {
      dir = "/storage/emulated/0/Download";
    } else {
      dir = "/storage/emulated/0/Downloads";
    }
    final file = File("$dir/$name $subtitle.pdf");
    await file.writeAsBytes(response.bodyBytes);

    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Download complete'),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
            ],
          ),
          content: Text('Downloaded to ${file.path}'),
          actions: [
            TextButton(
              child: const Text('Open'),
              onPressed: () async {
                Navigator.pop(context); // Close the download complete dialog
                if (await Permission.audio.request().isGranted) {
                  OpenFilex.open("$dir/$name $subtitle.pdf");
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Permission not granted'),
                        content: const Text(
                            'Unable to open the file. Please give this app the permission to read files from internal storage.'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.pop(context); // Close the permission not granted dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchPYQs = fetchPYQs();
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
              return SizedBox(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final name = snapshot.data?[index]['name'];
                    final year = snapshot.data?[index]['year'];
                    final semester = snapshot.data?[index]['semester'];
                    final type = snapshot.data?[index]['type'];
                    final link = snapshot.data?[index]['link'];
                    final subtitle = year + ' ' + semester + ' ' + type;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
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
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                                foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                                minimumSize: const Size.fromHeight(40)),
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
                          )),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
