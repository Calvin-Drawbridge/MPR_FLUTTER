import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'medicine.dart';
import 'listmedicine.dart';
import 'database_page.dart';

Future<List<Medicine>> fetchPosts(http.Client client, String query) async {
  final String MPR_BASE_URL = "https://mpr.code4sa.org/api/v2/search?q=";
  final String MPR_TEST_QUERY = MPR_BASE_URL + query;
  // final response = await client.get('https://jsonplaceholder.typicode.com/posts');
  final response = await client.get(MPR_TEST_QUERY);

  return compute(parsePosts, response.body);
}

List<Medicine> parsePosts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Medicine>((json) => Medicine.fromJson(json)).toList();
}
int currentPage = 0;

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: MyStatefulWidget(),
      ),

    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController _controller;
  String _searchQuery = '';
  bool _emptySearchView = true;
  bool _showLoading = false;


  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateMedicine(String query){
    setState(() {
      _searchQuery = query;
      _emptySearchView = false;
      _showLoading = true;
    });
  }

  void navigationBarTap(int index){
    setState(() {
      currentPage = index;
    });
    if (index == 1){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DatabaseRoute()));
    }
  }

  Widget _buildHomePage() => CustomScrollView(
    slivers: <Widget>[
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            onSubmitted: (String value) async {
              updateMedicine(value);
            },
          ),
        ),
      ),
      SliverFillRemaining(
        hasScrollBody: true,
        child:
        Container(
          height: 480.0,
          child: FutureBuilder<List<Medicine>>(
            future: fetchPosts(http.Client(), _searchQuery),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              if (_emptySearchView == false){
                return snapshot.hasData
                    ? ListViewPosts(medicines: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              }
              if (_showLoading){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                child: Text(
                  'Enter a medication name to search.',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );

  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _buildHomePage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.table_rows_rounded),
              label: 'Medication'),
        ],
        currentIndex: currentPage,
        onTap: navigationBarTap,
        backgroundColor: Colors.black87,
      ),
    );
  }
}
