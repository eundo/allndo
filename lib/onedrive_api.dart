import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OneDriveApi {
  final String clientId = 'YOUR_ONEDRIVE_CLIENT_ID';
  final String clientSecret = 'YOUR_ONEDRIVE_CLIENT_SECRET';
  final String redirectUri = 'YOUR_ONEDRIVE_REDIRECT_URI';
  final String tenantId = 'YOUR_TENANT_ID';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> authenticate() async {
    // Add authentication logic using MSAL
  }

  Future<List<String>> searchFiles(String query) async {
    // Add search logic using OneDrive API
    final accessToken = await secureStorage.read(key: 'onedrive_access_token');
    if (accessToken == null) {
      await authenticate();
    }

    final response = await http.get(
      Uri.parse(
          'https://graph.microsoft.com/v1.0/me/drive/root/search(q=\'$query\')'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<String> fileNames = [];
      for (var item in data['value']) {
        fileNames.add(item['name']);
      }
      return fileNames;
    } else {
      throw Exception('Failed to search files in OneDrive');
    }
  }
}
