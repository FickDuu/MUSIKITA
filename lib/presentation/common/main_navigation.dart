import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/user_role.dart';
import '../musician/home/widgets/musician_home_screen.dart';
import '../musician/discover_music/discover_music_screen.dart';
import '../musician/discover_events/discover_events_screen.dart';
import '../musician/post_music/post_music_screen.dart';
import '../musician/messages/messages_screen.dart';
import '../organizer/home/organizer_home_screen.dart';
import '../organizer/discover_music/organizer_discover_music_screen.dart';
import '../organizer/discover_events/organizer_discover_events_screen.dart';
import '../organizer/create_event/create_event_screen.dart';

/// Main navigation that shows different screens based on user role
class MainNavigation extends StatefulWidget {
  final UserRole userRole;
  final String userId;

  const MainNavigation({
    super.key,
    required this.userRole,
    required this.userId,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Initialize screens based on user role
    if (widget.userRole == UserRole.musician) {
      _screens = [
        DiscoverMusicScreen(userId: widget.userId),       // 0 - Discover music
        DiscoverEventsScreen(userId: widget.userId),      // 1 - Discover events
        PostMusicScreen(userId: widget.userId),           // 2 - Upload music (FAB)
        MessagesScreen(userId: widget.userId),            // 3 - Messages
        MusicianHomeScreen(userId: widget.userId),        // 4 - Profile
      ];
    } else {
      // Organizer screens - 5 items now
      _screens = [
        OrganizerDiscoverMusicScreen(userId: widget.userId),  // 0 - Browse musicians
        OrganizerDiscoverEventsScreen(userId: widget.userId), // 1 - Browse events
        CreateEventScreen(userId: widget.userId),             // 2 - Create event (FAB)
        MessagesScreen(userId: widget.userId),                // 3 - Messages
        OrganizerHomeScreen(userId: widget.userId),           // 4 - Profile
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: widget.userRole == UserRole.musician
          ? _buildMusicianNavBar()
          : _buildOrganizerNavBar(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Musician Navigation Bar
  Widget _buildMusicianNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.white,
        elevation: 0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.music_note,
                label: 'Discover',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.calendar_today,
                label: 'Events',
                index: 1,
              ),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(
                icon: Icons.message,
                label: 'Messages',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Organizer Navigation Bar - Now 5 items like musicians
  Widget _buildOrganizerNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.white,
        elevation: 0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.music_note,
                label: 'Musicians',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.event,
                label: 'Events',
                index: 1,
              ),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(
                icon: Icons.message,
                label: 'Messages',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.business,
                label: 'Profile',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FAB - Changes based on role
  Widget _buildFAB() {
    final isSelected = _currentIndex == 2;
    return FloatingActionButton(
      onPressed: () => setState(() => _currentIndex = 2),
      backgroundColor: isSelected ? AppColors.primaryDark : AppColors.primary,
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        color: AppColors.white,
        size: 32,
      ),
    );
  }
}