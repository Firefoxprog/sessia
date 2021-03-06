import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';

class TestHttp extends StatefulWidget {
  final String url;

  TestHttp({String url}):url = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
}// TestHttp

class TestHttpState extends State<TestHttp> {
  final _formKey = GlobalKey<FormState>();

  String _url, _body;
  int _status;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  }//initState

  _sendRequestGet() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();//update form data

      http.get(_url).then((response){
        _status = response.statusCode;
        _body = response.body;

        setState(() {});//reBuildWidget
      }).catchError((error){
        _status = 0;
        _body = error.toString();

        setState(() {});//reBuildWidget
      });
    }
  }//_sendRequestGet


  Widget build(BuildContext context) {
    return Form(key: _formKey, child: SingleChildScrollView(child: Column(
      children: <Widget>[
        Container(
            child: Text('API url', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
            padding: EdgeInsets.all(10.0)
        ),
        Container(
            child: TextFormField(initialValue: _url, validator: (value){if (value.isEmpty) return 'API url isEmpty';}, onSaved: (value){_url = value;}, autovalidate: true),
            padding: EdgeInsets.all(10.0)
        ),
        SizedBox(height: 20.0),
        RaisedButton(child: Text('GET'), onPressed: _sendRequestGet),
        SizedBox(height: 20.0),
        Text('status', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
        Text(_status == null ? '' :_status.toString()),
        SizedBox(height: 20.0),
        Text('body', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
        Text(_body == null ? '' : _body),
      ],
    )));
  }//build
}//TestHttpState

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('JSON'),
          actions: <Widget>[IconButton(icon: Icon(Icons.code), tooltip: 'Code', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CodeScreen()));
          })],
        ),
        body: TestHttp(url: 'https://my-json-server.typicode.com/Firefoxprog/JSON/posts')
    );
  }
}

void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp()
    )
);