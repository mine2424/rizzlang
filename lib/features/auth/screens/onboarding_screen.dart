import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/theme/app_theme.dart';

// ────────────────────────────────────────────────
// Onboarding ステップ
// ────────────────────────────────────────────────
enum _Step { languageSelect, welcome, demoChat, callName, complete }

// ────────────────────────────────────────────────
// キャラクター定義
// ────────────────────────────────────────────────
class _CharacterInfo {
  final String id;
  final String name;
  final String language;
  final String languageCode;
  final String flag;
  final String demoOpening;

  const _CharacterInfo({
    required this.id,
    required this.name,
    required this.language,
    required this.languageCode,
    required this.flag,
    required this.demoOpening,
  });
}

const _characters = [
  _CharacterInfo(
    id: 'c1da0000-0000-0000-0000-000000000001',
    name: '지우 (ジウ)',
    language: '韓国語',
    languageCode: 'ko',
    flag: '🇰🇷',
    demoOpening: '안녕 😊 어제 진짜 행복했어\n（昨日、本当に幸せだったよ）',
  ),
  _CharacterInfo(
    id: 'a1da0000-0000-0000-0000-000000000002',
    name: 'Emma',
    language: '英語',
    languageCode: 'en',
    flag: '🇺🇸',
    demoOpening: 'Good morning babe 🥺 I keep thinking about you...',
  ),
  _CharacterInfo(
    id: 'b1da0000-0000-0000-0000-000000000003',
    name: 'Elif',
    language: 'トルコ語',
    languageCode: 'tr',
    flag: '🇹🇷',
    demoOpening: 'Günaydın canım 🌸 Seni çok özledim...',
  ),
  _CharacterInfo(
    id: 'c2da0000-0000-0000-0000-000000000004',
    name: 'Linh',
    language: 'ベトナム語',
    languageCode: 'vi',
    flag: '🇻🇳',
    demoOpening: 'Chào buổi sáng anh ơi 🌸 Em nhớ anh quá...',
  ),
  _CharacterInfo(
    id: 'd1da0000-0000-0000-0000-000000000005',
    name: 'Yasmin',
    language: 'アラビア語',
    languageCode: 'ar',
    flag: '🇦🇪',
    demoOpening: 'Good morning habibi 🌹 I missed you so much...',
  ),
];

