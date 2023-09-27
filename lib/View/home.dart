import 'package:crypto/Model/coinModel.dart';
import 'package:crypto/View/Components/item.dart';
import 'package:crypto/View/Components/item2.dart';
import 'package:crypto/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getCoinMarket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height +30;
    double myWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 253, 225, 112),
                Color(0xffFBC700),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Naslov
     Padding(
  padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: myWidth * 0.02, vertical: myHeight * 0.01), // Prilagodite visinu ovdje
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            'Berza',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), // Prilagodite veličinu i stil teksta
          ),
        ),
      ),
    ],
  ),
),



            //*/ KES LOVA
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    money.toString()!,
                    style: TextStyle(fontSize: 35),
                  ),
                 
                ],
              ),
            ),
            //+%

            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: Row(
                children: [
                  Text(
                    username!,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            //dionice
            SizedBox(
              height: myHeight * 0.02,
            ),
            Container(
              height: myHeight * 0.7,
              width: myWidth,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey.shade300,
                        spreadRadius: 3,
                        offset: Offset(0, 3))
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: myHeight * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dionice',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.02,
                  ),


                  //Poslije podnaslova (Lista dionica)
                 Container(
  height: myHeight * 0.36,
  child: isRefreshing == true
      ? Center(
          child: CircularProgressIndicator(
            color: Color(0xffFBC700),
          ),
        )
      : coinMarket == null || coinMarket!.length == 0
          ? Padding(
              padding: EdgeInsets.all(myHeight * 0.06),
              child: Center(
                child: Text(
                  'API greska.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          : SingleChildScrollView(
              child: ListView.builder(
                itemCount: 15,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Item(
                    item: coinMarket![index],
                  );
                },
              ),
            ),
),




// Recommended
SizedBox(
  height: myHeight * 0.02,
),
Padding(
  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
  child: Row(
    children: [
      Text(
        'Moje dionice',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

// item2-ovi (Recommended)
Expanded(
  child: Padding(
    padding: EdgeInsets.only(left: myWidth * 0.03),
    child: isRefreshing == true
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xffFBC700),
            ),
          )
        : coinMarket == null || coinMarket!.length == 0
            ? Padding(
                padding: EdgeInsets.all(myHeight * 0.06),
                child: Center(
                  child: Text(
                    'API greska.',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: coinMarket!.map((item) {
                    return Item2(
                      item: item,
                    );
                  }).toList(),
                ),
              ),
  ),
),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isRefreshing = true;

  List? coinMarket = [];
  var coinMarketList;
  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
