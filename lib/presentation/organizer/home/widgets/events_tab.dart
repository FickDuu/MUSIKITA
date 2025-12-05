import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/event.dart';
import '../../../../data/services/event_service.dart';
import '../../../musician/discover_events/widgets/event_card.dart';

/// Events tab - shows organizer's posted events
class EventsTab extends StatelessWidget {
  final String userId;

  const EventsTab({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final eventService = EventService();

    return StreamBuilder<List<Event>>(
      stream: eventService.getOrganizerEvents(userId),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading events',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please try again later',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        final events = snapshot.data ?? [];

        // Empty state
        if (events.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 80,
                    color: AppColors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No events yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first event using the + button',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Events list
        return RefreshIndicator(
          onRefresh: () async {
            // Refresh will happen automatically via stream
            await Future.delayed(const Duration(milliseconds: 500));
          },
          color: AppColors.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EventCard(
                  event: event,
                  onEdit: () => _showEditDialog(context, event),
                  onDelete: () => _showDeleteDialog(context, event),
                  showApplicationCount: true, // Show how many applied
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Show edit dialog/navigate to edit screen
  void _showEditDialog(BuildContext context, Event event) {
    // TODO: Navigate to edit event screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit event feature coming next!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Delete Event?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${event.eventName}"?'),
            const SizedBox(height: 12),
            const Text(
              'This will also cancel all pending and confirmed applications.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteEvent(context, event);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Delete event
  Future<void> _deleteEvent(BuildContext context, Event event) async {
    try {
      final eventService = EventService();
      await eventService.deleteEvent(event.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete event: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}