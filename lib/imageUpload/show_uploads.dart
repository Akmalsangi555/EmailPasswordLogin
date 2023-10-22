
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowUploads extends StatefulWidget {
  final String? userId;
  ShowUploads({Key? key, this.userId}) : super(key: key);


  @override
  State<ShowUploads> createState() => _ShowUploadsState();
}

class _ShowUploadsState extends State<ShowUploads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actionsIconTheme: IconThemeData(
           color: Colors.white
        ),
        title: Text('All Images', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
        .doc(widget.userId)
        .collection('images').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(child: Text('No Image uploaded'));
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index){
                String url = snapshot.data!.docs[index]['downloadURl'];
                return Image.network(url,
                height: 300, fit: BoxFit.cover,
                );

              });
          }
        },
      ),
    );
  }
}
