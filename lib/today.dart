import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

import 'service/todoDto.dart';

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {

  String newTaskErrorMsg = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

  var myFormat = DateFormat('yyyy-MM-d');

  TextEditingController newTask = new TextEditingController();
  String priority = 'High';
  String taskDate;

  List<dynamic> items = [];
  bool isLoaded = false;

  List<bool> isSelected;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    isSelected = [true, false, false];
    taskDate = myFormat.format(DateTime.now());

    TodoDto().getToday().then((val) {
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
          'Today',
          style: TextStyle(
              fontFamily: 'Product Sans', fontWeight: FontWeight.bold),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.filter_list,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // do something
        //     },
        //   )
        // ],
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
                      TodoDto().updateDone(items[index]["id"]).then((value) {
                        // print('This responce : ' + value);
                      });
                      items.removeAt(index);
                    });

                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Task Archived"),
                      ),
                    );
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(
                    margin: EdgeInsets.only(right: 10.0, left: 10, top: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFF8b0032),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //color: Colors.red,
                    child: Icon(
                      Icons.delete_sweep,
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
                                            Vibration.vibrate(duration: 50);
                                            // _edittask(int.parse(items[index]));
                                            _edittask(index);
                                            // print("object");
                                          },
                                          child: Icon(
                                            Icons.more_vert,
                                            // color: Colors.white,
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

  void _edittask(edittaskID,) {
    String editPriority = items[edittaskID]["priority"];
    selectedDate = DateTime.parse(items[edittaskID]["date"]);
    isSelected = [false, false, false];
    editPriority == 'High'? isSelected[0]=true: editPriority == 'Medium'? isSelected[1]=true:isSelected[2]=true;
    newTask.text = items[edittaskID]["name"];
    priority = editPriority;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).viewInsets.bottom == 0.0
                  ? (MediaQuery.of(context).size.height) / 3 + 10
                  : (MediaQuery.of(context).size.width),
              color: Color(0xFF737373),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Icon(
                              Icons.check_box,
                              color: Colors.blueAccent,
                            )),
                        Expanded(
                          flex: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 285,
                                child: TextFormField(
                                  controller: newTask,
                                  maxLength: 75,
                                  decoration: InputDecoration(
                                      labelText: 'Edit Task',
                                      labelStyle: TextStyle(fontSize: 14)),
                                ),
                              ),

                              // Padding(
                              //   padding: EdgeInsets.all(5.0),
                              //   child: Text(
                              //     'Only 140 Charactors Allowed',
                              //     style: TextStyle(color: Colors.grey, fontSize: 12),
                              //   ),
                              //   ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.stars,
                                    color: Colors.blueAccent,
                                  )
                                ])),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[Text('Select Priority')],
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: ToggleButtons(
                            borderColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            borderWidth: null,
                            selectedBorderColor: Colors.transparent,
                            selectedColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            children: <Widget>[
                              // Container(width: 55, height: 20, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Text("HIGH",style: TextStyle(color: Colors.red, fontSize: 12),)],)),
                              // Container(width: 55, height: 20, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Text("MEDIUM",style: TextStyle(color: Colors.yellow[800], fontSize: 12))],)),
                              // Container(width: 55, height: 20,child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Text("LOW",style: TextStyle(color: Colors.green, fontSize: 12))],)),
                              !isSelected[0]
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      margin: EdgeInsets.only(right: 3.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(48.0)),
                                      ),
                                      child: Text(
                                        'HIGH',
                                        style: TextStyle(
                                            color: Colors.grey[900],
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      margin: EdgeInsets.only(right: 3.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(48.0)),
                                      ),
                                      child: Text(
                                        'HIGH',
                                        style: TextStyle(
                                            color: Colors.grey[900],
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                              !isSelected[1]
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      margin: EdgeInsets.only(right: 3.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(48.0)),
                                      ),
                                      child: Text(
                                        'MEDIUM',
                                        style: TextStyle(
                                            color: Colors.grey[900],
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      margin: EdgeInsets.only(right: 3.0),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[800],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(48.0)),
                                      ),
                                      child: Text(
                                        'MEDIUM',
                                        style: TextStyle(
                                            color: Colors.grey[900],
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                              !isSelected[2]
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      margin: EdgeInsets.only(right: 3.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(48.0)),
                                      ),
                                      child: Text(
                                        'LOW',
                                        style: TextStyle(
                                            color: Colors.grey[900],
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      margin: EdgeInsets.only(right: 3.0),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(48.0)),
                                      ),
                                      child: Text(
                                        'LOW',
                                        style: TextStyle(
                                            color: Colors.grey[900],
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                                isSelected[0]
                                    ? priority = 'High'
                                    : isSelected[1]
                                        ? priority = 'Medium'
                                        : priority = 'Low';
                                // print(priority);
                              });
                            },
                            isSelected: isSelected,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.blueAccent,
                                  )
                                ])),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  '${(DateFormat.yMMMd().format(selectedDate))}'),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => showPicker(context),
                                  child: Container(
                                      width: 167,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      margin: EdgeInsets.only(right: 3.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(48.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            ' Chose Date',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                  newTaskErrorMsg,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      Vibration.vibrate(duration: 50);
                                      newTask.text != '' &&
                                              priority != '' &&
                                              taskDate != ''
                                          ? TodoDto()
                                              .editTask(items[edittaskID]["id"], newTask.text,
                                                  priority, taskDate)
                                              .then((value) {
                                              print('This responce : ' + value);
                                              setState(() {
                                                items[edittaskID] = {
                                                  "name": newTask.text,
                                                  "priority": priority,
                                                  "date": taskDate
                                                };
                                              });

                                              Navigator.pop(context);
                                              newTask.text = '';
                                              priority = '';
                                              taskDate = myFormat
                                                  .format(DateTime.now());
                                              showInSnackBar("Task Updated! ☑");
                                            })
                                          : newTaskErrorMsg =
                                              "⚠ Task Name Require!";
                                    },
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width) /
                                              4,
                                          height: 35,
                                          padding: EdgeInsets.only(
                                              left: 2,
                                              right: 2,
                                              top: 2,
                                              bottom: 2),
                                          margin: EdgeInsets.only(
                                              right: 13.0, top: 10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF8b0032),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40.0)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'UPDATE',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    )),
              ));
        });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<Null> showPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        taskDate = myFormat.format(picked);
        // print(myFormat.format(picked));
      });
  }
}