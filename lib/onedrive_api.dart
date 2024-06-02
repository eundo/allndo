import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OneDriveApi {
  final String clientId = 'e997f8ec-b296-4c0c-9e92-0ce598941979';
  final String clientSecret = 'd17d0274-2b48-4b5c-a3b0-2bf9d721de91';
  final String redirectUri =
      'https://<your_app>.firebaseapp.com/__/auth/handler'; // Firebase 호스팅 URL로 설정
  final String tenantId = 'f0b6221d-a098-496e-a398-13608e6eb8bb';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> authenticate(BuildContext context) async {
    final authorizationEndpoint = Uri.parse(
        'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/authorize');
    final tokenEndpoint = Uri.parse(
        'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token');

    final authUrl = authorizationEndpoint.replace(queryParameters: {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'response_mode': 'query',
      'scope': 'https://graph.microsoft.com/Files.Read.All offline_access',
      'state': '12345',
    });

    if (await canLaunch(authUrl.toString())) {
      await launch(authUrl.toString());

      // Firebase 호스팅 URL로 인증 코드를 받아오는 방법 추가
      final code = await _getAuthCodeFromFirebase();

      if (code != null) {
        final response = await http.post(
          tokenEndpoint,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'client_id': clientId,
            'scope':
                'https://graph.microsoft.com/Files.Read.All offline_access',
            'code': code,
            'redirect_uri': redirectUri,
            'grant_type': 'authorization_code',
            'client_secret': clientSecret,
          },
        );

        if (response.statusCode == 200) {
          final tokenResponse = json.decode(response.body);
          final accessToken = tokenResponse['access_token'];

          await secureStorage.write(
              key: 'onedrive_access_token', value: accessToken);
        } else {
          final errorResponse = json.decode(response.body);
          print('Error: ${errorResponse['error_description']}');
          throw Exception('Failed to exchange code for token');
        }
      } else {
        throw Exception('Failed to authenticate');
      }
    } else {
      throw 'Could not launch URL';
    }
  }

  Future<String?> _getAuthCodeFromFirebase() async {
    // Firebase Functions 또는 다른 방법으로 인증 코드를 받아오는 로직 구현
    // 여기서는 예시로, Firebase Firestore에 저장된 코드를 가져오는 방법을 설명합니다.
    // 실제 구현 시에는 Firebase Functions로 인증 코드 처리 및 저장하는 로직을 구현하세요.
    final response = await http
        .get(Uri.parse('https://<your_app>.firebaseapp.com/getAuthCode'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['code'];
    }
    return null;
  }

  Future<List<String>> searchFiles(String query) async {
    final accessToken = await secureStorage.read(key: 'onedrive_access_token');
    if (accessToken == null) {
      throw Exception('Not authenticated');
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
