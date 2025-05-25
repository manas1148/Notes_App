import 'package:flutter/material.dart';
import '../models/note.dart';
import '../screens/note_editor.dart';
import '../helpers/database_helper.dart';

class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content),
        trailing: PopupMenuButton(
          itemBuilder:
              (context) => [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
          onSelected: (value) => _handleAction(context, value.toString()),
        ),
      ),
    );
  }

  _handleAction(BuildContext context, String action) async {
    if (action == 'edit') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NoteEditor(note: note)),
      );
    } else if (action == 'delete') {
      await DatabaseHelper.instance.deleteNote(note.id!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Note deleted')));
    }
  }
}
