import 'package:flutter_test/flutter_test.dart';
import 'package:quicknotes/models/note.dart';
import 'package:quicknotes/providers/notes_provider.dart';
import 'package:quicknotes/providers/theme_provider.dart';

void main() {
  group('QuickNotes App Tests', () {
    // Test 1: Note Model
    test('Note model should handle data correctly', () {
      final note = Note(
        id: '1',
        title: 'Test Note',
        description: 'Test Description',
        isPinned: true,
        category: 'Work',
        tags: ['important', 'test'],
        color: 2,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
      );

      // Test properties
      expect(note.id, '1');
      expect(note.title, 'Test Note');
      expect(note.isPinned, true);
      expect(note.tags, contains('important'));

      // Test JSON serialization
      final json = note.toJson();
      final fromJson = Note.fromJson(json);
      expect(fromJson.id, note.id);
      expect(fromJson.title, note.title);
    });

    // Test 2: Theme Provider
    test('ThemeProvider should toggle theme mode', () {
      final themeProvider = ThemeProvider();

      // Initial state
      expect(themeProvider.isDarkMode, false);

      // Toggle to dark
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, true);

      // Toggle back to light
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, false);
    });

    // Test 3: Notes Provider
    test('NotesProvider should manage notes correctly', () {
      final provider = NotesProvider();

      // Add note
      provider.addNote('Test', 'Description');
      expect(provider.notes.length, 1);
      expect(provider.notes[0].title, 'Test');

      // Update note
      final noteId = provider.notes[0].id;
      provider.updateNote(noteId, 'Updated', 'New Description');
      expect(provider.notes[0].title, 'Updated');

      // Delete note
      provider.deleteNote(noteId);
      expect(provider.notes.isEmpty, true);
    });
  });
}
