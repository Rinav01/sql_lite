import 'package:flutter/material.dart';
import 'package:sql_lite/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  final DBHelper dbRef = DBHelper.getInstance;

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  // Fetch all notes from the database
  void getNotes() async {
    List<Map<String, dynamic>> notes = await dbRef.getAllNotes();
    setState(() {
      allNotes = notes;
    });
  }

  // Add a hardcoded note
  Future<void> addNote() async {
    bool success = await dbRef.addNote(
      title: "Test Title",
      desc: "Test Description",
    );
    if (success) {
      getNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
        itemCount: allNotes.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: Text('${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}'),
            title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
            subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
          );
        },
      )
          : const Center(
        child: Text("No Notes yet"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
// test 