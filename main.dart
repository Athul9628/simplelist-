import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.lime,
      ),
      home: MyHomePage(title: 'Simple List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
 var _items;
 List<String> _todoItems = [];
 List<String> _finished = [];
TabController _tabController;
@override
void initState(){
  _tabController = TabController(length: 2,vsync:this);
  super.initState();
}
  Widget _buildTodoList(){
  return new ListView.builder(
    itemBuilder:(context,index) {
      if(index < _todoItems.length){
        return _buildTodoItem(_todoItems[index],index);
      }
    },
  );
}
  Widget _buildTodoItem(String todoText, int index){
  return Container(
    child: Card(
      elevation:5.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 1.0,color: Colors.black87)
              )
            ),child: Icon(Icons.kitchen,color: Colors.black87,),
          ),

          title: Text(todoText),
          subtitle: Row(
            children: <Widget>[Icon(Icons.linear_scale),Text("$index")],
          ),
          trailing: IconButton(
            color: Colors.green,
            onPressed: () {
              _finishedItem(todoText);
            },icon: Icon(Icons.check_circle),
          ),onLongPress: () => _promptRemoveTodoItem(index),
        ),
      ),
    ),
  );
}

Widget _buildFinishedList(){
  return new ListView.builder(
    itemBuilder:(context,index) {
      if(index < _finished.length){
        return _buildTodoItem(_finished[index],index);
      }
    },
  );
}

Widget _buildFinishedItem(String finishedText, index){
  return Container(
    child: Card(
      elevation:5.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0,color: Colors.black87)
                )
            ),child: Icon(Icons.kitchen,color: Colors.black87,),
          ),

          title: Text(finishedText),
          subtitle: Row(
            children: <Widget>[Icon(Icons.linear_scale),Text("$index")],
          ),
          trailing: IconButton(
            color: Colors.green,
            onPressed: () {
              _finishedItem(index);
            },icon: Icon(Icons.check_circle),
          ),onLongPress: () => _promptRemoveTodoItem(index),
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),bottom:TabBar(
        isScrollable: true,tabs: <Widget>[Tab(
        text: "Todo",
        icon: Icon(Icons.playlist_add),
      ),Tab(
        text: "Finished",
        icon: Icon(Icons.playlist_add_check),

      )],
        controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.black87,
      ) ,
      ),
      body: TabBarView(
        controller: _tabController,
      children: <Widget>[_buildTodoList(),_buildFinishedList()],),

      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _pushAddTodoScreen() {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context){
      return Scaffold(
        appBar: AppBar(
          title: Text("item"),
        ),
        body: Container(
          child: Form(
            key: _formkey,
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: <Widget>[TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Name of item',
                      border: OutlineInputBorder(borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(25.0))
                  ),
                  onSaved: (val){
                    _items=val;
                  },),SizedBox(height: 150,),RaisedButton(
                  child: Text("Submit"),
                  onPressed: (){
                    _formkey.currentState.save();
                    _addTodoItem(_items);
                    Navigator.pop(context);
                  },
                )],
              ),
            ),
          ),
        ),

      );
    }
  ));
  }
 void _addTodoItem(String items) {
   if(items.length >0){
     setState(() => _todoItems.add(items));
     print(items);
   }

 }

 void _finishedItem(String task){
  _removeTodoItem(task);
  if(task.length>0){
    setState(() {
      _finished.add(task);  });
  }
 }
void _removeTodoItem(String task){
  setState(() =>_todoItems.remove(task));
}
void _promptRemoveTodoItem(int index){
  showDialog(context: context,builder: (BuildContext context){
    return AlertDialog(
      title:Text("Delete the item '${_todoItems[index]}' from the list?"),
      actions: <Widget>[FlatButton(
        child: Text("Cancel"),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),FlatButton(
        child: Text('Delete'),
        onPressed: (){
          _removeTodoItem(_todoItems[index]);
          Navigator.of(context).pop();
        },
      )],


    );
  });
}
}
