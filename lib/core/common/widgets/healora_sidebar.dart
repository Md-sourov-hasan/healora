import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/controllers/healora_state.dart';

class NavItem {
  final String titleEn;
  final String titleBn;
  final IconData icon;
  final List<HealoraRole>? allowedRoles;

  const NavItem({
    required this.titleEn,
    required this.titleBn,
    required this.icon,
    this.allowedRoles,
  });
}

class HealoraSidebar extends StatelessWidget {
  final HealoraState state;
  final bool isTablet;

  const HealoraSidebar({super.key, required this.state, this.isTablet = false});

  static const List<NavItem> navItems = [
    NavItem(
      titleEn: 'Overview',
      titleBn: 'সারসংক্ষেপ',
      icon: Icons.dashboard_outlined,
    ),
    NavItem(
      titleEn: 'Hubs & Areas',
      titleBn: 'হাব ও এলাকা',
      icon: Icons.apartment_outlined,
    ),
    NavItem(
      titleEn: 'Sessions & Camps',
      titleBn: 'সেশন ও ক্যাম্প',
      icon: Icons.calendar_month_outlined,
    ),
    NavItem(
      titleEn: 'Live Queue',
      titleBn: 'লাইভ কিউ',
      icon: Icons.format_list_numbered_outlined,
    ),
    NavItem(
      titleEn: 'Check-in & Walk-in',
      titleBn: 'চেক-ইন ও নতুন রোগী',
      icon: Icons.person_add_alt_1_outlined,
    ),
    NavItem(
      titleEn: 'Special Team & Doctor',
      titleBn: 'ক্লিনিক্যাল এক্সিকিউশন',
      icon: Icons.monitor_heart_outlined,
    ),
    NavItem(
      titleEn: 'Stations & Devices',
      titleBn: 'স্টেশন ও যন্ত্রপাতি',
      icon: Icons.medical_services_outlined,
    ),
    NavItem(
      titleEn: 'Operations Reports',
      titleBn: 'অপারেশনাল রিপোর্ট',
      icon: Icons.bar_chart_outlined,
    ),
    NavItem(
      titleEn: 'Compliance & Audit',
      titleBn: 'কমপ্লায়েন্স ও অডিট',
      icon: Icons.verified_user_outlined,
    ),
    NavItem(
      titleEn: 'Notifications',
      titleBn: 'নোটিফিকেশন',
      icon: Icons.notifications_none_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double width =
        (isTablet ? HealoraSpacing.iconRailWidth : HealoraSpacing.sidebarWidth)
            .w;
    final List<MapEntry<int, NavItem>> visibleItems = [
      for (var i = 0; i < navItems.length; i++)
        if (state.activeRole.allowedNavIndexes.contains(i))
          MapEntry(i, navItems[i]),
    ];

    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: HealoraColors.paper,
        border: Border(right: BorderSide(color: HealoraColors.line, width: 1)),
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Navigation items list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: visibleItems.length,
              separatorBuilder: (_, _) => SizedBox(height: 4.h),
              itemBuilder: (context, index) {
                final int navIndex = visibleItems[index].key;
                final NavItem item = visibleItems[index].value;
                final bool isSelected = state.currentNavIndex == navIndex;

                if (isTablet) {
                  return Tooltip(
                    message: state.t(item.titleEn, item.titleBn),
                    child: InkWell(
                      onTap: () => state.setNavIndex(navIndex),
                      borderRadius: HealoraSpacing.borderControl,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? HealoraColors.ink
                              : Colors.transparent,
                          borderRadius: HealoraSpacing.borderControl,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              size: 22,
                              color: isSelected
                                  ? Colors.white
                                  : HealoraColors.slate,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              state.t(item.titleEn, item.titleBn),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: HealoraTypography.micro(
                                color: isSelected
                                    ? Colors.white
                                    : HealoraColors.slate,
                                isBangla: state.isBangla,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Desktop sidebar item
                return InkWell(
                  onTap: () => state.setNavIndex(navIndex),
                  borderRadius: HealoraSpacing.borderControl,
                  child: Container(
                    height: 44.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? HealoraColors.ink
                          : Colors.transparent,
                      borderRadius: HealoraSpacing.borderControl,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: isSelected
                              ? Colors.white
                              : HealoraColors.slate,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            state.t(item.titleEn, item.titleBn),
                            style: HealoraTypography.bodySmall(
                              color: isSelected
                                  ? Colors.white
                                  : HealoraColors.ink,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              isBangla: state.isBangla,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: HealoraColors.teal,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom card: Hub Operations indicator
          if (!isTablet) ...[
            Container(
              margin: EdgeInsets.all(12.r),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: HealoraColors.mist,
                borderRadius: HealoraSpacing.borderControl,
                border: Border.all(color: HealoraColors.line, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: HealoraColors.ok,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          state.t(
                            'বাংলাদেশ অঞ্চল নির্বাচিত',
                            'BANGLADESH REGION SELECTED',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HealoraTypography.label(
                            color: HealoraColors.pine,
                            isBangla: state.isBangla,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    state.t(
                      'Bangladesh region selected',
                      'Deployment and residency require confirmation',
                    ),
                    style: HealoraTypography.micro(
                      color: HealoraColors.slate,
                      isBangla: state.isBangla,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Floating Tab Bar for mobile layout (Spec Chapter 05 & 7.8)
class HealoraFloatingTabBar extends StatelessWidget {
  final HealoraState state;

  const HealoraFloatingTabBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final List<int> visibleIndexes = state.activeRole.allowedNavIndexes;
    return Positioned(
      left: 12.w,
      right: 12.w,
      bottom: 24.h,
      child: Container(
        height: HealoraSpacing.tabBarHeight.h,
        decoration: BoxDecoration(
          color: HealoraColors.paper,
          borderRadius: HealoraSpacing.borderBar,
          boxShadow: HealoraColors.floatShadow,
          border: Border.all(
            color: HealoraColors.line.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          itemCount: visibleIndexes.length,
          separatorBuilder: (_, _) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            final int navIndex = visibleIndexes[index];
            final NavItem item = HealoraSidebar.navItems[navIndex];
            return _buildMobileTab(
              navIndex,
              item.icon,
              item.titleEn,
              item.titleBn,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileTab(
    int index,
    IconData icon,
    String labelEn,
    String labelBn,
  ) {
    final bool isSelected = state.currentNavIndex == index;
    return InkWell(
      onTap: () => state.setNavIndex(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? HealoraColors.ink : HealoraColors.slate,
            ),
            SizedBox(height: 2.h),
            Text(
              state.t(labelEn, labelBn),
              style:
                  HealoraTypography.micro(
                    color: isSelected ? HealoraColors.ink : HealoraColors.slate,
                    isBangla: state.isBangla,
                  ).copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
