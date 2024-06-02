import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'onedrive_api.dart';
import 'onedrive_auth.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  late OneDriveApi oneDriveApi;
  late OneDriveAuth oneDriveAuth;
  String _results = '';

  @override
  void initState() {
    super.initState();
    oneDriveApi = OneDriveApi();
    oneDriveAuth = OneDriveAuth(oneDriveApi);
    oneDriveAuth.authenticate();
  }

  Future<void> _search(String query) async {
    List<String> results = [];

    List<String> onedriveResults = await oneDriveApi.searchFiles(query);
    results.addAll(onedriveResults);

    setState(() {
      _results = results.join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Storage Search'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter search query'),
            onSubmitted: (value) {
              _search(value);
            },
          ),
          Expanded(
            child: Center(
              child: Text(_results),
            ),
          ),
        ],
      ),
    );
  }
}
