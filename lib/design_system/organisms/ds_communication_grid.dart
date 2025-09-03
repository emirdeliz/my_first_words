import 'package:flutter/material.dart';
import '../atoms/ds_text.dart';
import '../atoms/ds_icon.dart';
import '../atoms/ds_spacing.dart';
import '../molecules/ds_card.dart';
import '../tokens/design_tokens.dart';

/// Organism Communication Grid component
class DSCommunicationGrid extends StatelessWidget {
  final List<CommunicationItemData> items;
  final Function(CommunicationItemData) onItemTap;
  final int crossAxisCount;

  // Spacing Props
  final bool sp1;
  final bool sp2;
  final bool sp3;
  final bool sp4;
  final bool sp5;

  const DSCommunicationGrid({
    super.key,
    required this.items,
    required this.onItemTap,
    this.crossAxisCount = 2,
    this.sp1 = false,
    this.sp2 = false,
    this.sp3 = false,
    this.sp4 = false,
    this.sp5 = false,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = TokenMapper.getSpacing(
      sp1: sp1,
      sp2: sp2,
      sp3: sp3,
      sp4: sp4 || (!sp1 && !sp2 && !sp3 && !sp5), // default
      sp5: sp5,
    );

    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return DSCommunicationCard(
          item: item,
          onTap: () => onItemTap(item),
        );
      },
    );
  }
}

/// Communication Item Card component
class DSCommunicationCard extends StatelessWidget {
  final CommunicationItemData item;
  final VoidCallback onTap;

  const DSCommunicationCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'sentiment_satisfied':
        return Icons.sentiment_satisfied;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'people':
        return Icons.people;
      case 'local_drink':
        return Icons.local_drink;
      case 'wc':
        return Icons.wc;
      case 'bedtime':
        return Icons.bedtime;
      case 'healing':
        return Icons.healing;
      case 'help':
        return Icons.help;
      case 'sentiment_dissatisfied':
        return Icons.sentiment_dissatisfied;
      case 'mood_bad':
        return Icons.mood_bad;
      case 'sentiment_very_dissatisfied':
        return Icons.sentiment_very_dissatisfied;
      case 'sentiment_very_satisfied':
        return Icons.sentiment_very_satisfied;
      case 'sentiment_neutral':
        return Icons.sentiment_neutral;
      case 'book':
        return Icons.book;
      case 'brush':
        return Icons.brush;
      case 'waving_hand':
        return Icons.waving_hand;
      case 'favorite':
        return Icons.favorite;
      case 'thumb_up':
        return Icons.thumb_up;
      case 'thumb_down':
        return Icons.thumb_down;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DSCard(
      br3: true,
      sp4: true,
      elev3: true,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSIcon(
            _getIconData(item.icon),
            color: item.color,
            icon7: true,
          ),
          const DSVerticalSpacing.lg(),
          DSSubtitle(
            item.text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Data class for communication items
class CommunicationItemData {
  final String id;
  final String categoryId;
  final String text;
  final String icon;
  final Color color;
  final String type;
  final bool isEnabled;

  const CommunicationItemData({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.icon,
    required this.color,
    required this.type,
    required this.isEnabled,
  });
}
