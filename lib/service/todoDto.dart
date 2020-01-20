import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class TodoDto {
  Future getData() async {
    var url = 'https://todorium.000webhostapp.com/get.php';
    http.Response response = await http.get(url);
    // var data = json.encode(response.body);

    String receivedJson = response.body;
    var items = json.decode(receivedJson);
    // print(items[0]);
    return items;
  }

  Future getArchived() async {
    var url = 'https://todorium.000webhostapp.com/archived.php';
    http.Response response = await http.get(url);
    // var data = json.encode(response.body);

    String receivedJson = response.body;
    var items = json.decode(receivedJson);
    // print(items[0]);
    return items;
  }

  Future updateDone(doneId) async {
    // set up PATCH request arguments
    String url = 'http://todorium.000webhostapp.com/done.php';
    //Map<String, String> headers = {"Content-type": "application/json"};

    // String json = '{"id": doneId }';

    var something = {"id": doneId};
    String json = jsonEncode(something);

    // make PATCH request
    var response = await post(url, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // only the title is updated
    String body = response.body;
    // print(body);
    return body;
  }

  Future insertTask(taskName, taskPriority, taskDate) async {
    // set up PATCH request arguments
    String url = 'http://todorium.000webhostapp.com/insert.php';
    //Map<String, String> headers = {"Content-type": "application/json"};

    // String json = '{"id": doneId }';

    var something = {
      "name": taskName,
      "priority": taskPriority,
      "date": taskDate
    };
    String json = jsonEncode(something);

    // make PATCH request
    var response = await post(url, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // only the title is updated
    String body = response.body;
    // print(body);
    return body;
  }

  Future unArchive(doneId) async {
    String url = 'http://todorium.000webhostapp.com/unarchive.php';
    var something = {"id": doneId};
    String json = jsonEncode(something);
    var response = await post(url, body: json);
    String body = response.body;
    return body;
  }


    Future editTask(editId, taskName, taskPriority, taskDate) async {
    String url = 'http://todorium.000webhostapp.com/edit.php';
    var something = {
      "id": editId,
      "name": taskName,
      "priority": taskPriority,
      "date": taskDate
    };
    String json = jsonEncode(something);
    var response = await post(url, body: json);
    String body = response.body;
    return body;
  }

   Future getToday() async {
    var url = 'https://todorium.000webhostapp.com/today.php';
    http.Response response = await http.get(url);
    // var data = json.encode(response.body);

    String receivedJson = response.body;
    var items = json.decode(receivedJson);
    // print(items[0]);
    return items;
  }

     Future getPrority() async {
    var url = 'http://todorium.000webhostapp.com/priority.php';
    http.Response response = await http.get(url);
    // var data = json.encode(response.body);

    String receivedJson = response.body;
    var items = json.decode(receivedJson);
    // print(items[0]);
    return items;
  }
}
