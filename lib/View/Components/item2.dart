import 'package:crypto/View/Baza/Dionica.dart';
import 'package:crypto/View/Baza/dataBaseHelper.dart';
import 'package:crypto/View/navBar.dart';
import 'package:crypto/main.dart';
import 'package:flutter/material.dart';

class Item2 extends StatefulWidget {
  Dionica item;
  var cijenaTrenutna;

  Item2({required this.item, required this.cijenaTrenutna});

  @override
  _Item2State createState() => _Item2State();
}

class _Item2State extends State<Item2> {
  TextEditingController _quantityController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height - 10;
    double myWidth = MediaQuery.of(context).size.width * 0.6;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: myWidth * 0.03,
        vertical: myHeight * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          _showSaleDialog(context);
        },
        child: Container(
          padding: EdgeInsets.only(
            left: myWidth * 0.03,
            right: myWidth * 0.06,
            top: myHeight * 0.02,
            bottom: myHeight * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Row: Image and Item Name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: myHeight * 0.035,
                    child: Image.network(widget.item.slika),
                  ),
                  Text(
                    widget.item.ime.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: myHeight * 0.01),

              // Second Row: Item Price and Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kupljena cijena: ${(widget.item.cijena / widget.item.kolicina).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Količina: ${widget.item.kolicina}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: myHeight * 0.01),

              // Third Row: Current Price
              Row(
                children: [
                  Text(
                    'Trenutna Cijena: \$${widget.cijenaTrenutna.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: widget.cijenaTrenutna >
                              widget.item.cijena / widget.item.kolicina
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//-----------------------------------------------------Dialog za prodaju-----------------------------------------

  void _showSaleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prodaja dionice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      int currentQuantity =
                          int.tryParse(_quantityController.text) ?? 0;
                      if (currentQuantity > 0) {
                        setState(() {
                          currentQuantity--;
                          _quantityController.text = currentQuantity.toString();
                        });
                      }
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Container(
                    width: 80,
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        labelText: '0',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      int currentQuantity =
                          int.tryParse(_quantityController.text) ?? 0;
                      setState(() {
                        currentQuantity++;
                        _quantityController.text = currentQuantity.toString();
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),

               SizedBox(height: 10),
              Text(
                'Prodajte ${widget.item.ime} po cijeni od ${widget.cijenaTrenutna}',
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Otkaži'),
            ),

            //--------------------------------- Prodaj dugme -----------------------------------
            TextButton(
              onPressed: () async {
                int selectedQuantity =
                    int.tryParse(_quantityController.text) ?? 0;

                if (selectedQuantity < widget.item.kolicina) {
                  var kolicina1 = widget.item.kolicina - selectedQuantity;
                  var cijena1 = widget.item.cijena -
                      (widget.cijenaTrenutna * selectedQuantity);
                  final Dionica dio = Dionica(
                      id: widget.item.id,
                      cijena: cijena1,
                      kolicina: kolicina1,
                      simbol: widget.item.simbol,
                      ime: widget.item.ime,
                      slika: widget.item.slika,
                      dionicaId: widget.item.dionicaId);
                  await DatabaseHelper.updateDionica(dio);
                  double kes =
                      money! + (widget.cijenaTrenutna * selectedQuantity);
                  money = kes;
                  updateMoney(money!);

                  Navigator.of(context).pop();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavBar()),
                  );
                } else {
                  double kes =
                      money! + (widget.cijenaTrenutna * selectedQuantity);
                  money = kes;
                  updateMoney(money!);
                  final Dionica dio = Dionica(
                      id: widget.item.id,
                      cijena: widget.item.cijena,
                      kolicina: widget.item.kolicina,
                      simbol: widget.item.simbol,
                      ime: widget.item.ime,
                      slika: widget.item.slika,
                      dionicaId: widget.item.dionicaId);
                  await DatabaseHelper.deleteDionica(dio);

                  Navigator.of(context).pop();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavBar()),
                  );
                }
              },
              child: Text('Prodaj'),
            ),
          ],
        );
      },
    );
  }
}
