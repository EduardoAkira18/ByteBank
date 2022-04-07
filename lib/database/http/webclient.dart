import 'dart:convert';

import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print("Request");
    print("url: ${data.baseUrl}");
    print("headers: ${data.headers}");
    print("body: ${data.body}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print("Reponse");
    print("status code: ${data.statusCode}");
    print("headers: ${data.headers}");
    print("body: ${data.body}");
    return data;
  }
}

Future<List<Transaction>> findAll() async {
  Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );
  final url =
      //Usando ipv4 para o emulador conseguir acessar também.
      Uri.https("http://192.168.20.103:8080/transactions", "transactions");

  final Response response = await client.get(url).timeout(
        Duration(seconds: 5),
      );

  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = [];
  for (Map<String, dynamic> transactionJson in decodedJson) {
    final Map<String, dynamic> contactJson = transactionJson["contact"];
    final Transaction transaction = Transaction(
      transactionJson["value"],
      Contact(0, transactionJson["name"], transactionJson["accountNumber"]),
    );
    transactions.add(transaction);
  }
  return transactions;
}
