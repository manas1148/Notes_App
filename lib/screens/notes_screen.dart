import 'package:flutter/material.dart';
import '../models/note.dart';
import '../helpers/database_helper.dart';
import '../widgets/note_card.dart';
import '../widgets/search_bar.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadCategories();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes(
      searchQuery: _searchController.text.isEmpty ? null : _searchController.text,
      category: _selectedCategory,
    );
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _loadCategories() async {
    final categories = await _databaseHelper.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _addOrEditNote([Note? note]) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _NoteDialog(note: note),
    );

    if (result != null) {
      final newNote = Note(
        id: note?.id,
        title: result['title']!,
        content: result['content']!,
        category: result['category']!,
        date: DateTime.now(),
      );

      if (note == null) {
        await _databaseHelper.insertNote(newNote);
      } else {
        await _databaseHelper.updateNote(newNote);
      }

      _loadNotes();
      _loadCategories();
    }
  }

  Future<void> _deleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _databaseHelper.deleteNote(note.id!);
      _loadNotes();
      _loadCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: Column(
        children: [
          NotesSearchBar(
            searchController: _searchController,
            selectedCategory: _selectedCategory,
            categories: _categories,
            onSearchChanged: (query) {
              setState(() {
                _loadNotes();
              });
            },
            onCategoryChanged: (category) {
              setState(() {
                _selectedCategory = category;
                _loadNotes();
              });
            },
          ),
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Text('No notes found'),
                  )
                : ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return NoteCard(
                        note: note,
                        onTap: () => _addOrEditNote(note),
                        onDelete: () => _deleteNote(note),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NoteDialog extends StatefulWidget {
  final Note? note;

  const _NoteDialog({this.note});

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _contentController = TextEditingController(text: widget.note?.content);
    _categoryController = TextEditingController(text: widget.note?.category);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter note title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter note content',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'Enter note category',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _contentController.text.isNotEmpty &&
                _categoryController.text.isNotEmpty) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'content': _contentController.text,
                'category': _categoryController.text,
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
} 