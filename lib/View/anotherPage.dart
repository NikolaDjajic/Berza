import 'package:flutter/material.dart';
import 'package:crypto/View/Baza/Dionica.dart';
import 'package:crypto/View/Baza/dataBaseHelper.dart';



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
                return ListTile(
                  title: Text(dionica.ime),
                  subtitle: Text('Simbol: ${dionica.simbol}'),
                  // Dodajte više informacija ili akcija prema potrebi
                );
              },
            ),
    );
  }
}
