import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parental_config_provider.dart';
import '../providers/language_provider.dart';
import '../models/language_model.dart';

import '../services/audio_service.dart';

class ParentalConfigScreen extends StatefulWidget {
  const ParentalConfigScreen({super.key});

  @override
  State<ParentalConfigScreen> createState() => _ParentalConfigScreenState();
}

class _ParentalConfigScreenState extends State<ParentalConfigScreen> {
  void _showVoiceSelectionDialog(BuildContext context, ParentalConfigProvider parentalProvider) {
    showDialog(
      context: context,
      builder: (context) => VoiceSelectionDialog(parentalProvider: parentalProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageModel.supportedLanguages[context.read<LanguageProvider>().currentLanguageCode]!.getTranslation('ui.parentalConfig')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<ParentalConfigProvider, LanguageProvider>(
        builder: (context, parentalProvider, languageProvider, child) {
          // Configuration available via parentalProvider
          final translation = languageProvider.getTranslation;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.family_restroom,
                              size: 28,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                translation('ui.parentalConfig'),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          translation('ui.configureAudiosDesc'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        // Seleção de voz específica
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                _showVoiceSelectionDialog(context, parentalProvider);
                              },
                              icon: const Icon(Icons.record_voice_over),
                              label: Text(LanguageModel.supportedLanguages[context.read<LanguageProvider>().currentLanguageCode]!.getTranslation('ui.chooseVoice')),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () async {
                                // Preview: falar uma frase curta com a voz selecionada
                                final audio = AudioService();
                                await audio.initialize();
                                await audio.speak(translation('ui.previewSample'));
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: Text(LanguageModel.supportedLanguages[context.read<LanguageProvider>().currentLanguageCode]!.getTranslation('ui.preview')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Seleção de nível de comunicação
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.trending_up, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(LanguageModel.supportedLanguages[context.read<LanguageProvider>().currentLanguageCode]!.getTranslation('ui.communicationLevel'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Text(LanguageModel.supportedLanguages[context.read<LanguageProvider>().currentLanguageCode]!.getTranslation('ui.communicationLevelDesc'), style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(3, (index) {
                          final level = index + 1;
                          final isSelected = parentalProvider.communicationLevel == level;
                          final titles = [
                            translation('parentalConfig.level1Title'),
                            translation('parentalConfig.level2Title'),
                            translation('parentalConfig.level3Title'),
                          ];
                          final descriptions = [
                            translation('parentalConfig.level1Desc'),
                            translation('parentalConfig.level2Desc'),
                            translation('parentalConfig.level3Desc'),
                          ];
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3) : null,
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$level',
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  titles[index],
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                                  ),
                                ),
                                subtitle: Text(
                                  descriptions[index],
                                  style: TextStyle(
                                    color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.7) : null,
                                  ),
                                ),
                                trailing: isSelected ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null,
                                onTap: () => parentalProvider.setCommunicationLevel(level),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Ações globais
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => parentalProvider.enableAllItems(),
                        icon: const Icon(Icons.check_circle),
                        label: Text(LanguageModel.supportedLanguages[context.read<LanguageProvider>().currentLanguageCode]!.getTranslation('ui.enableAll')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => parentalProvider.disableAllItems(),
                        icon: const Icon(Icons.cancel),
                        label: Text(LanguageModel.supportedLanguages[context.read<LanguageProvider>().currentLanguageCode]!.getTranslation('ui.disableAll')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Categorias
                Text(
                  translation('ui.categories'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8, // Ajustado para evitar overflow
                  ),
                  itemCount: ParentalConfigProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = ParentalConfigProvider.categories[index];
                    final categoryId = category['id'] as String;
                    final categoryName = category['name'] as String;
                    final iconName = category['icon'] as String;
                    final color = Color(category['color'] as int);
                    final stats = parentalProvider.getCategoryStats(categoryId);

                    return Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          // Mostrar o modal
                          showDialog(
                            context: context,
                            builder: (context) => CategoryConfigModal(
                              categoryId: categoryId,
                              categoryName: _getCategoryDisplayName(categoryName, translation),
                              onToggleItem: parentalProvider.toggleAudioItem,
                              onEnableAll: () {
                                parentalProvider.enableAllInCategory(categoryId);
                                Navigator.of(context).pop();
                              },
                              onDisableAll: () {
                                parentalProvider.disableAllInCategory(categoryId);
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getIconData(iconName),
                                size: 48,
                                color: color,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _getCategoryDisplayName(categoryName, translation),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  stats,
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCategoryDisplayName(String categoryKey, Function translation) {
    return translation('categories.' + categoryKey);
  }

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
}

// Modal para configurar itens de uma categoria
class CategoryConfigModal extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final Function(String) onToggleItem;
  final VoidCallback onEnableAll;
  final VoidCallback onDisableAll;

  const CategoryConfigModal({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.onToggleItem,
    required this.onEnableAll,
    required this.onDisableAll,
  });

  @override
  State<CategoryConfigModal> createState() => _CategoryConfigModalState();
}

class _CategoryConfigModalState extends State<CategoryConfigModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Consumer<ParentalConfigProvider>(
          builder: (context, parentalProvider, child) {
            final items = parentalProvider.config.enabledAudioItems
                .where((item) => item.categoryId == widget.categoryId)
                .toList();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho do modal
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${context.read<LanguageProvider>().getTranslation('ui.configure')} ${widget.categoryName}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Ações da categoria
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onEnableAll();
                          setState(() {}); // Força atualização da UI
                        },
                        icon: const Icon(Icons.check_circle),
                        label: Text(context.read<LanguageProvider>().getTranslation('ui.enableAll')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onDisableAll();
                          setState(() {}); // Força atualização da UI
                        },
                        icon: const Icon(Icons.cancel),
                        label: Text(context.read<LanguageProvider>().getTranslation('ui.disableAll')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Lista de itens
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            _getIconData(item.icon),
                            color: item.isEnabled 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey,
                          ),
                          title: Text(
                            item.text,
                            style: TextStyle(
                              color: item.isEnabled 
                                  ? Theme.of(context).colorScheme.onSurface 
                                  : Colors.grey,
                            ),
                          ),
                          trailing: Switch(
                            value: item.isEnabled,
                            onChanged: (value) {
                              widget.onToggleItem(item.id);
                              setState(() {}); // Força atualização da UI
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

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

  void _showVoiceSelectionDialog(BuildContext context, ParentalConfigProvider parentalProvider) {
    showDialog(
      context: context,
      builder: (context) => VoiceSelectionDialog(parentalProvider: parentalProvider),
    );
  }
}

// Modal para seleção de voz
class VoiceSelectionDialog extends StatefulWidget {
  final ParentalConfigProvider parentalProvider;

  const VoiceSelectionDialog({
    super.key,
    required this.parentalProvider,
  });

  @override
  State<VoiceSelectionDialog> createState() => _VoiceSelectionDialogState();
}

class _VoiceSelectionDialogState extends State<VoiceSelectionDialog> {
  List<Map<String, dynamic>> _availableVoices = [];
  bool _isLoading = true;
  String? _selectedVoiceName;
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _loadVoices();
  }

  Future<void> _loadVoices() async {
    try {
      await _audioService.initialize();
      final voices = await _audioService.getAvailableVoices();
      // Filtrar para vozes brasileiras (pt-BR) e naturais, excluindo pt-PT
      final List<Map<String, dynamic>> filtered = [];
      for (final v in voices) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        final locale = (v['locale'] ?? '').toString().toLowerCase();
        final isPtBr = locale.contains('pt-br') || locale.contains('pt_br') || name.contains('pt-br') || name.contains('pt_br') || name.contains('brazil');
        final isPtPt = locale.contains('pt-pt') || locale.contains('pt_pt') || name.contains('pt-pt') || name.contains('pt_pt') || name.contains('portugal');
        final isNatural = name.contains('neural') || name.contains('natural');
        
        if (isPtBr && !isPtPt && isNatural) {
          filtered.add(v);
        }
      }
      // Priorizar vozes com nomes contendo "natural" ou "neural"
      int priorityScore(Map<String, dynamic> v) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        int score = 0;
        if (name.contains('neural')) score += 2;
        if (name.contains('natural')) score += 2;
        return score;
      }
      // Se não houver vozes naturais pt-BR, fallback para todas as vozes pt-BR
      List<Map<String, dynamic>> fallbackFiltered = [];
      if (filtered.isEmpty) {
        for (final v in voices) {
          final name = (v['name'] ?? '').toString().toLowerCase();
          final locale = (v['locale'] ?? '').toString().toLowerCase();
          final isPtBr = locale.contains('pt-br') || locale.contains('pt_br') || name.contains('pt-br') || name.contains('pt_br') || name.contains('brazil');
          final isPtPt = locale.contains('pt-pt') || locale.contains('pt_pt') || name.contains('pt-pt') || name.contains('pt_pt') || name.contains('portugal');
          
          if (isPtBr && !isPtPt) {
            fallbackFiltered.add(v);
          }
        }
      }
      
      final listToUse = filtered.isNotEmpty ? filtered : (fallbackFiltered.isNotEmpty ? fallbackFiltered : voices);
      listToUse.sort((a, b) => priorityScore(b).compareTo(priorityScore(a)));
      setState(() {
        _availableVoices = listToUse;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _previewVoice(String voiceName, String locale) async {
    try {
      await _audioService.setSpecificVoice(voiceName, locale);
      await _audioService.speak(context.read<LanguageProvider>().getTranslation('ui.previewSample'));
    } catch (e) {
      // Ignore errors for preview
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.record_voice_over,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.read<LanguageProvider>().getTranslation('ui.chooseVoice'),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          context.read<LanguageProvider>().getTranslation('ui.selectVoiceSubtitle'),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _isLoading
                    ? Consumer<LanguageProvider>(
                        builder: (context, languageProvider, child) {
                          final translation = languageProvider.getTranslation;
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(translation('ui.loadingVoices')),
                              ],
                            ),
                          );
                        },
                      )
                    : _availableVoices.isEmpty
                        ? Consumer<LanguageProvider>(
                            builder: (context, languageProvider, child) {
                              final translation = languageProvider.getTranslation;
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.voice_over_off, size: 64, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    Text(translation('ui.noVoices')),
                                  ],
                                ),
                              );
                            },
                          )
                        : ListView.separated(
                            itemCount: _availableVoices.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final voice = _availableVoices[index];
                              final name = voice['name']?.toString() ?? 'Unknown';
                              final locale = voice['locale']?.toString() ?? 'Unknown';
                              final isSelected = _selectedVoiceName == name;
                              
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected 
                                        ? Theme.of(context).colorScheme.primary 
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  color: isSelected 
                                      ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                                      : Theme.of(context).colorScheme.surface,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSelected 
                                          ? Theme.of(context).colorScheme.primary 
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Icon(
                                      isSelected ? Icons.check : Icons.person,
                                      color: isSelected 
                                          ? Colors.white 
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  title: Text(
                                    _formatVoiceName(name),
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected 
                                          ? Theme.of(context).colorScheme.primary 
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _formatLocale(locale),
                                    style: TextStyle(
                                      color: isSelected 
                                          ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: IconButton(
                                      onPressed: () => _previewVoice(name, locale),
                                      icon: Icon(
                                        Icons.play_arrow,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      tooltip: 'Preview',
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedVoiceName = name;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(context.read<LanguageProvider>().getTranslation('ui.cancel')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedVoiceName != null
                          ? () {
                              // TODO: Implementar seleção de voz específica
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(context.read<LanguageProvider>().getTranslation('ui.confirm')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatVoiceName(String name) {
    // Simplify voice names for better readability
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
    // Format locale for better display
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
}
