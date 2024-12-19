import 'package:btc/price_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinData {
  final String apiKey =
      'E507C7F4-B770-4F67-83A1-73536AE6D0B9'; // Replace with your actual CoinAPI API key

  // Fetch data from CoinAPI.io
  Future<Map<String, dynamic>> getCoinData(String selectedCurrency) async {
    Map<String, dynamic> coinRates = {};
    for (var crypto in cryptoList) {
      final response = await http.get(
        Uri.parse(
            'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=$apiKey'),
        // CoinAPI authentication via API Key
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
