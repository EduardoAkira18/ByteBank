import 'dart:convert';

import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
);

const String baseUrl = "http://192.168.20.103:8080/transactions";

Future<List<Transaction>> findAll() async {
  final url =
      //Usando ipv4 para o emulador conseguir acessar também.
      Uri.https(baseUrl, "");

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

// Post
Future<Transaction> save(Transaction transaction) async {
  //Decode = pegar la do json e transformar o objeto
  //Encode = transformar o objeto para json

  final Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  };

  final String transactionJson = jsonEncode(transactionMap);

  final url = Uri.https(baseUrl, "");

  final Response response = await client.post(
    url,
    headers: {'Content-type': 'application/json', 'password': '1000'},
    body: transactionJson,
  );

  Map<String, dynamic> json = jsonDecode(response.body);
  final Map<String, dynamic> contactJson = json["contact"];
  return Transaction(
    json["value"],
    Contact(
      0,
      json["name"],
      json["accountNumber"],
    ),
  );
}
