import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../services/storage_service.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Note> get notes {
    List<Note> filteredNotes;

    if (_searchQuery.isEmpty) {
      filteredNotes = List.from(_notes);
    } else {
      filteredNotes = _notes
          .where(
            (note) =>
                note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                note.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    filteredNotes.sort((a, b) {
      if (a.isPinned && !b.isPinned) {
        return -1; // Pinned notes come first
      } else if (!a.isPinned && b.isPinned) {
        return 1; // Pinned notes come first
      } else {
        // Otherwise, sort by update date
        return b.updatedAt.compareTo(a.updatedAt);
      }
    });

    return filteredNotes;
  }

  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  int get notesCount => _notes.length;

  // Load notes from storage
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await StorageService.loadNotes();
    } catch (e) {
      debugPrint('Error loading notes: $e');
      _notes = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new note
  Future<void> addNote(
    String title,
    String description, {
    List<String>? tags,
    String? category,
    int? color,
  }) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: tags ?? [],
      category: category ?? 'General',
      color: color ?? 0,
    );

    _notes.add(note);
    await _saveNotes();
    notifyListeners();
  }

  // Update an existing note
  Future<void> updateNote(
    String id,
    String title,
    String description, {
    List<String>? tags,
    String? category,
    int? color,
  }) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        title: title.trim(),
        description: description.trim(),
        updatedAt: DateTime.now(),
        tags: tags,
        category: category,
        color: color,
      );
      await _saveNotes();
      notifyListeners();
    }
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _saveNotes();
    notifyListeners();
  }

  // Get a note by ID
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Save notes to storage
  Future<void> _saveNotes() async {
    try {
      await StorageService.saveNotes(_notes);
    } catch (e) {
      debugPrint('Error saving notes: $e');
    }
  }

  // Pin/Unpin a note
  Future<void> togglePinNote(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        isPinned: !_notes[index].isPinned,
        updatedAt: DateTime.now(),
      );
      await _saveNotes();
      notifyListeners();
    }
  }

  // Get notes by category
  List<Note> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // Get all categories
  List<String> getAllCategories() {
    final categories = _notes.map((note) => note.category).toSet().toList();
    categories.sort();
    return categories;
  }

  // Get all tags
  List<String> getAllTags() {
    final tags = <String>{};
    for (final note in _notes) {
      tags.addAll(note.tags);
    }
    return tags.toList()..sort();
  }

  // Filter notes by tag
  List<Note> getNotesByTag(String tag) {
    return _notes.where((note) => note.tags.contains(tag)).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // Get pinned notes
  List<Note> getPinnedNotes() {
    return _notes.where((note) => note.isPinned).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // Restore deleted note (for undo functionality)
  Note? _lastDeletedNote;
  int? _lastDeletedIndex;

  Future<void> deleteNoteWithUndo(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _lastDeletedNote = _notes[index];
      _lastDeletedIndex = index;
      _notes.removeAt(index);
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> undoDelete() async {
    if (_lastDeletedNote != null && _lastDeletedIndex != null) {
      _notes.insert(_lastDeletedIndex!, _lastDeletedNote!);
      _lastDeletedNote = null;
      _lastDeletedIndex = null;
      await _saveNotes();
      notifyListeners();
    }
  }
}
