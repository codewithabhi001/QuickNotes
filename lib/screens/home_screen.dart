import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import 'add_edit_note_screen.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _selectedCategory = 'All';
  bool _showPinnedOnly = false;

  @override
  void initState() {
    super.initState();
    // Load notes when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().loadNotes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : const Text(AppConstants.appName),

        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        actions: [
          _buildThemeToggle(),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pinned') {
                setState(() {
                  _showPinnedOnly = !_showPinnedOnly;
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pinned',
                child: Row(
                  children: [
                    Icon(
                      _showPinnedOnly ? Icons.all_inbox : Icons.push_pin,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _showPinnedOnly ? 'Show All' : 'Show Pinned',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            height: 50,
            color: colorScheme.surface,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('All', _selectedCategory == 'All'),
                ...AppConstants.categories.map(
                  (category) => _buildCategoryChip(
                    category,
                    _selectedCategory == category,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          if (notesProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          List<Note> notes = notesProvider.notes;

          // Filter by category
          if (_selectedCategory != 'All') {
            notes = notes
                .where((note) => note.category == _selectedCategory)
                .toList();
          }

          // Filter by pinned status
          if (_showPinnedOnly) {
            notes = notes.where((note) => note.isPinned).toList();
          }

          if (notes.isEmpty) {
            String emptyMessage;
            String? actionText;
            VoidCallback? actionCallback;
            IconData emptyIcon;

            if (notesProvider.searchQuery.isNotEmpty) {
              emptyMessage = AppConstants.noSearchResultsMessage;
              emptyIcon = Icons.search_off;
              actionText = null;
              actionCallback = null;
            } else if (_selectedCategory != 'All') {
              emptyMessage =
                  'No notes in "$_selectedCategory" category.\nTap + to create your first ${_selectedCategory} note!';
              emptyIcon = Icons.category_outlined;
              actionText = 'Create ${_selectedCategory} Note';
              actionCallback = () =>
                  _navigateToAddNoteWithCategory(_selectedCategory);
            } else if (_showPinnedOnly) {
              emptyMessage =
                  'No pinned notes yet.\nPin some notes to see them here!';
              emptyIcon = Icons.push_pin_outlined;
              actionText = 'Show All Notes';
              actionCallback = () => setState(() => _showPinnedOnly = false);
            } else {
              emptyMessage = AppConstants.noNotesMessage;
              emptyIcon = Icons.note_add;
              actionText = 'Create Note';
              actionCallback = _navigateToAddNote;
            }

            return EmptyState(
              message: emptyMessage,
              icon: emptyIcon,
              actionText: actionText,
              onActionPressed: actionCallback,
            );
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => notesProvider.loadNotes(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingSmall,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Dismissible(
                        key: Key('note_${note.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          color: colorScheme.errorContainer,
                          child: Icon(
                            Icons.delete,
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Note'),
                                content: const Text(
                                  'Are you sure you want to delete this note?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('DELETE'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          // Show undo snackbar
                          final deletedNote = note;
                          notesProvider.deleteNote(note.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Note deleted'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  // First add the note with required parameters
                                  notesProvider.addNote(
                                    deletedNote.title,
                                    deletedNote.description,
                                    category: deletedNote.category,
                                  );

                                  // If the note was pinned, update its pinned status
                                  if (deletedNote.isPinned) {
                                    notesProvider.togglePinNote(deletedNote.id);
                                  }
                                },
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        child: NoteCard(
                          note: note,
                          onTap: () => _navigateToNoteDetail(note.id),
                          onDelete: () =>
                              _deleteNoteWithUndo(context, notesProvider, note),
                          onPin: () => notesProvider.togglePinNote(note.id),
                          onEdit: () => _navigateToEditNote(note.id),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedCategory != 'All'
            ? () => _navigateToAddNoteWithCategory(_selectedCategory)
            : _navigateToAddNote,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: Text(
          _selectedCategory != 'All'
              ? 'Add $_selectedCategory Note'
              : 'Add Note',
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: TextStyle(color: colorScheme.onPrimary),
      decoration: InputDecoration(
        hintText: 'Search notes...',
        hintStyle: TextStyle(color: colorScheme.onPrimary.withOpacity(0.7)),
        border: InputBorder.none,
      ),
      onChanged: (query) {
        context.read<NotesProvider>().updateSearchQuery(query);
      },
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<NotesProvider>().clearSearch();
      }
    });
  }

  void _navigateToAddNote() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddEditNoteScreen()));
  }

  void _navigateToAddNoteWithCategory(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditNoteScreen(initialCategory: category),
      ),
    );
  }

  void _navigateToNoteDetail(String noteId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NoteDetailScreen(noteId: noteId)),
    );
  }

  void _navigateToEditNote(String noteId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditNoteScreen(noteId: noteId),
      ),
    );
  }

  void _deleteNoteWithUndo(
    BuildContext context,
    NotesProvider notesProvider,
    Note note,
  ) {
    // Store the note before deleting
    final deletedNote = note;
    notesProvider.deleteNote(note.id);

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // First add the note with required parameters
            notesProvider.addNote(
              deletedNote.title,
              deletedNote.description,
              category: deletedNote.category,
            );

            // If the note was pinned, update its pinned status
            if (deletedNote.isPinned) {
              notesProvider.togglePinNote(deletedNote.id);
            }
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : 'All';
          });
        },
        showCheckmark: false,
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surface,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 1.5,
        ),
        labelStyle: TextStyle(
          color: isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        elevation: isSelected ? 1 : 0,
        pressElevation: 2,
      ),
    );
  }
}
