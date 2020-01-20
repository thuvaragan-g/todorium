import 'package:flutter/material.dart';
import 'package:testrs/service/todoDto.dart';

class Archived extends StatefulWidget {
  @override
  _ArchivedState createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
    String newTaskErrorMsg = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic> items = [];
  bool isLoaded = false;

  List<bool> isSelected;

   @override
  void initState() {
    isSelected = [true, false, false];

    TodoDto().getArchived().then((val) {
      // print(val[0]);
      setState(() {
        items = val;
        isLoaded = true;
        //print(items[0]['name']);
      });
    });

    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Archived',
          style: TextStyle(
              fontFamily: 'Product Sans', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: isLoaded
          ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index]["name"];
                return Dismissible(
                  direction: DismissDirection.startToEnd,
                  key: Key(item),

                  onDismissed: (direction) {
                    setState(() {
                      TodoDto().unArchive(items[index]["id"]).then((value) {
                        // print('This responce : ' + value);
                      });
                      items.removeAt(index);
                    });

                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Task Unarchived!"),
                      ),
                    );
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(
                    margin: EdgeInsets.only(right: 10.0, left: 10, top: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFF005005),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //color: Colors.red,
                    child: Icon(
                      Icons.unarchive,
                      color: Colors.white,
                      size: 20,
                    ),
                    alignment: Alignment(-0.9, 0.0),
                  ),
                  child: Container(
                      width: (MediaQuery.of(context).size.width),
                      height: 60,
                      padding:
                          EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                      margin: EdgeInsets.only(right: 10.0, left: 10, top: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        border: Border.all(color: Color(0xFFe0e0e0)),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 8,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                        items[index]["name"],
                                        style: TextStyle(
                                          // color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ])),
                          Expanded(
                              flex: 2,
                              child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 7),
                                        child: Icon(
                                          Icons.stars,
                                          color:
                                              items[index]["priority"] == 'High'
                                                  ? Colors.red
                                                  : items[index]["priority"] ==
                                                          'Low'
                                                      ? Colors.green
                                                      : Colors.yellow[800],
                                        )),
                                    Container(
                                      //padding: EdgeInsets.only(top: 15, bottom: 10) ,
                                      child: Text(
                                        items[index]["date"],
                                        style: TextStyle(
                                            // 0color: Colors.white,
                                             fontSize: 11),
                                      ),
                                    )
                                  ])),
                          Expanded(
                              flex: 1,
                              child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            // print("object");
                                          },
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                          ),
                                        ))
                                  ])),
                          // Icon(Icons.check_circle, color: Colors.white,),
                          // Text(items[index],
                          // style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),),
                        ],
                      )),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      backgroundColor: Color.fromRGBO(229, 229, 229, 1.0),
    );
  }
}