import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:search_india/add_fin.dart';

class MakeAdd extends StatefulWidget {

  final Map<String,String> map;
  MakeAdd({this.map});

  @override
  _MakeAddState createState() => _MakeAddState();
}

class _MakeAddState extends State<MakeAdd> {

  bool val = false;
  String name,mobile,city,uid1;
  final firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedinuser;
  bool loading = false;

  void getCurrentUser() async{
    try {
      loading = true;
      var user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        uid1 = user.uid;
      }
    }catch(e){
      print(e);
    }
  }

  void loadData() async{
    try{
      var data = await firestore.collection('users').getDocuments();
      for(var doc in data.documents){
        if(doc.documentID == uid1){
          name = doc.data['name'];
          mobile = doc.data['mobile'];
          city= doc.data['city'];
          break;
        }
      }
      setState(() {
        loading = false;
      });
    }catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    getCurrentUser();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(title: Center(child: Text('Create Report')),),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20,),
            Center(
              child: Text(
                'Requestor Information',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text(
                'Name: *',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 22,

                    color: Colors.black
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text(
                name !=null ? name : 'Loading',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black.withAlpha(140),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text(
                'Phone: *',
                style: TextStyle(

                    fontSize: 22,
                    color: Colors.black
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text(
                mobile !=null ? mobile : 'Loading',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black.withAlpha(140),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text(
                'City: *',
                style: TextStyle(

                    fontSize: 22,
                    color: Colors.black
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text(
                city !=null ? city : 'Loading',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black.withAlpha(140),
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.black,
                  value: val,
                  onChanged: (vary){
                    setState(() {
                      val = vary;
                    });
                  },
                ),
                Text(
                  'Hide Phone number ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.black.withAlpha(140),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FinalAdd(map: widget.map)));
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black
                  ),
                  child: Center(
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height:20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
