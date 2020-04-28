import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
  home: MyApp(),
) );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Our only screen/page we have
      body: HomepageBody()
    );
  }
}




class HomepageBody extends StatefulWidget {
  @override
  _HomepageBodyState createState() => _HomepageBodyState();
}

class _HomepageBodyState extends State<HomepageBody> with SingleTickerProviderStateMixin {
  var _items,_count;
  List<String> _todoItems = [];

  List<String> _finished = [];
  TabController _tabController;
  @override
  void initState(){
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }


  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {

        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index],index);
        }
      },
    );
  }
// Build finished list
  Widget _buildFinishedList(){
    return ListView.builder(itemBuilder: (context,index){
      if (index < _finished.length){
        return _buildFinishedItem(_finished[index],index);
      }
    });
  }
  //Build a finished item
  Widget _buildFinishedItem(String finishedText,  index){
    return Container(
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          child: ListTile(

              contentPadding: EdgeInsets.symmetric(horizontal: 20.0,
                  vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.black87)
                    )
                ),
                child: Icon(Icons.shopping_cart, color: Colors.black87,),
              ),
              title: Text(finishedText),
              subtitle: Row(
                children: <Widget>[
                  Icon(Icons.linear_scale),
                  Text( "quantity")
                ],
              ),
        ),
      ) ,
      )
    );

  }
  // Build a single todo item
  Widget _buildTodoItem(String todoText, int index) {
    return Container(

      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          child: ListTile(

            contentPadding: EdgeInsets.symmetric(horizontal: 20.0,
                vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.black87)
                  )
              ),
              child: Icon(Icons.kitchen, color: Colors.black87,),
            ),
            title: Text(todoText),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.linear_scale),
                Text("$index")
              ],
            ),
            trailing: IconButton(color: Colors.green,
              onPressed: () {
              _finishedItem(todoText);
              }, icon: Icon(Icons.check_circle),),

            onLongPress: () => _promptRemoveTodoItem(index)),


        ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Goal Achiever'),

        centerTitle: true,backgroundColor: Colors.lime[600],bottom: TabBar(
        isScrollable: true,tabs: <Widget>[Tab(
        text: "Todo",
          icon: Icon(Icons.playlist_add),
      ),Tab(text: "Finished",icon: Icon(Icons.playlist_add_check),)],
        labelColor: Colors.white,unselectedLabelColor: Colors.white,
          indicatorColor: Colors.black87,

          controller: _tabController,
      ),),
      body: TabBarView(
        children: <Widget>[_buildTodoList(),_buildFinishedList()],
        controller: _tabController,
      ),




      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: new Icon(Icons.add),
        backgroundColor: Colors.black87,
      ),
    );
  }


  void _addTodoItem(String task) {
    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  void _finishedItem (String task){
    _removeTodoItem(task);
    if(task.length>0){
      setState(() {
       _finished.add(task);
      });
    }
  }

  void _pushAddTodoScreen() {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return Scaffold(
          appBar: AppBar(
            title: Text('Item'),
            backgroundColor: Colors.lime[600],
          ),
          body: Container(
            margin: EdgeInsets.all(25),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[TextFormField(
                  decoration: InputDecoration(labelText: 'Name of item',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      borderSide: new BorderSide(),),),
                  onSaved: (val) {
                    _items=val;

                  },),TextFormField(
                  decoration: InputDecoration(labelText: 'Quantity',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      borderSide: new BorderSide(),),),keyboardType: TextInputType.number,
                  onSaved: (val) {
                    _count=val.toString();

                  },),SizedBox(height: 150,),
                  RaisedButton(child: Text('Submit'),
                    onPressed: (){

                      formkey.currentState.save();
                      _addTodoItem(_items,);
                      Navigator.pop(context);
                    } ,)
                ],
              ),
            )
          ),
        );
      }
    )
    );
  }
  void _removeTodoItem(String task) {
    setState(() => _todoItems.remove(task));
  }
  // Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Delete the item "${_todoItems[index]}" from the list?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop()
                ),
                new FlatButton(
                    child: new Text('Delete'),
                    onPressed: () {
                      _removeTodoItem(_todoItems[index]);
                      Navigator.of(context).pop();
                    }
                )
              ]
          );
        }
    );
  }
}



