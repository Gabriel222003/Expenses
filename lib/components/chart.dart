import 'package:expenses/components/char_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart(this.recentTransaction,{super.key});

  final List<Transaction> recentTransaction;

  List<Map<String, Object>> get groupedTransaction{
    return List.generate(7, (index){
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum= 0.0;

      for(var i = 0; i < recentTransaction.length; i++){
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;


        if(sameDay && sameMonth && sameYear){
          totalSum += recentTransaction[i].value;
        }

      }

      return{'day':DateFormat.E().format(weekDay)[0],'value': totalSum};
    }).reversed.toList();
  }

  double get _weekTotalValue{
    return groupedTransaction.fold(0.0,(sum, tr){
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    groupedTransaction;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransaction.map((tr){
            return Flexible(
              fit: FlexFit.tight,
              child: CharBar(
                label: tr['day'] as String,
                value: tr['value'] as double,
                percentage: _weekTotalValue == 0? 0 : (tr['value'] as double) / _weekTotalValue,
                ),
            );
          }).toList(),
        ),
      ),
    );
  }
}