import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/note.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onPin;
  final VoidCallback? onEdit;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    this.onPin,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Always use surface color from theme
    final noteColor = theme.colorScheme.surface;
    // Use onSurface for text color to ensure contrast with the surface
    final textColor = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Slidable(
        key: ValueKey(note.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.6,
          children: [
            SlidableAction(
              onPressed: (context) => onPin?.call(),
              backgroundColor: note.isPinned 
                  ? colorScheme.secondary 
                  : colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              icon: note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              label: note.isPinned ? 'Unpin' : 'Pin',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (context) => onEdit?.call(),
              backgroundColor: colorScheme.tertiary,
              foregroundColor: colorScheme.onTertiary,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Card(
            elevation: note.isPinned ? 6 : 2,
            color: noteColor,
            shadowColor: note.isPinned
                ? Colors.green.withOpacity(0.3)
                : theme.shadowColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
              side: note.isPinned
                  ? BorderSide(color: Colors.green.shade400, width: 2)
                  : BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                      width: 1.5,
                    ),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  gradient: note.isPinned
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [noteColor, noteColor.withOpacity(0.9)],
                        )
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (note.isPinned)
                            Container(
                              margin: const EdgeInsets.only(right: 8, top: 2),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.push_pin,
                                size: 14,
                                color: Colors.green.shade600,
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (note.title.isNotEmpty)
                                  Text(
                                    note.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          if (note.category != 'General')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.primaryContainer,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                note.category,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: AppConstants.paddingSmall),

                      // Description
                      Text(
                        note.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.4,
                          color: textColor.withOpacity(0.85),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Tags
                      if (note.tags.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.paddingSmall),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: note.tags
                              .take(3)
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: colorScheme.secondaryContainer,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],

                      const SizedBox(height: AppConstants.paddingMedium),

                      // Footer
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: textColor.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatDate(note.updatedAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          if (note.tags.length > 3)
                            Text(
                              '+${note.tags.length - 3} more tags',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: textColor.withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
