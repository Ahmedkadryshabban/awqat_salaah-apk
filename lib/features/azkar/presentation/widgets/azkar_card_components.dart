import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../data/models/azkar_item_model.dart';

/// Top header row of AzkarCard containing index number circle, title, and action icons.
class AzkarCardHeader extends StatelessWidget {
  final AzkarItem item;
  final int itemIndex;
  final bool isCompleted;
  final bool isDark;
  final bool isReorderMode;
  final int? reorderIndex;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;

  const AzkarCardHeader({
    super.key,
    required this.item,
    required this.itemIndex,
    required this.isCompleted,
    required this.isDark,
    required this.isReorderMode,
    this.reorderIndex,
    this.onMoveUp,
    this.onMoveDown,
    this.onEdit,
    this.onDelete,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Right side (in RTL): Index Circle Badge + Title
        Expanded(
          child: Row(
            children: [
              if (isReorderMode && reorderIndex != null) ...[
                ReorderableDragStartListener(
                  index: reorderIndex!,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsetsDirectional.only(end: 8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                        width: 0.8,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.drag_indicator_rounded,
                          color: AppColors.accentGold,
                          size: 18,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'اسحب',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Deep green circular number badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? (isDark ? const Color(0xFF1B4D3E) : AppColors.primary)
                        : (isDark ? const Color(0xFF1F3D30) : AppColors.primary),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$itemIndex',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],

              // Dhikr Title
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                    color: isCompleted
                        ? AppColors.primary
                        : (isDark ? Colors.white : const Color(0xFF163A29)),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Left side (in RTL): Action icons (Share, Bookmark, More options)
        if (isReorderMode) ...[
          IconButton(
            icon: const Icon(Icons.arrow_upward_rounded, size: 20),
            color: onMoveUp != null
                ? AppColors.accentGold
                : (isDark ? Colors.white24 : Colors.black26),
            tooltip: 'تحريك لأعلى',
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: onMoveUp,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward_rounded, size: 20),
            color: onMoveDown != null
                ? AppColors.accentGold
                : (isDark ? Colors.white24 : Colors.black26),
            tooltip: 'تحريك لأسفل',
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: onMoveDown,
          ),
        ] else ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Share button
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 19),
                color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                tooltip: 'مشاركة الذكر',
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                onPressed: onShare,
              ),

              // Direct Edit Pencil button (Replaces 3-dots popup menu as requested)
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.mode_edit_outline_rounded, size: 20),
                  color: isDark ? AppColors.accentGoldLight : AppColors.wirdPrimaryGreen,
                  tooltip: 'تعديل الذكر',
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                  onPressed: onEdit,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Middle section of AzkarCard containing the Arabic Quran/Dhikr text in a soft tinted container,
/// followed by the "من فضلها" virtue container.
class AzkarCardBody extends StatelessWidget {
  final AzkarItem item;
  final bool isDark;

  const AzkarCardBody({
    super.key,
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Subtle warm parchment tint for Quranic verses or clean soft sage-grey
    final isQuranic = item.title.contains('آية') ||
        item.title.contains('المعوذات') ||
        item.title.contains('سورة') ||
        item.title.contains('الإخلاص') ||
        item.title.contains('الفلق') ||
        item.title.contains('الناس');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Arabic Dhikr Text Container (Soft tinted, sleek compact spacing, high readability)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: AppDesignSystem.dhikrTextContainerDecoration(
            isDark: isDark,
            isWarmParchment: isQuranic,
          ),
          child: Text(
            item.arabicText,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16.5,
              height: 1.68,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.azkarTextDark : AppColors.azkarTextLight,
            ),
            textAlign: TextAlign.start,
            textDirection: TextDirection.rtl,
          ),
        ),

        // Virtue container ("من فضلها")
        if (item.reward != null || item.reference != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: AppDesignSystem.virtueBoxDecoration(isDark: isDark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Book icon + "من فضلها"
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 13,
                      color: isDark ? AppColors.accentGoldLight : AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'من فضلها',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.accentGoldLight : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                if (item.reward != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.reward!,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      height: 1.4,
                      color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (item.reference != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.reference!,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.5,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Bottom footer of AzkarCard with repetition label on right and interactive square counter box on left.
class AzkarCardFooter extends StatelessWidget {
  final AzkarItem item;
  final bool isCompleted;
  final bool isDark;
  final bool isReorderMode;
  final Animation<double> scaleAnimation;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onToggleComplete;
  final VoidCallback? onBookmark;
  final bool isBookmarked;

  const AzkarCardFooter({
    super.key,
    required this.item,
    required this.isCompleted,
    required this.isDark,
    required this.isReorderMode,
    required this.scaleAnimation,
    required this.onIncrement,
    required this.onDecrement,
    required this.onToggleComplete,
    this.onBookmark,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Right Side (in RTL): 1-Tap Completion Pill Button or Completion Status
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isCompleted) ...[
              // One-tap complete button: instantly finishes the dhikr (e.g. 100 repetitions)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isReorderMode
                      ? null
                      : () {
                          HapticFeedback.heavyImpact();
                          onToggleComplete();
                        },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.wirdPrimaryGreen.withValues(alpha: 0.15)
                          : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? AppColors.wirdPrimaryGreen.withValues(alpha: 0.4)
                            : const Color(0xFFA5D6A7),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.done_all_rounded,
                          size: 16,
                          color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'إتمام الورد',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (item.currentCount > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '${item.currentCount} / ${item.targetCount}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.accentGoldLight : AppColors.wirdPrimaryGreen,
                  ),
                ),
              ],
            ] else ...[
              // Already completed state
              InkWell(
                onTap: isReorderMode
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        onToggleComplete();
                      },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF143826)
                        : const Color(0xFFE0F2E9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF266747)
                          : const Color(0xFF81C784),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 15,
                        color: isDark ? AppColors.accentGoldLight : AppColors.wirdPrimaryGreen,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item.currentCount > item.targetCount
                            ? 'مكتمل (${item.currentCount})'
                            : 'مكتمل بحمد الله',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.accentGoldLight : AppColors.wirdPrimaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),

        // Left Side (in RTL): Interactive Counter Square Box + Undo control
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decrement / Undo button (visible whenever user tapped count > 0)
            if (item.currentCount > 0 && !isReorderMode) ...[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onDecrement();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : const Color(0xFFF1F4F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? Colors.white12 : const Color(0xFFDCE5DC),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove_rounded,
                      size: 16,
                      color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                    ),
                  ),
                ),
              ),
            ],

            // Interactive Square Box:
            // - At count 0: displays targetCount as a subtle placeholder (e.g., 3) with white/dark background
            // - At count 1, 2, ...: displays actual count in green/gold with white/dark background
            // - At targetCount: turns green with white checkmark
            // - When exceeding targetCount (4, 5, ...): stays green with white number text
            ScaleTransition(
              scale: scaleAnimation,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isReorderMode
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          onIncrement();
                        },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.wirdPrimaryGreen
                          : (isDark
                              ? const Color(0xFF1E382B)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.wirdPrimaryGreen
                            : (item.currentCount == 0
                                ? (isDark ? Colors.white24 : const Color(0xFFCBD5E1))
                                : (isDark
                                    ? AppColors.accentGoldLight.withValues(alpha: 0.4)
                                    : AppColors.wirdPrimaryGreen.withValues(alpha: 0.35))),
                        width: isCompleted ? 1.5 : (item.currentCount == 0 ? 1.4 : 1.6),
                      ),
                      boxShadow: isCompleted
                          ? [
                              BoxShadow(
                                color: AppColors.wirdPrimaryGreen.withValues(alpha: isDark ? 0.35 : 0.25),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                    ),
                    alignment: Alignment.center,
                    child: isCompleted && item.currentCount == item.targetCount
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 24,
                          )
                        : Text(
                            item.currentCount == 0
                                ? '${item.targetCount}'
                                : '${item.currentCount}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w800,
                              fontSize: (item.currentCount == 0 ? item.targetCount : item.currentCount) > 99 ? 14 : 17,
                              height: 1.1,
                              color: isCompleted
                                  ? Colors.white
                                  : (item.currentCount == 0
                                      ? (isDark ? Colors.white38 : const Color(0xFF94A3B8))
                                      : (isDark
                                          ? AppColors.accentGoldLight
                                          : AppColors.wirdPrimaryGreen)),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
