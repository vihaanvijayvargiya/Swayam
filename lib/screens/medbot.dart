import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MedBotPage extends StatefulWidget {
  const MedBotPage({super.key});

  @override
  State<MedBotPage> createState() => _MedBotPageState();
}

class _MedBotPageState extends State<MedBotPage> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await inAppWebViewController.canGoBack();

        if (isLastPage) {
          inAppWebViewController.goBack();
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Center(
              child: Text(
                'Sarthi - Medical Bot',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      'https://mediafiles.botpress.cloud/e1e98523-55ec-43ac-9ed4-0db6e35ce023/webchat/bot.html')),
              onWebViewCreated: (InAppWebViewController controller) {
                inAppWebViewController = controller;
              },
              onProgressChanged: (InAppWebViewController controller,
                  int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  disableDefaultErrorPage: false,
                  supportMultipleWindows: false,
                  cacheMode: AndroidCacheMode.LOAD_DEFAULT,
                ),
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
              ),
            ),
            _progress < 1
                ? LinearProgressIndicator(
              value: _progress,
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
