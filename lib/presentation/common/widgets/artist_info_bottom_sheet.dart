import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/auth_provider.dart' as app_auth;
import '../../../data/services/messaging_service.dart';
import '../../../data/models/conversation.dart';
import '../../musician/messages/chat_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/musician.dart';

/// Bottom sheet that displays basic artist information
/// Shown when tapping on artist name in music cards
class ArtistInfoBottomSheet extends StatelessWidget {
  final Musician musician;
  final VoidCallback onViewProfile;
  final VoidCallback? onMessage;

  const ArtistInfoBottomSheet({
    super.key,
    required this.musician,
    required this.onViewProfile,
    this.onMessage,
  });

  /// Show the bottom sheet
  static void show(BuildContext context, {
    required Musician musician,
    required VoidCallback onViewProfile,
    VoidCallback? onMessage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ArtistInfoBottomSheet(
            musician: musician,
            onViewProfile: onViewProfile,
            onMessage: onMessage,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Profile section
          Row(
            children: [
              // Profile picture
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: musician.profileImageUrl != null
                    ? NetworkImage(musician.profileImageUrl!)
                    : null,
                child: musician.profileImageUrl == null
                    ? Text(
                  _getInitials(musician.artistName ?? 'Unknown'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 16),

              // Name and basic info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musician.artistName ?? 'Unknown Artist',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (musician.experience != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        musician.experience!,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Genre tags
          if (musician.genres.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: musician.genres.map((genre) {
                return Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    genre,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Bio preview
          if (musician.bio != null && musician.bio!.isNotEmpty) ...[
            Text(
              musician.bio!,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
          ],

          // Action buttons
          Row(
            children: [
              // View Profile button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onViewProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Full Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Message button
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                        Navigator.pop(context);
                        //_showComingSoonMessage(context);

                        if (onMessage != null) {
                          onMessage!();
                          return;
                        }

                        try {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          final currentUser = authProvider.appUser;

                          if (currentUser == null) return;

                          final messagingService = MessagingService();
                          final conversationId = await messagingService.getOrCreateConversation(
                            currentUserId: currentUser.id,
                            otherUserId: musician.userId,
                            currentUserName: currentUser.username,
                            currentUserRole: currentUser.role
                                .toString()
                                .split('.')
                                .last,
                            otherUserName: musician.artistName ?? 'Unknown',
                            otherUserRole: 'musician',
                            currentUserImageUrl: currentUser.profileImageUrl,
                            otherUserImageUrl: musician.profileImageUrl,
                          );

                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      conversationId: conversationId,
                                      currentUserId: currentUser.uid,
                                      otherUser: ParticipantDetail(
                                        name: musician.artistName ?? 'Unknown',
                                        role: 'musician',
                                        profileImageUrl: musician
                                            .profileImageUrl,
                                      ),
                                      otherUserId: musician.userId,
                                    ),
                              ),
                            );
                          }
                        }
                        catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to start conversation: ${e
                                    .toString()}'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery
              .of(context)
              .padding
              .bottom),
        ],
      ),
    );
  }

  /// Get initials from name for avatar placeholder
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
