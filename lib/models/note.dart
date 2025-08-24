class Note {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String category;
  final bool isPinned;
  final int color;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.category = 'General',
    this.isPinned = false,
    this.color = 0,
  });

  // Convert Note to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'category': category,
      'isPinned': isPinned,
      'color': color,
    };
  }

  // Create Note from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? 'General',
      isPinned: json['isPinned'] ?? false,
      color: json['color'] ?? 0,
    );
  }

  // Create a copy of note with updated fields
  Note copyWith({
    String? title,
    String? description,
    DateTime? updatedAt,
    List<String>? tags,
    String? category,
    bool? isPinned,
    int? color,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
    );
  }
}
