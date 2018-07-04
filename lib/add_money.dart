import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import './stores.dart';

class AddMoneyPage extends StatefulWidget {
  AddMoneyPage({Key key}) : super(key: key);

  @override
  AddMoneyPageState createState() => AddMoneyPageState();
}

class AddMoneyPageState extends State<AddMoneyPage>
    with StoreWatcherMixin<AddMoneyPage> {
  WalletStore store;

  final _formKey = GlobalKey<FormState>();
  String _denomination;
  String _qty;

  @override
  void initState() {
    super.initState();
    store = listenToStore(walletStoreToken);
  }

  void _onSubmit(BuildContext context) {
    _formKey.currentState.save();
    
    addMoneyAction.call(
        Money(denomination: double.parse(_denomination), qty: int.parse(_qty)));

    _denomination = _qty = null;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Money'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              // controller: _denominationFieldController,
              initialValue: 5.toString(),

              onSaved: (val) => _denomination = val,
              decoration: InputDecoration(
                // border: InputBorder.none,
                hintText: 'Denomination',
              ),
            ),
            TextFormField(
              // controller: _qtyFieldController,
              initialValue: 1.toString(),
              onSaved: (val) => _qty = val,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Qty',
              ),
            ),
            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () => _onSubmit(context),
              child: Text('Save Now'),
            ),
          ],
        ),
      ),
    );
  }
}
