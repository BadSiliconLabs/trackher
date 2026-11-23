import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../services/app_lock.dart';
import '../state/app_state.dart';
import 'l10n.dart';
import 'theme.dart';

/// Shows a lock screen over [child] when app lock is on: at launch and after
/// the app has been in the background for a while.
class LockGate extends StatefulWidget {
  final Widget child;
  const LockGate({super.key, required this.child});

  @override
  State<LockGate> createState() => _LockGateState();
}

class _LockGateState extends State<LockGate> with WidgetsBindingObserver {
  static const _grace = Duration(seconds: 30);
  bool _locked = true;
  bool _busy = false;
  DateTime? _pausedAt;

  bool get _enabled => context.read<AppState>().settings.appLock;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_enabled) _unlock();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.paused || s == AppLifecycleState.hidden) {
      _pausedAt ??= DateTime.now();
    } else if (s == AppLifecycleState.resumed) {
      final away = _pausedAt == null ? Duration.zero : DateTime.now().difference(_pausedAt!);
      _pausedAt = null;
      if (_enabled && !_busy && away >= _grace) {
        setState(() => _locked = true);
        _unlock();
      }
    }
  }

  Future<void> _unlock() async {
    if (_busy) return;
    _busy = true;
    final ok = await context.read<AppLockService>().authenticate(context.l.unlockReason(kAppName));
    _busy = false;
    if (ok && mounted) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = context.select<AppState, bool>((s) => s.settings.appLock);
    if (!enabled || !_locked) return widget.child;
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(Icons.lock_outline, size: 36, color: theme.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 16),
            Text(kAppName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            FilledButton.icon(icon: const Icon(Icons.fingerprint), label: Text(context.l.unlock), onPressed: _unlock),
          ],
        ),
      ),
    );
  }
}
