import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _name = '';
  List<dynamic> _countryList = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.nationalize.io/?name=nathaniel'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(response.body);
      setState(() {
        _name = jsonResponse['name'];
        _countryList = List.from(jsonResponse['country']).map((c) => {'country_id': c['country_id'], 'probability': c['probability']}).toList();
      });
    } else {
      throw Exception('Error loading API');
    }
  }



  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('API presenting in ListView'),
        ),
        body: Column(
          children: [
            Text(
              _name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _countryList.length,
                itemBuilder: (BuildContext context, int index) {
                  final country = _countryList[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(country['country_id']),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Probability: ${country['probability']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}
