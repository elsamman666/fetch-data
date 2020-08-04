import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'KhabarData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      //remove banner from screen
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> element = [];
  List<KhabarData> khabarDataList = [];
  Map mapResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _FetchKhabarData();
  }

  // method that fetch data

  Future<List<KhabarData>> _FetchKhabarData() async {
    http.Response response = await http.get(
        "http://ninanews.com/NinaNewsService/api/values/GetLastXBreakingNews?rowsToReturn=10&fbclid=IwAR3dsL2EboYKuoOeVIdW7YK0dIcJMfjh8xNie4CkoCxwefNmARffpCa6ivs");

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      element = mapResponse['Data'];
      for (int index = 0; index <= element.length; index++) {
        KhabarData data = new KhabarData(
            element[index]['Khabar_Title'],
            element[index]['Khabar_Details'],
            element[index]['Khabar_Date'],
            element[index]['Pic']);
        setState(() {
          khabarDataList.add(data);
        });
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

//------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          title: Text(
            "Display Data",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xffff2fc3),
        ),
        body: khabarDataList.length == 0
            ? Center(
                child: Text("Loding Data...."),
              )
            : ListView.builder(
                itemCount: khabarDataList.length,
                itemBuilder: (_, index) {
                  return DataCardUI(
                      khabarDataList[index].khabar_title,
                      khabarDataList[index].khabar_details,
                      khabarDataList[index].khabar_date,
                      khabarDataList[index].khabar_pic);
                })
//          }
//          },
//        ),
//      )

        );
  }

  //CardUI method

  Widget DataCardUI(khabar_title, khabar_details, khabar_date, khabar_pic) {
    return Card(
        elevation: 7,
        margin: EdgeInsets.all(15),
        color: Color(0xffff2fc3),
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.all(1.5),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Image.network(
                      khabar_pic,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Text(
                            khabar_title,
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 10)),
                          Text(khabar_details)
                        ],
                      ))
                ],
              ),
              Container(
                width: double.infinity,
                child: Text(
                  khabar_date,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ));
  }
  //----------------------------------------------------------------------------------------------------------
}
