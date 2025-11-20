import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_role.dart';

class RoleSelectionCard extends StatelessWidget{
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [
            //Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.greyLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getRoleIcon(),
                color: isSelected ? AppColors.white : AppColors.grey,
                size: 28,
              ),
            ),
            const SizedBox(width:16),

            Expanded(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            if(isSelected) const Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 28,
            )
            else
              Icon(
                Icons.circle_outlined,
                color: AppColors.grey.withValues(alpha: 0.3),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(){
    switch(role){
      case UserRole.musician:
        return Icons.music_note;
      case UserRole.organizer:
        return Icons.event;
    }
  }
}