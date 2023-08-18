import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: SpotifyLoginButton()));
}

class SpotifyLoginButton extends StatefulWidget {
  @override
  _SpotifyLoginButtonState createState() => _SpotifyLoginButtonState();
}

class _SpotifyLoginButtonState extends State<SpotifyLoginButton> {
  final String clientId = "0ea2d1861e09419587f9e653805c6ada";
  final String clientSecret = "f71d3a9678c84146ab68b7e17c4991f3";
  final String redirectUri = "https://matchr.onrender.com/callback/";
  final String scopes =
      "user-read-private,user-read-playback-state,user-top-read,user-read-email,user-read-recently-played";
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  bool isLoading = false;
  String responseUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchResponseJson();
  }

  Future<void> _fetchResponseJson() async {
    try {
      final response = await http.get(Uri.parse('https://matchr.onrender.com/login'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        setState(() {
          responseUrl = jsonResponse['url'];
          print(responseUrl);
        });
      } else {
        throw Exception('Failed to fetch response');
      }
    } catch (e) {
      print('Error fetching response: $e');
    }
  }

  Future<void> _launchSpotifyLogin(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    if (responseUrl.isNotEmpty) {
      if (await canLaunch(responseUrl)) {
        flutterWebviewPlugin.launch(
          responseUrl,
          clearCookies: true,
          withJavascript: true,
        );
        flutterWebviewPlugin.onUrlChanged.listen((String url) async {
          print("URL changed: $url");
          if (url.startsWith(redirectUri)) {
            final Uri uri = Uri.parse(url);
            if (uri.queryParameters.containsKey("code")) {
              final code = uri.queryParameters["code"];
              final response = await http.get(Uri.parse('https://matchr.onrender.com/callback/?code=$code'));
              if (response.statusCode == 200) {
                Map<String, dynamic> jsonResponse = json.decode(response.body);
                print(jsonResponse);

                flutterWebviewPlugin.close();
              } else {
                print('Response status code: ${response.statusCode}');
                print('Response body: ${response.body}');
                print('Failed to fetch JSON response');
              }
            }
          }
        });
      } else {
        print('Could not launch $responseUrl');
      }
    } else {
      print('Response URL is empty: null');
    }
  }
  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 95, right: 95),
        child: Center(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
            onPressed: () => _launchSpotifyLogin(context),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.spotify),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Login with Spotify',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}