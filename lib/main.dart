import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personalexpenses/widgets/chart.dart';
import 'package:personalexpenses/widgets/new_transaction.dart';
import 'package:personalexpenses/widgets/transaction_list.dart';

import 'models/Transcaction.dart';
import 'dart:io';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]); protrait mode

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final List<Transaction> transactions = [

  // ];

  // final amountController = TextEditingController();

  // final titleController = TextEditingController();

  // addTransaction() {
  //   String id = DateTime.now().toString();
  //   String title = titleController.text;
  //   double amount = double.parse(amountController.text);
  //   DateTime date = DateTime.now();

  //   Transaction tx =
  //       Transaction(id: id, title: title, amount: amount, date: date);

  //   setState(() {
  //     transactions.add(tx);
  //   });

  //   print("add");
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      title: 'personal',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                button: TextStyle())),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', amount: 22.22, date: DateTime.now(), title: 'New Shoes'),
    // Transaction(
    //     id: 't2', amount: 69.56, date: DateTime.now(), title: 'New Pant'),
  ];

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(addNewTransaction));
        });
  }

  void addNewTransaction(String title, double amount, DateTime chosenDate) {
    final addTx = Transaction(
        id: DateTime.now().toString(),
        amount: amount,
        title: title,
        date: chosenDate);

    setState(() {
      _userTransactions.add(addTx);
    });
  }

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date!.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void delectTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  bool showChart = false;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = Platform.isIOS
        ? CupertinoNavigationBar() as PreferredSizeWidget
        : AppBar(
            title: Text(
              "Personal Expenses",
            ),
            actions: [
              IconButton(
                  onPressed: () => startAddNewTransaction(context),
                  icon: Icon(Icons.add))
            ],
          );

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7, //safe area pani hunxa ios ma
        child: TransactionList(_recentTransaction, delectTransaction));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: Text('copy garne same iof scaffold in seperate variable'),
          )
        : Scaffold(
            appBar: appBar,
            body: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                //  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isLandscape)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Show chart'),
                        Switch.adaptive(
                          activeColor: Theme.of(context).primaryColorLight,
                          value: showChart,
                          onChanged: (val) {
                            setState(() {
                              showChart = val;
                            });
                          },
                        )
                      ],
                    ),
                  if (!isLandscape)
                    Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.3,
                        child: Chart(_userTransactions)),
                  if (!isLandscape) txListWidget,
                  if (isLandscape)
                    showChart
                        ? Container(
                            height: (MediaQuery.of(context).size.height -
                                    appBar.preferredSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.66,
                            child: Chart(_userTransactions))
                        : txListWidget
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => startAddNewTransaction(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}
