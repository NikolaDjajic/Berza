import 'package:crypto/Model/coinModel.dart';
import 'package:crypto/View/Baza/Dionica.dart';
import 'package:crypto/View/Baza/dataBaseHelper.dart';
import 'package:crypto/View/Components/item2.dart';
import 'package:flutter/material.dart';
import 'package:crypto/View/dionicaKupljena.dart'; // Import the DionicaDetailPage
import 'package:crypto/View/home.dart';
import 'package:http/http.dart' as http;

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
        title: Text('Dionice'),
      ),
      body: dionice == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: dionice!.length,
              itemBuilder: (context, index) {
                final dionica = dionice![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DionicaDetailPage(
                          dionica: dionica,
                        ),
                      ),
                    );
                  },
                  child: Item2(
                    item: dionica,
                    cijenaTrenutna:getCijenaBySimbol(dionica.simbol) // Pass the selected Dionica item
 // Pass the Dionica item to Item2
                  ),
                );
              },
            ),
    );
  }


 double getCijenaBySimbol(String simbol) {
  if (coinMarketList == null) {
    return 0; // Lista je null, nemoguće pronaći
  }

  for (CoinModel coinModel in coinMarketList) {
    if (coinModel.symbol == simbol) {
      return coinModel.currentPrice; // Pronađen je odgovarajući CoinModel
    }
  }

  return 0; // Ime nije pronađeno u listi
}

//Dialog za prodaju

 
}


