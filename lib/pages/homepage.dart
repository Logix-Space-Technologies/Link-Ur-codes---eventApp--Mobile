import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        ),
          drawer: Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.black
                    ),
                    child: Text("LIST  ",style: TextStyle(fontSize: 15,color: Colors.white),),),
                  ListTile(title: const Text("ADMIN LOGIN"),
                    onTap: (){
                     // Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                    },),
                  ListTile(title: const Text("USER LOGIN"),
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                    },),
                  ListTile(title: const Text("COLLEGE LOGIN"),
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                    },),
                  ListTile(title: const Text("STUDENT LOGIN"),
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                    },),
                ]
            ),)
      ),
    );
  }
}
