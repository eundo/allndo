import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('yourFunctionName');

  Future<void> callFunction() async {
    final result = await callable.call(<String, dynamic>{
      'yourParameter': 'value',
    });

    print(result.data);
  }
}