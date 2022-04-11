import 'dart:convert';

import 'package:bytebank/database/http/webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final url =
        //Usando ipv4 para o emulador conseguir acessar também.
        Uri.https(baseUrl, "");
    final Response response =
        await client.get(url).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(url as Uri,
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson);

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
