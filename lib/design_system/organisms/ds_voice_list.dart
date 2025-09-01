import 'package:flutter/material.dart';
import '../atoms/ds_text.dart';
import '../atoms/ds_icon.dart';
import '../atoms/ds_spacing.dart';
import '../molecules/ds_card.dart';
import '../tokens/design_tokens.dart';

/// Organism Voice List component
class DSVoiceList extends StatelessWidget {
  final List<Map<String, dynamic>> voices;
  final String? selectedVoiceName;
  final Function(String) onVoiceSelected;
  final Function(String, String) onVoicePreview;
  final bool isLoading;

  const DSVoiceList({
    super.key,
    required this.voices,
    this.selectedVoiceName,
    required this.onVoiceSelected,
    required this.onVoicePreview,
    this.isLoading = false,
  });

  String _formatVoiceName(String name) {
    return name
        .replaceAll('pt-br-', '')
        .replaceAll('pt_br_', '')
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  String _formatLocale(String locale) {
    switch (locale.toLowerCase()) {
      case 'pt-br':
      case 'pt_br':
        return 'Português (Brasil)';
      case 'pt':
        return 'Português';
      case 'en-us':
      case 'en_us':
        return 'English (US)';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return locale;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            DSVerticalSpacing.lg(),
            DSBody('Carregando vozes disponíveis...'),
          ],
        ),
      );
    }

    if (voices.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DSIcon(Icons.voice_over_off, icon8: true),
            DSVerticalSpacing.lg(),
            DSBody('Nenhuma voz disponível'),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: voices.length,
      separatorBuilder: (context, index) => const DSVerticalSpacing.sm(),
      itemBuilder: (context, index) {
        final voice = voices[index];
        final name = voice['name']?.toString() ?? 'Unknown';
        final locale = voice['locale']?.toString() ?? 'Unknown';
        final isSelected = selectedVoiceName == name;

        return DSCard(
          br3: true,
          sp4: true,
          elev0: !isSelected,
          elev2: isSelected,
          backgroundColor: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
              : null,
          onTap: () => onVoiceSelected(name),
          child: Row(
            children: [
              // Selection Indicator
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusRound),
                ),
                child: DSIcon(
                  isSelected ? Icons.check : Icons.person,
                  color: isSelected 
                      ? Colors.white 
                      : Colors.grey.shade600,
                  icon3: true,
                ),
              ),
              
              const DSHorizontalSpacing.lg(),
              
              // Voice Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DSSubtitle(
                      _formatVoiceName(name),
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary 
                          : null,
                    ),
                    const DSVerticalSpacing.xs(),
                    DSBody(
                      _formatLocale(locale),
                      small: true,
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
              
              const DSHorizontalSpacing.lg(),
              
              // Preview Button
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
                ),
                child: IconButton(
                  onPressed: () => onVoicePreview(name, locale),
                  icon: DSIcon(
                    Icons.play_arrow,
                    color: Theme.of(context).colorScheme.secondary,
                    icon3: true,
                  ),
                  tooltip: 'Preview',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
