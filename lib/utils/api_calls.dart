import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:thapar_pyqs/utils/http_client.dart';

class APICalls {
  static Future<List<String>> fetchSuggestions(String query) async {
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

  static Future<List> fetchPYQs(courseCode) async {
    final List pyqs = [];
    final response = await MyHttpClient().post('https://cl.thapar.edu/view1.php', {'ccode': courseCode, 'submit': ''});
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

  static Future<File> downloadPDFFromServer(String link, String name, String subtitle) async {
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
    return file;
  }
}

Future<List> fetchPYQs(courseCode) async {
  final List pyqs = [];
  final response = await MyHttpClient().post('https://cl.thapar.edu/view1.php', {'ccode': courseCode, 'submit': ''});
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
