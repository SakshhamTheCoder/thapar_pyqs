import 'dart:io';
import 'package:http/http.dart';
// import 'package:http/http.dart';
// import 'package:http/io_client.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyHttpClient {
  final headers = {
    'Accept': 'application/json, text/javascript, */*; q=0.01',
    'Accept-Language': 'en-US,en;q=0.9',
    'Connection': 'keep-alive',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'X-Requested-With': 'XMLHttpRequest',
    'sec-ch-ua': '"Chromium";v="122", "Not(A:Brand";v="24", "Google Chrome";v="122"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
  };
  Future<Response> get(String url) async {
    // final context = SecurityContext.defaultContext;
    // final httpClient = HttpClient(context: context);
    // final client = IOClient(httpClient);
    final client = Client();
    final response = await client.get(
      Uri.parse(url),
      headers: headers,
    );
    return response;
  }

  Future<Response> post(String url, Map<String, String> body) async {
    // final context = SecurityContext.defaultContext;
    // final httpClient = HttpClient(context: context);
    // final client = IOClient(httpClient);
    final client = Client();
    final response = await client.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    return response;
  }
}
