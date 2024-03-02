import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:thapar_pyqs/components/action_alert_dialog.dart';
import 'package:thapar_pyqs/components/offline_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultScaffold extends StatefulWidget {
  final Widget child;
  final String title;
  const DefaultScaffold({super.key, required this.child, required this.title});

  @override
  State<DefaultScaffold> createState() => _DefaultScaffoldState();
}

class _DefaultScaffoldState extends State<DefaultScaffold> {
  bool isOffline = false;
  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
      } else if (value == ConnectivityResult.mobile || value == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
      }
    });
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
      } else if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
      }
    });
  }

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
                    return ActionAlertDialog(
                      title: const Text("About"),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "This app is made to help students of Thapar Institute of Engineering and Technology to access previous year question papers directly from their mobile phones."),
                          SizedBox(height: 10),
                          Text(
                              "The app is open source and the code is available on GitHub. If you have any suggestions or feedback, please feel free to open an issue on GitHub."),
                          SizedBox(height: 10),
                          Text("It is not affiliated with the university."),
                          SizedBox(height: 20),
                          Text("Developed by: Sakshham Bhagat"),
                          SizedBox(height: 10),
                          Text("Thank you for using this app!")
                        ],
                      ),
                      action: () async {
                        const url = 'https://github.com/SakshhamTheCoder/thapar_pyqs';
                        await launchUrl(Uri.parse(url));
                      },
                      actionText: "Source Code",
                      showCloseButton: true,
                    );
                  });
            },
            icon: const Icon(Icons.info),
          )
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: isOffline ? OfflineOverlay(child: widget.child) : widget.child,
      ),
    );
  }
}
