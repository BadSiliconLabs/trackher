import 'package:intl/intl.dart' show DateFormat;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/day.dart';
import '../services/notifications.dart';
import '../state/app_state.dart';
import 'l10n.dart';
import 'theme.dart';
import 'widgets/language_menu.dart';
import 'widgets/month_calendar.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pager = PageController();
  final _name = TextEditingController();
  final Set<int> _days = {};
  int _step = 0;

  void _next() {
    FocusScope.of(context).unfocus();
    _pager.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Future<void> _finish() async {
    final state = context.read<AppState>();
    final notifications = context.read<NotificationService>();
    await state.completeOnboarding(_name.text, _days.map(fromDayNumber));
    try {
      await notifications.requestPermission();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i <= _step ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pager,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [_welcome(theme), _nameStep(theme), _datesStep(theme)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _welcome(ThemeData theme) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(alignment: Alignment.topRight, child: LanguageMenuButton()),
        const Spacer(),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
          child: Icon(Icons.radio_button_checked, size: 36, color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: 16),
        Text(kAppName, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Text(context.l.obTagline, style: theme.textTheme.titleMedium),
        const SizedBox(height: 20),
        _InfoBox(icon: Icons.handshake_outlined, text: context.l.obRespect),
        const SizedBox(height: 10),
        _InfoBox(icon: Icons.lock_outline, text: context.l.obPrivacy),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: _next, child: Text(context.l.obStart)),
        ),
      ],
    ),
  );

  Widget _nameStep(ThemeData theme) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(context.l.obNameTitle, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(context.l.obNameHint, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: context.l.obNameLabel, border: const OutlineInputBorder()),
          onSubmitted: (_) => _next(),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: _next, child: Text(context.l.next)),
        ),
      ],
    ),
  );

  Widget _datesStep(ThemeData theme) {
    final today = dayNumber(DateTime.now());
    final sorted = _days.toList()..sort((a, b) => b - a);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              context.l.obDatesTitle,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(context.l.obDatesHint, style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: 8),
          MonthCalendar(
            lastMonth: DateTime.now(),
            onTap: (d) {
              final n = dayNumber(d);
              if (n > today) return;
              setState(() => _days.contains(n) ? _days.remove(n) : _days.add(n));
            },
            cellBuilder: (context, d, inMonth) {
              final n = dayNumber(d);
              final selected = _days.contains(n);
              final future = n > today;
              return Center(
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? kSeed : null,
                    border: n == today ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
                  ),
                  child: Text(
                    '${d.day}',
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : future || !inMonth
                          ? theme.colorScheme.outlineVariant
                          : theme.colorScheme.onSurface,
                      fontWeight: selected ? FontWeight.w700 : null,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final n in sorted)
                  InputChip(
                    label: Text(DateFormat.yMMMd().format(fromDayNumber(n))),
                    onDeleted: () => setState(() => _days.remove(n)),
                  ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _days.isEmpty ? null : _finish,
              child: Text(_days.isEmpty ? context.l.obPickOne : context.l.obDone(_days.length)),
            ),
          ),
          Center(
            child: TextButton(onPressed: _finish, child: Text(context.l.obSkip)),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoBox({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: cs.secondaryContainer, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cs.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: cs.onSecondaryContainer)),
          ),
        ],
      ),
    );
  }
}
