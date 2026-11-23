// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get navToday => 'Today';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navForecast => 'Forecast';

  @override
  String get navTips => 'Tips';

  @override
  String get navNotes => 'Notes';

  @override
  String get titleNotes => 'Her notes';

  @override
  String get guide => 'Guide';

  @override
  String get settings => 'Settings';

  @override
  String get herDefault => 'her';

  @override
  String get herDefaultCap => 'She';

  @override
  String get phasePeriod => 'Period';

  @override
  String get phaseFollicular => 'Follicular';

  @override
  String get phaseFertile => 'Fertile window';

  @override
  String get phaseOvulation => 'Ovulation';

  @override
  String get phaseLuteal => 'Luteal';

  @override
  String get phasePms => 'PMS';

  @override
  String get blurbPeriod =>
      'Her period. Energy can be low and cramps are common. Comfort, warmth and patience help most.';

  @override
  String get blurbFollicular =>
      'Hormones are rising and energy and mood often improve. A good time for plans and adventures.';

  @override
  String get blurbFertile =>
      'Around ovulation. Often the time of highest energy, confidence and libido.';

  @override
  String get blurbOvulation =>
      'Estimated ovulation day. Some people feel a twinge or mild pain on one side.';

  @override
  String get blurbLuteal =>
      'Progesterone rises. She may be more tired or want more calm and coziness.';

  @override
  String get blurbPms =>
      'The days before her period. Mood swings, cravings, bloating and irritability are common. Be extra kind.';

  @override
  String get catFood => 'Food';

  @override
  String get catComfort => 'Comfort';

  @override
  String get catAffection => 'Affection';

  @override
  String get catSpace => 'Space';

  @override
  String get catPlans => 'Plans';

  @override
  String get catWords => 'Words';

  @override
  String get catPractical => 'Practical';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodIrritable => 'Irritable';

  @override
  String get moodTired => 'Tired';

  @override
  String get symCramps => 'cramps';

  @override
  String get symHeadache => 'headache';

  @override
  String get symFatigue => 'fatigue';

  @override
  String get symBloating => 'bloating';

  @override
  String get symAcne => 'acne';

  @override
  String get symCravings => 'cravings';

  @override
  String get symBackPain => 'back pain';

  @override
  String get symTenderBreasts => 'tender breasts';

  @override
  String get next => 'Next';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get obTagline =>
      'Know where she is in her cycle and get practical ideas to support her: when to bring snacks, when to give space, when to plan a big date.';

  @override
  String get obRespect =>
      'Every person is different, and she is the expert on herself. This works best when she knows about it and helps you fill it in.';

  @override
  String get obPrivacy =>
      'Everything stays on this phone. No account, no cloud. Not medical advice and not contraception.';

  @override
  String get obStart => 'Let\'s start';

  @override
  String get obNameTitle => 'What\'s her name?';

  @override
  String get obNameHint =>
      'Optional. Only used to make the text more personal.';

  @override
  String get obNameLabel => 'Her name or nickname';

  @override
  String get obDatesTitle => 'When did her periods start?';

  @override
  String get obDatesHint =>
      'Tap the first day of any periods you remember. One is enough. More dates (even months apart) make the forecast more accurate.';

  @override
  String get obPickOne => 'Pick at least one date';

  @override
  String obDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Done ($count dates)',
      one: 'Done (1 date)',
    );
    return '$_temp0';
  }

  @override
  String get obSkip => 'I don\'t know yet, skip';

  @override
  String get bannerStale =>
      'You haven\'t logged a period in a while, so the forecast assumes cycles kept going. Log the latest start for better accuracy.';

  @override
  String get bannerLog => 'Log';

  @override
  String get bannerSuspicious =>
      'Some logged starts are less than 15 days apart and were ignored (spotting or a duplicate?).';

  @override
  String get bannerReview => 'Review';

  @override
  String cycleDay(int n) {
    return 'Cycle day $n';
  }

  @override
  String likelyPhase(String phase) {
    return 'Likely: $phase';
  }

  @override
  String get aboutPhase => 'About this phase';

  @override
  String get anyDayNow => 'Period could start any day now';

  @override
  String nextIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Next period in ~$n days',
      one: 'Next period in ~1 day',
    );
    return '$_temp0';
  }

  @override
  String get startsToday => 'Period most likely starts today';

  @override
  String get probablyStarted => 'Period probably started';

  @override
  String mostLikelyRange(String date, String from, String to) {
    return 'Most likely $date · 80% between $from and $to';
  }

  @override
  String get loggedToday => 'Logged today';

  @override
  String get periodStartedToday => 'Period started today';

  @override
  String get periodEnded => 'Period ended';

  @override
  String loggedSnack(String name) {
    return 'Logged. Forecast updated. Be extra sweet to $name today.';
  }

  @override
  String get nextTwoWeeks => 'Next two weeks';

  @override
  String get remember => 'Remember';

  @override
  String get allNotes => 'All notes';

  @override
  String get todaysTip => 'Today\'s tip';

  @override
  String get moreTips => 'More tips';

  @override
  String get emptyTitle => 'No dates yet';

  @override
  String get emptyBody =>
      'Log the first day of one of her periods (on the Calendar tab, or tap below if it started today) and the forecast appears.';

  @override
  String get calHint => 'Tap a day to log or edit a period, mood or symptoms.';

  @override
  String loggedPeriods(int n) {
    return 'Logged periods ($n)';
  }

  @override
  String get noPeriodsYet => 'None yet. Tap the day her last period started.';

  @override
  String nDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get endNotLogged => 'end not logged';

  @override
  String daysAfterPrevious(int n) {
    return '$n days after previous';
  }

  @override
  String get legendLogged => 'Logged';

  @override
  String get legendPredicted => 'Predicted (shade = probability)';

  @override
  String chanceOfPeriod(int pct) {
    return '$pct% chance of period';
  }

  @override
  String get futureDay =>
      'This day is in the future. You can log it once it happens.';

  @override
  String get periodStartedThisDay => 'Period started this day';

  @override
  String firstDayFor(String name) {
    return 'First day of bleeding for $name';
  }

  @override
  String get periodEndedThisDay => 'Period ended this day';

  @override
  String get periodEndHint => 'Optional. Helps learn her period length';

  @override
  String endedOn(String date, String days) {
    return 'Ended $date ($days)';
  }

  @override
  String get howWasShe => 'How was she? (optional)';

  @override
  String get note => 'Note';

  @override
  String get needOneDate =>
      'Log at least one period start to see the forecast.';

  @override
  String get nextStartProbability => 'Next start probability';

  @override
  String forecastSummary(String date, int pct, String from, String to) {
    return 'Most likely $date ($pct%). 80% chance between $from and $to.';
  }

  @override
  String rangeLine(String from80, String to80, String from95, String to95) {
    return '80%: $from80 – $to80 · 95%: $from95 – $to95';
  }

  @override
  String get chartToday => 'today';

  @override
  String get modelLearned => 'What the model learned';

  @override
  String get avgCycle => 'Average cycle';

  @override
  String daysValue(String v) {
    return '$v days';
  }

  @override
  String plusMinusDays(String v) {
    return '± $v days';
  }

  @override
  String uncertainty(String v) {
    return '± $v uncertainty';
  }

  @override
  String get variation => 'Cycle-to-cycle variation';

  @override
  String get periodLength => 'Period length';

  @override
  String get learnedFromEnds => 'learned from end dates';

  @override
  String get defaultFromSettings => 'default (set in Settings)';

  @override
  String get dataUsed => 'Data used';

  @override
  String intervals(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n intervals',
      one: '1 interval',
    );
    return '$_temp0';
  }

  @override
  String multiCycle(int n) {
    return '$n span multiple cycles (gaps in log, handled)';
  }

  @override
  String fromStarts(int n) {
    return 'from $n logged starts';
  }

  @override
  String get oneDateHint =>
      'With one date, the forecast uses typical cycle statistics. Add another date to personalise it.';

  @override
  String get moreDatesHint =>
      'Each extra logged start narrows the uncertainty.';

  @override
  String get howItWorks => 'How does this work?';

  @override
  String get howItWorksBody =>
      'Each cycle length is modelled as a bell curve (Gaussian) with an unknown average and spread. Starting from typical values (about 28.5 ± 3.5 days), the app updates its belief with every gap between your logged dates using Bayes\' rule. Gaps don\'t need to be consecutive: a 3-month gap is automatically recognised as about 3 cycles. Recent data counts more than old data.\n\nThe forecast mixes all plausible averages and spreads, so the uncertainty honestly grows for cycles further ahead. Not medical advice and not contraception.';

  @override
  String get regUnknown => 'unknown';

  @override
  String get regVeryRegular => 'very regular';

  @override
  String get regRegular => 'regular';

  @override
  String get regSomewhatIrregular => 'somewhat irregular';

  @override
  String get regIrregular => 'irregular';

  @override
  String phaseNow(String phase) {
    return '$phase (now)';
  }

  @override
  String get all => 'All';

  @override
  String get tipsDisclaimer =>
      'These are ideas, not rules. What she tells you always wins.';

  @override
  String get noTips => 'No tips here.';

  @override
  String get backToTips => 'Back to tips';

  @override
  String get showHidden => 'Show hidden tips';

  @override
  String get anyTime => 'Any time';

  @override
  String get helpful => 'Helpful';

  @override
  String get hideTip => 'Not for us (hide)';

  @override
  String get tipHidden => 'Tip hidden';

  @override
  String get notesIntro =>
      'Things she told you or you learned: what helps, what doesn\'t, favourite comfort food. Tag a note with phases and it shows up on the Today screen at the right time.';

  @override
  String get examples => 'Examples';

  @override
  String get examplesBody =>
      '• Period: doesn\'t want to be touched on day 1, but loves a heat pad\n• PMS: craves salty chips, NOT sweets\n• Always: favourite flowers are peonies\n• Follicular: loves hiking dates';

  @override
  String get always => 'Always';

  @override
  String get addNote => 'Add note';

  @override
  String get newNote => 'New note';

  @override
  String get editNote => 'Edit note';

  @override
  String get noteHint => 'e.g. Wants space on day 1';

  @override
  String get showDuring => 'Show during (none = always)';

  @override
  String get aboutHer => 'About her';

  @override
  String get name => 'Name';

  @override
  String get notSet => 'Not set';

  @override
  String get herName => 'Her name';

  @override
  String get typicalPeriodLength => 'Typical period length';

  @override
  String learnedPeriodLength(int n) {
    return 'Learned: $n days (from logged end dates)';
  }

  @override
  String defaultPeriodLength(int n) {
    return '$n days. Log end dates to learn it automatically';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get notifDiscreet => 'Notification text stays discreet';

  @override
  String get notifPeriodSoon => 'Period coming soon';

  @override
  String notifPeriodSoonSub(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days before the most likely start',
      one: '1 day before the most likely start',
    );
    return '$_temp0';
  }

  @override
  String get leadDays => 'Lead days';

  @override
  String get notifPms => 'PMS window starting';

  @override
  String get notifDaily => 'Daily tip';

  @override
  String get notifFertile => 'Fertile window';

  @override
  String get notifFertileSub => 'Informational only, not contraception';

  @override
  String get notifTime => 'Notification time';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Phone language';

  @override
  String get dataHeader => 'Your data (stored only on this phone)';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get exportSub => 'Save or send a JSON file';

  @override
  String get importBackup => 'Import backup';

  @override
  String get importSub => 'Replaces current data';

  @override
  String get deleteAll => 'Delete all data';

  @override
  String get deleteConfirmTitle => 'Delete everything?';

  @override
  String get deleteConfirmBody =>
      'All dates, notes, logs and settings will be erased from this phone. This can\'t be undone.';

  @override
  String get about => 'About';

  @override
  String aboutBody(String app) {
    return '$app estimates cycles statistically from the dates you enter. It is not medical advice and must not be used as contraception. Every person is different, so talk with her. If her cycles are often shorter than 21 or longer than 35 days, or very painful, suggest seeing a doctor.';
  }

  @override
  String backupSubject(String app) {
    return '$app backup';
  }

  @override
  String imported(int periods, int notes) {
    return 'Imported $periods periods and $notes notes';
  }

  @override
  String invalidBackup(String app) {
    return 'That file isn\'t a valid $app backup';
  }

  @override
  String notifHeadsUp(int n, int range) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          'Heads-up for about $n days from now (±$range). Open the app for details.',
      one:
          'Heads-up for about 1 day from now (±$range). Open the app for details.',
    );
    return '$_temp0';
  }

  @override
  String get notifSensitive =>
      'A sensitive week likely starts now. Extra patience and kindness go a long way.';

  @override
  String get notifWindow => 'A new window starts around now. Open for details.';

  @override
  String notifTip(String title) {
    return 'Tip: $title';
  }

  @override
  String get guidePhases => 'The phases';

  @override
  String get typicalCycle => 'A typical 28-day cycle';

  @override
  String dayN(int n) {
    return 'Day $n';
  }

  @override
  String get gWhat => 'What\'s happening';

  @override
  String get gFeel => 'How she may feel';

  @override
  String get gHelp => 'How to help';

  @override
  String get gAvoid => 'Better avoid';

  @override
  String get comingUp => 'Coming up';

  @override
  String get evPms => 'PMS window starts';

  @override
  String get evPeriod => 'Period expected';

  @override
  String get evFertile => 'Fertile window starts';

  @override
  String get evOvulation => 'Estimated ovulation';

  @override
  String get relToday => 'today';

  @override
  String get relTomorrow => 'tomorrow';

  @override
  String relInDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'in $n days',
      one: 'in 1 day',
    );
    return '$_temp0';
  }

  @override
  String dayOfCycle(int day, int len) {
    return 'Day $day of ~$len';
  }

  @override
  String get otherDay => 'Started on…';

  @override
  String get whenDidItStart => 'When did it start?';

  @override
  String loggedStartOn(String date) {
    return 'Logged a start on $date.';
  }

  @override
  String get anotherTip => 'Another tip';

  @override
  String get quickIdeas => 'Quick ideas';

  @override
  String get sugSpace => 'Wants space';

  @override
  String get sugHugs => 'Loves hugs';

  @override
  String get sugSweet => 'Craves sweets';

  @override
  String get sugSalty => 'Craves salty food';

  @override
  String get sugHeat => 'A heat pad helps';

  @override
  String get sugComfortFood => 'Comfort food: ';

  @override
  String get sugFlowers => 'Favourite flowers: ';

  @override
  String get privacy => 'Privacy';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockSub =>
      'Ask for fingerprint, face or PIN when opening. Also hides the app\'s content in recent apps.';

  @override
  String get appLockUnavailable => 'Set up a screen lock on this phone first.';

  @override
  String get unlock => 'Unlock';

  @override
  String unlockReason(String app) {
    return 'Unlock $app';
  }
}
