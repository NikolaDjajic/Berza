import 'dart:convert';

import 'package:crypto/View/navBar.dart';
import 'package:crypto/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Model/chartModel.dart';
import 'package:crypto/View/Baza/Dionica.dart';
import 'package:crypto/View/Baza/dataBaseHelper.dart';

class SelectCoin extends StatefulWidget {
  var selectItem;

  SelectCoin({this.selectItem});

  @override
  State<SelectCoin> createState() => _SelectCoinState();
}

class _SelectCoinState extends State<SelectCoin> {
  late TrackballBehavior trackballBehavior;
  final TextEditingController _textController = TextEditingController();
  int numberOfShares = 0;

  @override
  void initState() {
    getChart();
    trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: myWidth * 0.05, vertical: myHeight * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          height: myHeight * 0.08,
                          child: Image.network(widget.selectItem.image)),
                      SizedBox(
                        width: myWidth * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectItem.id,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: myHeight * 0.01,
                          ),
                          Text(
                            widget.selectItem.symbol,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$' + widget.selectItem.currentPrice.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: myHeight * 0.01,
                      ),
                      Text(
                        widget.selectItem.marketCapChangePercentage24H
                                .toString() +
                            '%',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: widget.selectItem
                                        .marketCapChangePercentage24H >=
                                    0
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: myWidth * 0.05, vertical: myHeight * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Low',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: myHeight * 0.01,
                          ),
                          Text(
                            '\$' + widget.selectItem.low24H.toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'High',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: myHeight * 0.01,
                          ),
                          Text(
                            '\$' + widget.selectItem.high24H.toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Vol',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: myHeight * 0.01,
                          ),
                          Text(
                            '\$' +
                                widget.selectItem.totalVolume.toString() +
                                'M',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: myHeight * 0.015,
                ),
                Container(
                  height: myHeight * 0.4,
                  width: myWidth,
                  // color: Colors.amber,
                  child: isRefresh == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffFBC700),
                          ),
                        )
                      : itemChart == null
                          ? Padding(
                              padding: EdgeInsets.all(myHeight * 0.06),
                              child: Center(
                                child: Text(
                                  'API greska.',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            )
                          : SfCartesianChart(
                              trackballBehavior: trackballBehavior,
                              zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true, zoomMode: ZoomMode.x),
                              series: <CandleSeries>[
                                CandleSeries<ChartModel, int>(
                                    enableSolidCandles: true,
                                    enableTooltip: true,
                                    bullColor: Colors.green,
                                    bearColor: Colors.red,
                                    dataSource: itemChart!,
                                    xValueMapper: (ChartModel sales, _) =>
                                        sales.time,
                                    lowValueMapper: (ChartModel sales, _) =>
                                        sales.low,
                                    highValueMapper: (ChartModel sales, _) =>
                                        sales.high,
                                    openValueMapper: (ChartModel sales, _) =>
                                        sales.open,
                                    closeValueMapper: (ChartModel sales, _) =>
                                        sales.close,
                                    animationDuration: 55)
                              ],
                            ),
                ),
                SizedBox(
                  height: myHeight * 0.01,
                ),
                Center(
                  child: Container(
                    height: myHeight * 0.03 + 10,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: text.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: myWidth * 0.02),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                textBool = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                                textBool[index] = true;
                              });
                              setDays(text[index]);
                              getChart();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: myWidth * 0.03,
                                  vertical: myHeight * 0.005),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: textBool[index] == true
                                    ? Color(0xffFBC700).withOpacity(0.3)
                                    : Colors.transparent,
                              ),
                              child: Text(
                                text[index],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: myHeight * 0.04,
                ),
         
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          numberOfShares--;
                          if (numberOfShares < 0) {
                            numberOfShares = 0;
                          }
                          _textController.text = numberOfShares.toString();
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Container(
                      width: 80,
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            numberOfShares = int.tryParse(value) ?? 0;
                          });
                        },
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
                        setState(() {
                          numberOfShares++;
                          _textController.text = numberOfShares.toString();
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                SizedBox(height: 20), 
                Text(
                    'Cijena: \$${(widget.selectItem.currentPrice * numberOfShares).toStringAsFixed(2)}'),
              ],
            )),
            Container(
              height: myHeight * 0.1,
              width: myWidth,
              // color: Colors.amber,
              child: Column(
                children: [
                  Divider(),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: myWidth * 0.05,
                      ),
                      Expanded(
                          flex: 5,
                          child: ElevatedButton(
                            // ---------------------------------------------------------------------------------------
                            onPressed: () async {
                              if ((widget.selectItem.currentPrice *
                                      numberOfShares) >
                                  money) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Nedovoljno novca!'),
                                      content: Text('Nemate dovoljno novca.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // Zatvaranje dijaloga
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (numberOfShares > 0) {
                                final dionicaId = widget.selectItem.id;
                                final kolicina = numberOfShares;
                                final slika = widget.selectItem.image;
                                final simbol = widget.selectItem.symbol;
                                final ime = widget.selectItem.name;
                                final cijena =
                                    widget.selectItem.currentPrice * kolicina;
                                bool rez = false;

                                Dionica? dio1 =
                                    await DatabaseHelper.getDionicaBySymbol(
                                        simbol);

                                if (dio1 != null) {
                                  var cijena1 = (dio1!.cijena)! + cijena;
                                  var kolicina1 = (dio1!.kolicina) + kolicina;

                                  final Dionica dio = Dionica(
                                      id: dio1.id,
                                      cijena: cijena1,
                                      kolicina: kolicina1,
                                      simbol: simbol,
                                      ime: ime,
                                      slika: slika,
                                      dionicaId: dionicaId);
                                  await DatabaseHelper.updateDionica(dio);

                                  double kes = money! -
                                      (widget.selectItem.currentPrice *
                                          numberOfShares);
                                  money = kes;
                                  updateMoney(money!);
                                } else {
                                  final Dionica dio = Dionica(
                                      cijena: cijena,
                                      simbol: simbol,
                                      ime: ime,
                                      slika: slika,
                                      dionicaId: dionicaId,
                                      kolicina: kolicina);
                                  await DatabaseHelper.addDionica(dio);

                                  double kes = money! -
                                      (widget.selectItem.currentPrice *
                                          numberOfShares);
                                  money = kes;
                                  updateMoney(money!);
                                }

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Kupili ste dionicu!'),
                                      content: Text(
                                          'Kupili $money ste $kolicina, $ime dionice  po cijeni $cijena.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // Zatvaranje dijaloga
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => NavBar(),
                                ));
                              }
                            },

                            // ---------------------------------------------------------------------------------------
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: myHeight * 0.015),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              primary: Color(0xffFBC700),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: myHeight * 0.02,
                                ),
                                Text(
                                  'Kupi',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          )),

                      SizedBox(
                        width: myWidth * 0.05,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  List<String> text = ['D', 'W', 'M', '3M', '6M', 'Y'];
  List<bool> textBool = [false, false, true, false, false, false];

  int days = 30;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 90;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }

  List<ChartModel>? itemChart;

  bool isRefresh = true;

  Future<void> getChart() async {
    String url = 'https://api.coingecko.com/api/v3/coins/' +
        widget.selectItem.id +
        '/ohlc?vs_currency=usd&days=' +
        days.toString();

    setState(() {
      isRefresh = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isRefresh = false;
    });
    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);
      List<ChartModel> modelList =
          x.map((e) => ChartModel.fromJson(e)).toList();
      setState(() {
        itemChart = modelList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
