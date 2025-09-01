import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/language_provider.dart';
import '../design_system/design_system.dart';
import '../screens/communication_board_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CommunicationBoardScreen()),
    );
  }

  void _goToNext() {
    if (_currentPageIndex < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    } else {
      _completeOnboarding();
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const SizedBox(width: 4),
          const Spacer(),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return DSButton(
                text: languageProvider.getTranslation('ui.skip'),
                ghost: true,
                onPressed: _completeOnboarding,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isLast = _currentPageIndex == 2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: [
          Row(
            children: List.generate(3, (index) {
              final isActive = index == _currentPageIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                margin: const EdgeInsets.only(right: 8),
                width: isActive ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
          const Spacer(),
          DSButton(
            text: isLast ? 'Começar' : 'Avançar',
            primary: true,
            onPressed: _goToNext,
          ),
        ],
      ),
    );
  }

  Widget _buildPage({required String title, required String body, required Widget visual}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 140, child: Center(child: visual)),
          const SizedBox(height: 24),
          DSTitle(
            title,
            textAlign: TextAlign.center,
            large: true,
          ),
          const DSVerticalSpacing.md(),
          DSBody(
            body,
            textAlign: TextAlign.center,
            large: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPageIndex = index),
                children: [
                  _buildPage(
                    title: 'Bem-vindo ao My First Words',
                    body: 'Um app de Comunicação Aumentativa e Alternativa para apoiar a fala de crianças autistas.',
                    visual: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  _buildPage(
                    title: 'Toque e o app fala por você',
                    body: 'Escolha cartões e ouça a fala com TTS. Simples, direto e acolhedor.',
                    visual: DSIcon(Icons.record_voice_over, icon8: true, color: color),
                  ),
                  _buildPage(
                    title: 'Configuração Parental',
                    body: 'Ative itens, personalize categorias e cores. Tudo no seu tempo.',
                    visual: DSIcon(Icons.settings, icon8: true, color: color),
                  ),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}


