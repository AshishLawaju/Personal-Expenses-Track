import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  Function add;
  NewTransaction(this.add);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }

    widget.add(titleController.text, double.parse(amountController.text),
        selectedDate);

    Navigator.of(context).pop();
  }

  DateTime? selectedDate;
  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020, 3),
            lastDate: DateTime.now())
        .then((pickdate) {
      if (pickdate == null) {
        return;
      }

      setState(() {
        selectedDate = pickdate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
                controller: titleController,
                onSubmitted: (_) =>
                    submitData(), //tyo tick wala button from  keyborad ko lagi
                decoration: InputDecoration(
                  label: Text("Title"),
                )),
            TextField(
              controller: amountController,
              onSubmitted: (_) => submitData(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(label: Text("Amount")),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(selectedDate == null
                      ? 'No date chosen'
                      : DateFormat.yMd().format(selectedDate!).toString()),
                ),
                TextButton(
                    onPressed: presentDatePicker,
                    child: Text(
                      'choose date',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
              ],
            ),
            SizedBox(
              height: 8,
            ),
            FilledButton(
              onPressed: submitData,
              child: Text("Add Transaction"),
            )
          ],
        ),
      ),
    );
  }
}
