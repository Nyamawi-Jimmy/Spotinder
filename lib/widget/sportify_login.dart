import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final String clientID = 'babb044c7b6049a1b5b9f9393fbc924d';
  final String clientSecret = 'cc445a7d47dc449882c756354699c275';
  final String redirectURI = 'valid-demo://callback';
  final String scope = 'user-read-private user-read-email';

  late String accessToken;
  late String refreshToken;

  Uri get createAuthenticationUri {
    var query = [
      'response_type=code',
      'client_id=$clientID',
      'scope=${Uri.encodeComponent(scope)}',
      'redirect_uri=${Uri.encodeComponent(redirectURI)}',
    ];

    var queryString = query.join('&');
    var url = 'https://accounts.spotify.com/authorize?$queryString';
    var parsedUrl = Uri.parse(url);
    return parsedUrl;
  }

  Future<void> launchInBrowser() async {
    final url = createAuthenticationUri.toString();
    if (await canLaunch(url)) {
      await launch(url);
      initUniLinks(); // Initialize UniLinks after the URL is launched
    } else {
      throw Exception('Could not launch URL');
    }
  }
  Future<void> saveTokenToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<void> getAccessToken(String code) async {
    var body = {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': redirectURI,
      'client_id': clientID,
      'client_secret': clientSecret
    };

    var header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization':
      'Basic ${base64Encode(utf8.encode('$clientID:$clientSecret'))}'
    };

    var response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      body: body,
      headers: header,
    );

    log('check status code: ${response.statusCode}');
    log('check body: ${response.body}');

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      accessToken = data['access_token'];
      print('token: $accessToken');

      if (accessToken != null) {
        Navigator.pushReplacementNamed(context, 'boarding');
        initUniLinks(); // Initialize UniLinks after successful navigation
      } else {
        log('Something went wrong');
      }
    } else {
      log('Something went wrong');
    }
  }

  Future<void> deleteTokenFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => initUniLinks());
  }

  @override
  void dispose() {
    deleteTokenFromPreferences(); // Clear the token on hot reload
    super.dispose();
  }

  Future<void> initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        final uri = Uri.parse(initialLink);
        if (uri.queryParameters.containsKey('code')) {
          final code = uri.queryParameters['code'];
          getAccessToken(code!);
        }
      } else {
        getLinksStream().listen((String? link) {
          if (link != null) {
            final uri = Uri.parse(link);
            if (uri.queryParameters.containsKey('code')) {
              final code = uri.queryParameters['code'];
              getAccessToken(code!);
            }
          }
        }, onError: (err) {
          log('Error listening to app links: $err');
        });
      }
    } on PlatformException {
      log('Error initializing uni_links');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Web API'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await launchInBrowser();
          },
          child: const Text('Get Token'),
        ),
      ),
    );
  }
}
