import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/note.dart';
import 'note_editor.dart';
import '../widgets/note_item.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  _loadNotes() async {
    notes = await DatabaseHelper.instance.getNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Notes')),
      body:
          notes.isEmpty
              ? Center(child: Text('No notes found'))
              : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) => NoteItem(note: notes[index]),
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NoteEditor()),
            ).then((_) => _loadNotes()),
      ),
    );
  }
}
