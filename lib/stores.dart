import 'package:flutter_flux/flutter_flux.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter/services.dart'
    show rootBundle; // load json from assets dir

import 'dart:async';
import 'dart:convert';
import 'dart:collection';

class Wallet {
  final LinkedList<MoneyLinkedListEntry> _money =
      LinkedList<MoneyLinkedListEntry>();

  void clear() => _money.clear();

  void add(Money m) => _money.add(MoneyLinkedListEntry(m));

  void addAll(List<Money> monies) => monies.forEach((m) => this.add(m));

  List get cash => _money.map((m) => m.value).toList();
}

class MoneyLinkedListEntry<Money>
    extends LinkedListEntry<MoneyLinkedListEntry> {
  Money value;
  MoneyLinkedListEntry(this.value);
}

class Money {
  final double denomination;
  final int qty;

  Money({this.denomination, this.qty});

  Money.fromJson(Map json)
      : denomination = double.parse(json['denomination']),
        qty = json['qty'];

  double get balance => this.denomination * qty;
}

class BankAPI {
  Future<List<Money>> getMoney() async {
    String jsonString = await rootBundle.loadString('assets/bank_account.json');

    MockClient client = MockClient((request) async {
      return http.Response(jsonString, 200);
    });

    http.Response resp = await client.get('/money');
    List data = json.decode(resp.body);
    return data.map((e) => Money.fromJson(e)).toList();
  }
}

class WalletStore extends Store {
  final BankAPI bank = BankAPI();

  final _wallet = Wallet();

  WalletStore() {
    triggerOnAction(loadMoneyAction, (nothing) async {
      print('action trigger called');
      _wallet.clear();

      List<Money> bankBalance = await bank.getMoney();
      _wallet.addAll(bankBalance);
    });
  }

  Wallet get wallet => _wallet;
}

final Action loadMoneyAction = Action();
final StoreToken walletStoreToken = StoreToken(WalletStore());
