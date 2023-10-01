import 'package:crypto/Model/coinModel.dart';
import 'package:crypto/View/Baza/Dionica.dart';
import 'package:crypto/View/Baza/dataBaseHelper.dart';
import 'package:crypto/View/Components/item2.dart';
import 'package:flutter/material.dart';
import 'package:crypto/View/home.dart';

class AnotherPage extends StatefulWidget {
  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  List<Dionica>? dionice;

  @override
  void initState() {
    super.initState();
    loadDionice();
  }

  Future<void> loadDionice() async {
    final loadedDionice = await DatabaseHelper.getAllDionice();
    setState(() {
      dionice = loadedDionice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Moje dionice'),
  backgroundColor: Color(0xffFBC700), 
      ),

      body: dionice == null
    ? Center(
        child: CircularProgressIndicator(),
      )
    : dionice!.isEmpty
        ? Center(
            child: Text('Niste kupili nijednu dionicu do sada'),
          )
        : ListView.builder(
            itemCount: dionice!.length,
            itemBuilder: (context, index) {
              final dionica = dionice![index];
              return GestureDetector(
                onTap: () {},
                child: Item2(
                    item: dionica,
                    cijenaTrenutna: getCijenaBySimbol(dionica.simbol)),
              );
            },
          ),

    );
  }

  double getCijenaBySimbol(String simbol) {
    if (coinMarketList == null) {
      return 0;
    }
    for (CoinModel coinModel in coinMarketList) {
      if (coinModel.symbol == simbol) {
        return coinModel.currentPrice;
      }
    }
    return 0; // Ime nije pronađeno u listi
  }
}
