import 'package:flutter/material.dart';
import 'medicine.dart';

class ListViewPosts extends StatelessWidget {
  final List<Medicine> medicines;

  ListViewPosts({Key key, this.medicines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: medicines.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${medicines[position].title}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  subtitle: Text(
                    '${medicines[position].body}',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 25.0,
                        child: Text(
                          '${medicines[position].userId}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () => _onTapItem(context, medicines[position]),
                ),
              ],
            );
          }),
    );
  }

  Widget _onTapItem(BuildContext context, Medicine post) {
    //@TODO: ADD ITEM TO LOCAL HIVE DB: Item Click -> Alert Dialog -> Add to DB
   showDialog(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           buttonPadding: EdgeInsets.all(12.0),
           title: const Text(
               'Add Medicine to Database?',
                style: TextStyle(
                  fontSize: 20.0,
                ),),
           content: Text(
               post.title,),
           actions: <Widget>[
             FlatButton(
               onPressed: () {
                 Navigator.pop(context);
               },
               child: const Text('Cancel'),
             ),
             ElevatedButton(
               style: ElevatedButton.styleFrom(
                 primary: Colors.blueAccent,
                 onPrimary: Colors.white,
               ),
                 onPressed: null,
                 child: const Text('Yes'),),
           ],
         );
       });
    // Scaffold
    //     .of(context)
    //     .showSnackBar(new SnackBar(content: new Text(post.id.toString() + ' - ' + post.title)));
  }
}