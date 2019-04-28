import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String defaultTitle;
  final String url;

  WebViewPage(this.defaultTitle, this.url);

  @override
  State<StatefulWidget> createState() => _WebViewPageState(defaultTitle, url);
}

class _WebViewPageState extends State<WebViewPage> {
  String defaultTitle;
  String url;
  bool isRefreshing = true;
  WebViewController _controller;

  _WebViewPageState(this.defaultTitle, this.url);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onBackClicked(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text(defaultTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _controller.loadUrl(url);
                setState(() {
                  isRefreshing = true;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: _launchUrl,
            ),
            SizedBox(
              width: 8.0,
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: _onPageFinished,
              onWebViewCreated: (WebViewController controller) {
                _controller = controller;
              },
            ),
            isRefreshing
                ? Container(
                    margin: EdgeInsets.only(top: 30.0),
                    alignment: Alignment.topCenter,
                    child: RefreshProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  onBackClicked(BuildContext context) {
    Future<bool> canGoBack = _controller.canGoBack();
    canGoBack.then((value) {
      if (value) {
        _controller.goBack();
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  _onPageFinished(String newUrl) {
    this.url = newUrl;
    _controller.evaluateJavascript("window.document.title").then((title) {
      setState(() {
        defaultTitle = title.replaceAll(RegExp("^\"|\"\$"), "");
        isRefreshing = false;
      });
    });
  }

  _launchUrl() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Cannot launch the website");
    }
  }
}
