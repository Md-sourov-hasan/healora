import 'package:flutter/material.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.line, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: 12.h,
        left: 12.w,
        right: 12.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            label: 'Home',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          _buildNavItem(
            index: 1,
            label: 'Hubs',
            icon: Icons.location_on_outlined,
            activeIcon: Icons.location_on,
          ),
          _buildNavItem(
            index: 2,
            label: 'Bookings',
            icon: Icons.calendar_today_outlined,
            activeIcon: Icons.calendar_today,
          ),
          _buildNavItem(
            index: 3,
            label: 'Results',
            icon: Icons.monitor_heart_outlined,
            activeIcon: Icons.monitor_heart,
          ),
          _buildNavItem(
            index: 4,
            label: 'Profile',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final bool isSelected = currentIndex == index;
    final Color itemColor = isSelected ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.mist : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: itemColor,
                size: 22.sp,
              ),
            ),
            4.verticalSpace,
            Text(
              label,
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

