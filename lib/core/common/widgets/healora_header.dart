import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/services/healora_state.dart';

class HealoraHeader extends StatelessWidget {
  final HealoraState state;
  final bool isDesktop;

  const HealoraHeader({
    super.key,
    required this.state,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? HealoraSpacing.space10 : HealoraSpacing.space5,
      ),
      decoration: const BoxDecoration(
        color: HealoraColors.paper,
        border: Border(
          bottom: BorderSide(color: HealoraColors.line, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo & Hub Selector
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: HealoraColors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Healora',
                    style: HealoraTypography.h3(
                      color: HealoraColors.pine,
                      isBangla: state.isBangla,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    state.t('Hub Operations & Care Unit', 'হাব অপারেশনস ও কেয়ার ইউনিট'),
                    style: HealoraTypography.micro(
                      color: HealoraColors.slate,
                      isBangla: state.isBangla,
                    ),
                  ),
                ],
              ),
              if (isDesktop) ...[
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: HealoraColors.bone,
                    borderRadius: HealoraSpacing.borderControl,
                    border: Border.all(color: HealoraColors.line, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined, color: HealoraColors.teal, size: 18),
                      const SizedBox(width: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.selectedHubId,
                          icon: const Icon(Icons.keyboard_arrow_down, color: HealoraColors.slate, size: 18),
                          isDense: true,
                          style: HealoraTypography.caption(
                            color: HealoraColors.ink,
                            isBangla: state.isBangla,
                          ).copyWith(fontWeight: FontWeight.w600),
                          onChanged: (String? newId) {
                            if (newId != null) state.setSelectedHub(newId);
                          },
                          items: state.hubs.map((hub) {
                            return DropdownMenuItem<String>(
                              value: hub.id,
                              child: Text('${hub.name} (${hub.code})'),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // Right action bar in a flexible scrollable container
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Offline simulation toggle
                InkWell(
                  onTap: () => state.toggleOfflineMode(),
                  borderRadius: HealoraSpacing.borderControl,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: state.isOffline ? HealoraColors.warnBg : HealoraColors.mist,
                      borderRadius: HealoraSpacing.borderControl,
                      border: Border.all(
                        color: state.isOffline ? HealoraColors.warn : HealoraColors.line,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.isOffline ? Icons.wifi_off : Icons.wifi,
                          color: state.isOffline ? HealoraColors.warnFg : HealoraColors.okFg,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.isOffline
                              ? state.t('Offline (${state.offlineOutbox.length})', 'অফলাইন (${state.offlineOutbox.length})')
                              : state.t('Online', 'অনলাইন'),
                          style: HealoraTypography.caption(
                            color: state.isOffline ? HealoraColors.warnFg : HealoraColors.okFg,
                            isBangla: state.isBangla,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Bilingual Toggle: "বাংলা · English"
                InkWell(
                  onTap: () => state.toggleLanguage(),
                  borderRadius: HealoraSpacing.borderControl,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: HealoraColors.paper,
                      borderRadius: HealoraSpacing.borderControl,
                      border: Border.all(color: HealoraColors.line, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.translate, size: 16, color: HealoraColors.teal),
                        const SizedBox(width: 6),
                        Text(
                          'বাংলা · EN',
                          style: HealoraTypography.caption(
                            color: HealoraColors.ink,
                            isBangla: true,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Active Role Switcher Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: HealoraColors.mist,
                    borderRadius: HealoraSpacing.borderControl,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<HealoraRole>(
                      value: state.activeRole,
                      isDense: true,
                      icon: const Icon(Icons.arrow_drop_down, color: HealoraColors.pine),
                      style: HealoraTypography.caption(
                        color: HealoraColors.pine,
                        isBangla: state.isBangla,
                      ).copyWith(fontWeight: FontWeight.w700),
                      onChanged: (HealoraRole? role) {
                        if (role != null) state.setRole(role);
                      },
                      items: HealoraRole.values.map((role) {
                        return DropdownMenuItem<HealoraRole>(
                          value: role,
                          child: Text(state.isBangla ? role.bnDisplayName : role.displayName),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Notification bell with 16px clay badge (Spec Chapter 7.8)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: HealoraColors.paper,
                        shape: BoxShape.circle,
                        border: Border.all(color: HealoraColors.line, width: 1),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: HealoraColors.ink,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      top: 1,
                      right: 1,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: HealoraColors.clay,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '3',
                            style: HealoraTypography.micro(
                              color: Colors.white,
                              isBangla: state.isBangla,
                            ).copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}
