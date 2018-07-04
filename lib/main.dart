import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import './stores.dart';
import './add_money.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData.dark(),
        home: new MyHomePage(),
        routes: <String, WidgetBuilder>{
          '/add': (BuildContext context) => AddMoneyPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with StoreWatcherMixin<MyHomePage> {
  WalletStore store;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    store = listenToStore(walletStoreToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bal: \$${store.wallet.balance().toStringAsFixed(2)}'),
          actions: <Widget>[
            RaisedButton(
              color: Colors.blueGrey,
              onPressed: () => loadMoneyAction.call(),
              child: Text('Load'),
            ),
            RaisedButton(
              color: Colors.orangeAccent,
              onPressed: () => Navigator.pushNamed(context, '/add'),
              child: Text('+'),
            ),
          ],
        ),
        body: ListView(
          children:
              store.wallet.cash.map((money) => MoneyWidget(money)).toList(),
        ));
  }
}

class MoneyWidget extends StatelessWidget {
  MoneyWidget(this.money);
  final Money money;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(width: 10.0),
      ),
      child: Card(
        elevation: 10.0,
        color: Colors.lightBlue,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              subtitle: Text('x ${money.qty.toString()}'),
              leading: CircleAvatar(
                foregroundColor: Colors.white,
                backgroundColor: Colors.amber,
                child: Text(
                  '\$${money.denomination.toStringAsFixed(1)}',
                  textScaleFactor: 0.75,
                ),
              ),
              title: Text('\$${money.balance.toStringAsFixed(2)}'),
            ))
          ],
        ),
      ),
    );
  }
}
