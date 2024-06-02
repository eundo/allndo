import 'package:flutter/material.dart';
import 'onedrive_api.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late OneDriveApi oneDriveApi;

  @override
  void initState() {
    super.initState();
    oneDriveApi = OneDriveApi();
  }

  Future<void> _connectOneDrive() async {
    try {
      await oneDriveApi.authenticate(context);
      setState(() {
        // Update the UI or state as needed
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _connectOneDrive,
          child: Text('Connect to OneDrive'),
        ),
      ),
    );
  }
}
