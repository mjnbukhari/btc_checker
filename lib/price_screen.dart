import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Add the list of currencies and crypto currencies here
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

// CoinData class to handle fetching of exchange rates
class CoinData {
  final String apiKey =
      'E507C7F4-B770-4F67-83A1-73536AE6D0B9'; // Replace with your actual CoinAPI API key

  // Fetch data from CoinAPI.io
  Future<Map<String, dynamic>> getCoinData(String selectedCurrency) async {
    Map<String, dynamic> coinRates = {};
    for (var crypto in cryptoList) {
      final response = await http.get(
        Uri.parse(
            'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency'),
        headers: {
          'X-CoinAPI-Key': apiKey
        }, // CoinAPI authentication via API Key
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        coinRates[crypto] =
            data['rate']; // Extracting the 'rate' field from response
      } else {
        throw Exception('Failed to load data');
      }
    }
    return coinRates;
  }
}

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, dynamic> coinData = {'BTC': 0.0, 'ETH': 0.0, 'LTC': 0.0};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateCoinData();
  }

  void updateCoinData() async {
    CoinData coinDataClass = CoinData();
    try {
      Map<String, dynamic> data =
          await coinDataClass.getCoinData(selectedCurrency);
      setState(() {
        coinData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text(
          'Coin Ticker',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        '1 BTC = ${coinData['BTC'] != null ? (coinData['BTC'] as double).toInt() : 0} $selectedCurrency', // Convert to int
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        '1 ETH = ${coinData['ETH'] != null ? (coinData['ETH'] as double).toInt() : 0} $selectedCurrency', // Convert to int
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        '1 LTC = ${coinData['LTC'] != null ? (coinData['LTC'] as double).toInt() : 0} $selectedCurrency', // Convert to int
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 296.0,
          ),
          Expanded(
            child: Container(
              height: 60.0,
              color: Colors.lightBlue,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DropdownButton<String>(
                    value: selectedCurrency,
                    items: currenciesList.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCurrency = newValue!;
                        isLoading =
                            true; // Show loading indicator when switching currency
                        updateCoinData();
                      });
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
