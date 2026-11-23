import 'package:intl/intl.dart' show Intl;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'calendar_page.dart';
import 'forecast_page.dart';
import 'guide_page.dart';
import 'home_page.dart';
import 'l10n.dart';
import 'lock_gate.dart';
import 'notes_page.dart';
import 'onboarding.dart';
import 'settings_page.dart';
import 'theme.dart';
import 'tips_page.dart';

class TrackHerApp extends StatelessWidget {
  const TrackHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.select<AppState, String>((s) => s.settings.themeMode);
    final onboarded = context.select<AppState, bool>((s) => s.settings.onboarded);
    final lang = context.select<AppState, String>((s) => s.lang);
    Intl.defaultLocale = lang;
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      locale: Locale(lang),
      supportedLocales: L.supportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: switch (mode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      home: onboarded ? const LockGate(child: Shell()) : const OnboardingPage(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with WidgetsBindingObserver {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) context.read<AppState>().refresh();
  }

  @override
  void didChangeLocales(List<Locale>? locales) => context.read<AppState>().refresh();

  void goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final titles = [l.navToday, l.navCalendar, l.navForecast, l.navTips, l.titleNotes];
    final pages = [
      HomePage(onNavigate: goTo),
      const CalendarPage(),
      const ForecastPage(),
      const TipsPage(),
      const NotesPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index], style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            tooltip: l.guide,
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => GuidePage(focus: context.read<AppState>().forecast?.likelyPhase))),
          ),
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: _index == 4 ? const AddNoteFab() : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: goTo,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: l.navToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l.navCalendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: l.navForecast,
          ),
          NavigationDestination(
            icon: const Icon(Icons.lightbulb_outline),
            selectedIcon: const Icon(Icons.lightbulb),
            label: l.navTips,
          ),
          NavigationDestination(
            icon: const Icon(Icons.sticky_note_2_outlined),
            selectedIcon: const Icon(Icons.sticky_note_2),
            label: l.navNotes,
          ),
        ],
      ),
    );
  }
}
