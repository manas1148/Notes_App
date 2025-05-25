import 'package:flutter/material.dart';
import 'package:notes_app/screens/note_editor.dart';
import '../helpers/database_helper.dart';
import '../models/note.dart';
import '../widgets/note_item.dart';
import 'notes_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    notes = await DatabaseHelper.instance.getNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes App')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSection('Notes', NotesListScreen(), notes.take(2).toList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenu,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection(String title, Widget screen, List items) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          trailing: ElevatedButton(
            child: Text('View All'),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                ),
          ),
        ),
        items.isEmpty
            ? Padding(
              padding: EdgeInsets.all(16),
              child: Text('No $title available. Tap + to create!'),
            )
            : Column(
              children:
                  items.map((item) {
                    if (item is Note) return NoteItem(note: item);
                    return SizedBox();
                  }).toList(),
            ),
      ],
    );
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.note),
                title: Text('Add Note'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToEditor(NoteEditor());
                },
              ),
            ],
          ),
    );
  }

  _navigateToEditor(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    _loadData();
  }
}
