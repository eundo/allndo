import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'onedrive_api.dart';

class OneDriveAuth {
  final OneDriveApi api;

  OneDriveAuth(this.api);

  Future<void> authenticate() async {
    final authorizationEndpoint = Uri.parse(
        'https://login.microsoftonline.com/${api.tenantId}/oauth2/v2.0/authorize');
    final tokenEndpoint = Uri.parse(
        'https://login.microsoftonline.com/${api.tenantId}/oauth2/v2.0/token');
    final redirectUri = Uri.parse(api.redirectUri);

    // Generate a URL for the user to log in
    final authUrl = authorizationEndpoint.replace(queryParameters: {
      'client_id': api.clientId,
      'response_type': 'code',
      'redirect_uri': api.redirectUri,
      'response_mode': 'query',
      'scope': 'https://graph.microsoft.com/Files.Read.All offline_access',
      'state': '12345', // Any random string
    });

    // Open the login URL
    if (await canLaunch(authUrl.toString())) {
      await launch(authUrl.toString());

      // Create an HttpServer to listen for the redirect
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
      await for (HttpRequest request in server) {
        final code = request.uri.queryParameters['code'];
        if (code != null) {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.html
            ..write('Authentication successful! You can close this window.');
          await request.response.close();
          server.close();

          // Exchange the authorization code for an access token
          final response = await http.post(
            tokenEndpoint,
            body: {
              'client_id': api.clientId,
              'scope':
                  'https://graph.microsoft.com/Files.Read.All offline_access',
              'code': code,
              'redirect_uri': api.redirectUri,
              'grant_type': 'authorization_code',
              'client_secret': api.clientSecret,
            },
          );

          final tokenResponse = json.decode(response.body);
          final accessToken = tokenResponse['access_token'];

          // Save the access token securely
          await api.secureStorage
              .write(key: 'onedrive_access_token', value: accessToken);
          break;
        }
      }
    } else {
      throw 'Could not launch URL';
    }
  }
}
