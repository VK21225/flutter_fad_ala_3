import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes Manager",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  List<Map<String,String>> notes = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> saveNotes() async {

    final prefs = await SharedPreferences.getInstance();

    prefs.setString("notes", jsonEncode(notes));
  }

  Future<void> loadNotes() async {

    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString("notes");

    if(data != null){

      List decoded = jsonDecode(data);

      notes = decoded.map((e)=>Map<String,String>.from(e)).toList();

      setState(() {});
    }
  }

  void addNote(){

    if(titleController.text.isEmpty || noteController.text.isEmpty){
      return;
    }

    setState(() {

      notes.add({
        "title":titleController.text,
        "note":noteController.text
      });

    });

    saveNotes();

    titleController.clear();
    noteController.clear();
  }

  void deleteNote(int index){

    setState(() {
      notes.removeAt(index);
    });

    saveNotes();
  }

  void editNote(int index){

    titleController.text = notes[index]["title"]!;
    noteController.text = notes[index]["note"]!;

    showDialog(

      context: context,

      builder: (_){

        return AlertDialog(

          title: Text("Edit Note"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),

              SizedBox(height:10),

              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: "Note"),
              )

            ],
          ),

          actions: [

            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: (){

                setState(() {

                  notes[index] = {
                    "title":titleController.text,
                    "note":noteController.text
                  };

                });

                saveNotes();

                titleController.clear();
                noteController.clear();

                Navigator.pop(context);
              },
              child: Text("Update"),
            )

          ],

        );
      }

    );
  }

  @override
  Widget build(BuildContext context) {

    List colors = [
      Colors.orange.shade200,
      Colors.green.shade200,
      Colors.pink.shade200,
      Colors.blue.shade200,
      Colors.yellow.shade200
    ];

    return Scaffold(

      appBar: AppBar(
        title: Text("Notes Manager"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade200,
              Colors.blue.shade200
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(

          padding: EdgeInsets.all(16),

          child: Column(

            children: [

              Card(

                elevation: 8,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Padding(

                  padding: EdgeInsets.all(16),

                  child: Column(

                    children: [

                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      SizedBox(height:10),

                      TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          labelText: "Note",
                          prefixIcon: Icon(Icons.note),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      SizedBox(height:15),

                      SizedBox(

                        width: double.infinity,

                        child: ElevatedButton.icon(

                          onPressed: addNote,

                          icon: Icon(Icons.add),

                          label: Text("Add Note"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical:14),
                          ),

                        ),

                      )

                    ],
                  ),

                ),

              ),

              SizedBox(height:20),

              Expanded(

                child: notes.isEmpty

                    ? Center(
                        child: Text(
                          "No Notes Yet",
                          style: TextStyle(
                            fontSize:18,
                            color: Colors.white,
                          ),
                        ),
                      )

                    : ListView.builder(

                        itemCount: notes.length,

                        itemBuilder: (context,index){

                          return Card(

                            color: colors[index % colors.length],

                            elevation:4,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),

                            margin: EdgeInsets.symmetric(vertical:8),

                            child: ListTile(

                              title: Text(
                                notes[index]["title"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:16,
                                ),
                              ),

                              subtitle: Text(notes[index]["note"]!),

                              onTap: (){
                                editNote(index);
                              },

                              trailing: IconButton(
                                icon: Icon(Icons.delete,color: Colors.red),
                                onPressed: (){
                                  deleteNote(index);
                                },
                              ),

                            ),

                          );
                        }
                    ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
