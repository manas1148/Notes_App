import 'package:flutter/material.dart';
import '../models/note.dart';
import '../helpers/database_helper.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;

  const NoteEditor({super.key, this.note});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            ElevatedButton(onPressed: _saveNote, child: Text('Save')),
          ],
        ),
      ),
    );
  }

  _saveNote() async {
    final note = Note(
      id: widget.note?.id,
      title: _titleController.text,
      content: _contentController.text,
      date: widget.note?.date ?? DateTime.now(),
    );

    if (widget.note == null) {
      await DatabaseHelper.instance.createNote(note);
    } else {
      await DatabaseHelper.instance.updateNote(note);
    }
    Navigator.pop(context);
  }
}
