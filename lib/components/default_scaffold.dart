import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class DefaultScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  const DefaultScaffold({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("About"),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "This app is made to help students of Thapar Institute of Engineering and Technology to access previous year question papers directly from there mobile phones. It is not affiliated with the university. The app is open source and the code is available on GitHub. If you have any suggestions or feedback, please feel free to open an issue on GitHub."),
                          SizedBox(height: 10),
                          Text("Version: 1.0.0"),
                          SizedBox(height: 10),
                          Text("Developed by: Sakshham Bhagat"),
                          SizedBox(height: 50),
                          Text("Thank you for using the app!")
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: const Text("Source Code"),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Close")),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.info),
          )
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            // Initially snapshot might be null, so use this to avoid errors
            if (snapshot.connectionState == ConnectionState.none) {
              return const CircularProgressIndicator();
            } else {
              ConnectivityResult? result = snapshot.data;
              if (result == ConnectivityResult.none) {
                return ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    0.2126, 0.7152, 0.0722, 0, 0, //
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
                  child: IgnorePointer(
                      child: Stack(alignment: Alignment.center, children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.signal_wifi_statusbar_connected_no_internet_4, size: 100),
                        Text("No internet"),
                      ],
                    ),
                    Opacity(opacity: 0.1, child: child)
                  ])),
                );
              } else {
                return child;
              }
            }
          },
        ),
      ),
    );
  }
}