// ────────────────────────────────────────────────
// 呼称オプション（キャラクター言語別）
// ────────────────────────────────────────────────
List<String> _callNameOptions(String languageCode) {
  return switch (languageCode) {
    'ko' => ['오빠', '자기야'],
    'en' => ['babe', 'honey'],
    'tr' => ['canım', 'aşkım'],
    'vi' => ['anh ơi', 'anh yêu'],
    'ar' => ['habibi', 'حبيبي'],
    _ => ['babe', 'honey'],
  };
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  _Step _step = _Step.languageSelect;

  // 選択キャラクター（デフォルト: 지우）
  _CharacterInfo _selectedCharacter = _characters[0];

  String _selectedCallName = _characters[0].demoOpening;
  final TextEditingController _customNameCtrl = TextEditingController();
  bool _isCustom = false;

  // デモチャット用
  final List<Map<String, String>> _demoMessages = [];
  final TextEditingController _demoInputCtrl = TextEditingController();
  bool _isDemoLoading = false;
  bool _showSignupPrompt = false;

  @override
  void initState() {
    super.initState();
    // 最初のキャラクターのデフォルト呼称をセット
    _selectedCallName = _callNameOptions(_selectedCharacter.languageCode).first;
    _demoMessages.add({'role': 'char', 'content': _selectedCharacter.demoOpening});
  }

  @override
  void dispose() {
    _customNameCtrl.dispose();
    _demoInputCtrl.dispose();
    super.dispose();
  }

  void _onCharacterSelected(_CharacterInfo character) {
    setState(() {
      _selectedCharacter = character;
      _selectedCallName = _callNameOptions(character.languageCode).first;
    });
  }

  // ────────────────────────────────────────────────
  // ステップ別 Widget
  // ────────────────────────────────────────────────

  Widget _buildLanguageSelect(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'どの言語を学ぶ？',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            'あなたのパートナーを選んでください',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white60,
                ),
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 400.ms),
          const SizedBox(height: 40),

          // キャラクターカード（横スクロール）
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _characters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final char = _characters[i];
                final isSelected = _selectedCharacter.id == char.id;
                return _CharacterCard(
                  character: char,
                  isSelected: isSelected,
                  onTap: () => _onCharacterSelected(char),
                );
              },
            ),
          )
              .animate(delay: 300.ms)
              .fadeIn(duration: 400.ms),

          const SizedBox(height: 40),

          FilledButton(
            onPressed: () => setState(() => _step = _Step.welcome),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('体験してみる →', style: TextStyle(fontSize: 16)),
          )
              .animate(delay: 500.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_selectedCharacter.flag, style: const TextStyle(fontSize: 72))
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            '${_selectedCharacter.name}と話して\n${_selectedCharacter.language}を学ぼう',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(
            '${_selectedCharacter.name}と疑似恋愛しながら\n自然な${_selectedCharacter.language}が身につく',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white60,
                  height: 1.6,
                ),
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 500.ms),
          const SizedBox(height: 48),
          FilledButton(
            onPressed: () {
              // DemoChat のメッセージをリセットして選択キャラのオープニングを設定
              setState(() {
                _demoMessages.clear();
                _demoMessages.add({'role': 'char', 'content': _selectedCharacter.demoOpening});
                _showSignupPrompt = false;
                _step = _Step.demoChat;
              });
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('まず体験してみる', style: TextStyle(fontSize: 16)),
          )
              .animate(delay: 600.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildDemoChat(BuildContext context) {
    return Column(
      children: [
        // ヘッダー
        Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border(bottom: BorderSide(color: Colors.white12)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primary.withOpacity(0.2),
                child: Text(_selectedCharacter.flag,
                    style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_selectedCharacter.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    _selectedCharacter.language,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white38),
                  ),
                ],
              ),
            ],
          ),
        ),

        // メッセージ一覧
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _demoMessages.length,
            itemBuilder: (context, i) {
              final msg = _demoMessages[i];
              final isUser = msg['role'] == 'user';
              return _DemoBubble(
                message: msg['content']!,
                isUser: isUser,
                characterFlag: _selectedCharacter.flag,
              );
            },
          ),
        ),

        if (_isDemoLoading)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 14,
                    child: Text(_selectedCharacter.flag,
                        style: const TextStyle(fontSize: 12))),
                const SizedBox(width: 8),
                _TypingIndicator(),
              ],
            ),
          ),

        if (_showSignupPrompt) _buildSignupPrompt(context),

        // 入力欄
        if (!_showSignupPrompt)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _demoInputCtrl,
                    decoration: InputDecoration(
                      hintText: '日本語で気持ちを入力...',
                      hintStyle: TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: AppTheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _isDemoLoading ? null : _sendDemoMessage,
                  style: FilledButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppTheme.primary,
                  ),
                  child: const Icon(Icons.send_rounded, size: 20),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _sendDemoMessage() async {
    final text = _demoInputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _demoMessages.add({'role': 'user', 'content': text});
      _demoInputCtrl.clear();
      _isDemoLoading = true;
    });

    try {
      final aiService = ref.read(aiServiceProvider);
      final reply = await aiService.generateDemoReply(
        text,
        characterId: _selectedCharacter.id,
      );
      setState(() {
        _demoMessages.add({
          'role': 'char',
          'content': '${reply.reply}\n\n💡 ${reply.why}',
        });
        if (reply.slang.isNotEmpty) {
          _demoMessages.add({
            'role': 'system',
            'content':
                '📚 ${reply.slang.map((s) => '${s.word} = ${s.meaning}').join('\n')}',
          });
        }
        // 2回目の返信後にサインアップ促進
        final userMsgCount =
            _demoMessages.where((m) => m['role'] == 'user').length;
        if (userMsgCount >= 2) _showSignupPrompt = true;
      });
    } catch (e) {
      setState(() {
        _demoMessages.add({
          'role': 'char',
          'content': 'ちょっと待って... もう一度試して 🥺',
        });
      });
    } finally {
      setState(() => _isDemoLoading = false);
    }
  }

  Widget _buildSignupPrompt(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withOpacity(0.15),
            AppTheme.primary.withOpacity(0.05)
          ],
        ),
        border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '${_selectedCharacter.name}がもっと話したそうにしています... 🥺',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => setState(() => _step = _Step.callName),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('続きを読む — 無料でサインアップ'),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildCallName(BuildContext context) {
    final options = _callNameOptions(_selectedCharacter.languageCode);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_selectedCharacter.flag, style: const TextStyle(fontSize: 56))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            '${_selectedCharacter.name}からなんて\n呼ばれたい?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 32),
          ...options.map(
            (label) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CallNameOption(
                label: label,
                isSelected: !_isCustom && _selectedCallName == label,
                onTap: () => setState(() {
                  _isCustom = false;
                  _selectedCallName = label;
                }),
              ),
            ),
          ),
          // カスタム入力
          _CallNameOption(
            label: 'カスタム',
            isSelected: _isCustom,
            onTap: () => setState(() => _isCustom = true),
          ),
          if (_isCustom) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _customNameCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '呼んでほしい名前を入力',
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
              ),
              onChanged: (v) => _selectedCallName =
                  v.isEmpty ? options.first : v,
            ),
          ],
          const SizedBox(height: 40),
          FilledButton(
            onPressed: _goToComplete,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('決定する', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Future<void> _goToComplete() async {
    final options = _callNameOptions(_selectedCharacter.languageCode);
    final callName = _isCustom && _customNameCtrl.text.isNotEmpty
        ? _customNameCtrl.text
        : _selectedCallName.isEmpty
            ? options.first
            : _selectedCallName;

    // Supabase へ呼称を保存
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        final client = ref.read(supabaseClientProvider);
        await client
            .from('users')
            .update({'user_call_name': callName}).eq('id', currentUser.id);
      }
    } catch (_) {
      // 保存失敗してもオンボーディングは続行
    }

    setState(() => _step = _Step.complete);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) context.go('/chat');
  }

  Widget _buildComplete(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('❤️', style: const TextStyle(fontSize: 72))
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            '${_selectedCharacter.name}との会話を始めよう',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          )
              .animate(delay: 300.ms)
              .fadeIn(duration: 500.ms),
          const SizedBox(height: 8),
          Text(
            '接続中...',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white38),
          )
              .animate(delay: 500.ms)
              .fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (_step) {
            _Step.languageSelect => _buildLanguageSelect(context),
            _Step.welcome => _buildWelcome(context),
            _Step.demoChat => _buildDemoChat(context),
            _Step.callName => _buildCallName(context),
            _Step.complete => _buildComplete(context),
          },
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// キャラクターカード
// ────────────────────────────────────────────────
class _CharacterCard extends StatelessWidget {
  const _CharacterCard({
    required this.character,
    required this.isSelected,
    required this.onTap,
  });

  final _CharacterInfo character;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.15)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(character.flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              character.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primary : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              character.language,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppTheme.primary.withOpacity(0.8)
                    : Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// サブウィジェット
// ────────────────────────────────────────────────

class _DemoBubble extends StatelessWidget {
  const _DemoBubble({
    required this.message,
    required this.isUser,
    required this.characterFlag,
  });
  final String message;
  final bool isUser;
  final String characterFlag;

  @override
  Widget build(BuildContext context) {
    final isSystem = !isUser && message.startsWith('📚');
    if (isSystem) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(message,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
                radius: 14,
                child: Text(characterFlag,
                    style: const TextStyle(fontSize: 12))),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primary : AppTheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        children: List.generate(3, (i) {
          final delay = i / 3;
          final t = (_ctrl.value - delay).clamp(0.0, 1.0);
          final opacity =
              (0.3 + 0.7 * (t < 0.5 ? t * 2 : (1 - t) * 2)).clamp(0.3, 1.0);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}

class _CallNameOption extends StatelessWidget {
  const _CallNameOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color:
              isSelected ? AppTheme.primary.withOpacity(0.15) : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.white12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? AppTheme.primary : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
