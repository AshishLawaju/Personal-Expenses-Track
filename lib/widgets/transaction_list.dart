import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

import '../models/Transcaction.dart';

class TransactionList extends StatelessWidget {
  List<Transaction> transactions;
  Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, contr) {
            return Column(
              children: [
                Text(
                  "No Transaction add yet!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Container(
                  height: contr.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/image/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : Container(
            height: 300,
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(
                      transactions[index].title.toString(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date!)),
                    trailing: MediaQuery.of(context).size.width > 660
                        ? TextButton.icon(
                            onPressed: () {
                              deleteTx(transactions[index].id);
                            },
                            label: Text('Delete'),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Theme.of(context).errorColor,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              deleteTx(transactions[index].id);
                            },
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor),
                  ),
                );
                // return Card(
                //     child: Row(
                //   children: [
                //     Container(
                //         margin: EdgeInsets.symmetric(
                //             vertical: 10, horizontal: 15),
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //                 color: Theme.of(context).primaryColorLight,
                //                 width: 2)),
                //         padding: EdgeInsets.all(7),
                //         child: Text(
                //           '\$${transactions[index].amount?.toStringAsFixed(2)}',
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 18,
                //               color: Theme.of(context).primaryColorDark),
                //         )),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           transactions[index].title.toString(),
                //           style: Theme.of(context).textTheme.titleLarge,
                //         ),
                //         Text(
                //           DateFormat.yMMMd()
                //               .format(transactions[index].date!),
                //           style: TextStyle(color: Colors.grey),
                //         )
                //       ],
                //     ),
                //   ],
                // ));
              },
            ),
          );
  }
}
