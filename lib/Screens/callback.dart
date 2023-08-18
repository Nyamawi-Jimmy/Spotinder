import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CallbackPage extends StatefulWidget {
  @override
  _CallbackPageState createState() => _CallbackPageState();
}

class _CallbackPageState extends State<CallbackPage> {
  final String redirectUri = 'https://matchr-production.up.railway.app/callback/';
  final String clientId = '0ea2d1861e09419587f9e653805c6ada';
  final String clientSecret = '1f4ad852d088437599bce751fecc3c42';

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (url.startsWith(redirectUri)) {
        _handleRedirectUrl(url);
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text('Spotify Authentication'),
      ),
      url: 'https://accounts.spotify.com/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code',
      hidden: true,
    );
  }

  void _handleRedirectUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri != null) {
      if (uri.toString().startsWith(redirectUri)) {
        final String code = uri.queryParameters['code'] ?? '';

        _exchangeCodeForTokens(code);
      } else if (uri.toString().startsWith('$redirectUri?error=')) {
        final String error = uri.queryParameters['error'] ?? '';
        print('Spotify authentication failed: $error');
      }
    }

    Navigator.of(context).pop();
  }


  void _exchangeCodeForTokens(String code) async {
    final String tokenEndpoint = 'https://accounts.spotify.com/api/token';
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));

    final Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final Map<String, String> body = {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': redirectUri,
    };

    final response = await Dio().post(tokenEndpoint, data: body, options: Options(headers: headers));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data;
      final String accessToken = responseData['access_token'];
      final String refreshToken = responseData['refresh_token'];

      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');
    } else {
      print('Failed to exchange code for tokens. Status code: ${response.statusCode}');
    }
  }
}