import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it'),
  ];

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navForecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get navForecast;

  /// No description provided for @navTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get navTips;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navNotes;

  /// No description provided for @titleNotes.
  ///
  /// In en, this message translates to:
  /// **'Her notes'**
  String get titleNotes;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guide;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @herDefault.
  ///
  /// In en, this message translates to:
  /// **'her'**
  String get herDefault;

  /// No description provided for @herDefaultCap.
  ///
  /// In en, this message translates to:
  /// **'She'**
  String get herDefaultCap;

  /// No description provided for @phasePeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get phasePeriod;

  /// No description provided for @phaseFollicular.
  ///
  /// In en, this message translates to:
  /// **'Follicular'**
  String get phaseFollicular;

  /// No description provided for @phaseFertile.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get phaseFertile;

  /// No description provided for @phaseOvulation.
  ///
  /// In en, this message translates to:
  /// **'Ovulation'**
  String get phaseOvulation;

  /// No description provided for @phaseLuteal.
  ///
  /// In en, this message translates to:
  /// **'Luteal'**
  String get phaseLuteal;

  /// No description provided for @phasePms.
  ///
  /// In en, this message translates to:
  /// **'PMS'**
  String get phasePms;

  /// No description provided for @blurbPeriod.
  ///
  /// In en, this message translates to:
  /// **'Her period. Energy can be low and cramps are common. Comfort, warmth and patience help most.'**
  String get blurbPeriod;

  /// No description provided for @blurbFollicular.
  ///
  /// In en, this message translates to:
  /// **'Hormones are rising and energy and mood often improve. A good time for plans and adventures.'**
  String get blurbFollicular;

  /// No description provided for @blurbFertile.
  ///
  /// In en, this message translates to:
  /// **'Around ovulation. Often the time of highest energy, confidence and libido.'**
  String get blurbFertile;

  /// No description provided for @blurbOvulation.
  ///
  /// In en, this message translates to:
  /// **'Estimated ovulation day. Some people feel a twinge or mild pain on one side.'**
  String get blurbOvulation;

  /// No description provided for @blurbLuteal.
  ///
  /// In en, this message translates to:
  /// **'Progesterone rises. She may be more tired or want more calm and coziness.'**
  String get blurbLuteal;

  /// No description provided for @blurbPms.
  ///
  /// In en, this message translates to:
  /// **'The days before her period. Mood swings, cravings, bloating and irritability are common. Be extra kind.'**
  String get blurbPms;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get catComfort;

  /// No description provided for @catAffection.
  ///
  /// In en, this message translates to:
  /// **'Affection'**
  String get catAffection;

  /// No description provided for @catSpace.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get catSpace;

  /// No description provided for @catPlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get catPlans;

  /// No description provided for @catWords.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get catWords;

  /// No description provided for @catPractical.
  ///
  /// In en, this message translates to:
  /// **'Practical'**
  String get catPractical;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get moodNeutral;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// No description provided for @moodIrritable.
  ///
  /// In en, this message translates to:
  /// **'Irritable'**
  String get moodIrritable;

  /// No description provided for @moodTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get moodTired;

  /// No description provided for @symCramps.
  ///
  /// In en, this message translates to:
  /// **'cramps'**
  String get symCramps;

  /// No description provided for @symHeadache.
  ///
  /// In en, this message translates to:
  /// **'headache'**
  String get symHeadache;

  /// No description provided for @symFatigue.
  ///
  /// In en, this message translates to:
  /// **'fatigue'**
  String get symFatigue;

  /// No description provided for @symBloating.
  ///
  /// In en, this message translates to:
  /// **'bloating'**
  String get symBloating;

  /// No description provided for @symAcne.
  ///
  /// In en, this message translates to:
  /// **'acne'**
  String get symAcne;

  /// No description provided for @symCravings.
  ///
  /// In en, this message translates to:
  /// **'cravings'**
  String get symCravings;

  /// No description provided for @symBackPain.
  ///
  /// In en, this message translates to:
  /// **'back pain'**
  String get symBackPain;

  /// No description provided for @symTenderBreasts.
  ///
  /// In en, this message translates to:
  /// **'tender breasts'**
  String get symTenderBreasts;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @obTagline.
  ///
  /// In en, this message translates to:
  /// **'Know where she is in her cycle and get practical ideas to support her: when to bring snacks, when to give space, when to plan a big date.'**
  String get obTagline;

  /// No description provided for @obRespect.
  ///
  /// In en, this message translates to:
  /// **'Every person is different, and she is the expert on herself. This works best when she knows about it and helps you fill it in.'**
  String get obRespect;

  /// No description provided for @obPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this phone. No account, no cloud. Not medical advice and not contraception.'**
  String get obPrivacy;

  /// No description provided for @obStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start'**
  String get obStart;

  /// No description provided for @obNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s her name?'**
  String get obNameTitle;

  /// No description provided for @obNameHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Only used to make the text more personal.'**
  String get obNameHint;

  /// No description provided for @obNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Her name or nickname'**
  String get obNameLabel;

  /// No description provided for @obDatesTitle.
  ///
  /// In en, this message translates to:
  /// **'When did her periods start?'**
  String get obDatesTitle;

  /// No description provided for @obDatesHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the first day of any periods you remember. One is enough. More dates (even months apart) make the forecast more accurate.'**
  String get obDatesHint;

  /// No description provided for @obPickOne.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one date'**
  String get obPickOne;

  /// No description provided for @obDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Done (1 date)} other{Done ({count} dates)}}'**
  String obDone(int count);

  /// No description provided for @obSkip.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know yet, skip'**
  String get obSkip;

  /// No description provided for @bannerStale.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t logged a period in a while, so the forecast assumes cycles kept going. Log the latest start for better accuracy.'**
  String get bannerStale;

  /// No description provided for @bannerLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get bannerLog;

  /// No description provided for @bannerSuspicious.
  ///
  /// In en, this message translates to:
  /// **'Some logged starts are less than 15 days apart and were ignored (spotting or a duplicate?).'**
  String get bannerSuspicious;

  /// No description provided for @bannerReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get bannerReview;

  /// No description provided for @cycleDay.
  ///
  /// In en, this message translates to:
  /// **'Cycle day {n}'**
  String cycleDay(int n);

  /// No description provided for @likelyPhase.
  ///
  /// In en, this message translates to:
  /// **'Likely: {phase}'**
  String likelyPhase(String phase);

  /// No description provided for @aboutPhase.
  ///
  /// In en, this message translates to:
  /// **'About this phase'**
  String get aboutPhase;

  /// No description provided for @anyDayNow.
  ///
  /// In en, this message translates to:
  /// **'Period could start any day now'**
  String get anyDayNow;

  /// No description provided for @nextIn.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Next period in ~1 day} other{Next period in ~{n} days}}'**
  String nextIn(int n);

  /// No description provided for @startsToday.
  ///
  /// In en, this message translates to:
  /// **'Period most likely starts today'**
  String get startsToday;

  /// No description provided for @probablyStarted.
  ///
  /// In en, this message translates to:
  /// **'Period probably started'**
  String get probablyStarted;

  /// No description provided for @mostLikelyRange.
  ///
  /// In en, this message translates to:
  /// **'Most likely {date} · 80% between {from} and {to}'**
  String mostLikelyRange(String date, String from, String to);

  /// No description provided for @loggedToday.
  ///
  /// In en, this message translates to:
  /// **'Logged today'**
  String get loggedToday;

  /// No description provided for @periodStartedToday.
  ///
  /// In en, this message translates to:
  /// **'Period started today'**
  String get periodStartedToday;

  /// No description provided for @periodEnded.
  ///
  /// In en, this message translates to:
  /// **'Period ended'**
  String get periodEnded;

  /// No description provided for @loggedSnack.
  ///
  /// In en, this message translates to:
  /// **'Logged. Forecast updated. Be extra sweet to {name} today.'**
  String loggedSnack(String name);

  /// No description provided for @nextTwoWeeks.
  ///
  /// In en, this message translates to:
  /// **'Next two weeks'**
  String get nextTwoWeeks;

  /// No description provided for @remember.
  ///
  /// In en, this message translates to:
  /// **'Remember'**
  String get remember;

  /// No description provided for @allNotes.
  ///
  /// In en, this message translates to:
  /// **'All notes'**
  String get allNotes;

  /// No description provided for @todaysTip.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tip'**
  String get todaysTip;

  /// No description provided for @moreTips.
  ///
  /// In en, this message translates to:
  /// **'More tips'**
  String get moreTips;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No dates yet'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Log the first day of one of her periods (on the Calendar tab, or tap below if it started today) and the forecast appears.'**
  String get emptyBody;

  /// No description provided for @calHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to log or edit a period, mood or symptoms.'**
  String get calHint;

  /// No description provided for @loggedPeriods.
  ///
  /// In en, this message translates to:
  /// **'Logged periods ({n})'**
  String loggedPeriods(int n);

  /// No description provided for @noPeriodsYet.
  ///
  /// In en, this message translates to:
  /// **'None yet. Tap the day her last period started.'**
  String get noPeriodsYet;

  /// No description provided for @nDays.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 day} other{{n} days}}'**
  String nDays(int n);

  /// No description provided for @endNotLogged.
  ///
  /// In en, this message translates to:
  /// **'end not logged'**
  String get endNotLogged;

  /// No description provided for @daysAfterPrevious.
  ///
  /// In en, this message translates to:
  /// **'{n} days after previous'**
  String daysAfterPrevious(int n);

  /// No description provided for @legendLogged.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get legendLogged;

  /// No description provided for @legendPredicted.
  ///
  /// In en, this message translates to:
  /// **'Predicted (shade = probability)'**
  String get legendPredicted;

  /// No description provided for @chanceOfPeriod.
  ///
  /// In en, this message translates to:
  /// **'{pct}% chance of period'**
  String chanceOfPeriod(int pct);

  /// No description provided for @futureDay.
  ///
  /// In en, this message translates to:
  /// **'This day is in the future. You can log it once it happens.'**
  String get futureDay;

  /// No description provided for @periodStartedThisDay.
  ///
  /// In en, this message translates to:
  /// **'Period started this day'**
  String get periodStartedThisDay;

  /// No description provided for @firstDayFor.
  ///
  /// In en, this message translates to:
  /// **'First day of bleeding for {name}'**
  String firstDayFor(String name);

  /// No description provided for @periodEndedThisDay.
  ///
  /// In en, this message translates to:
  /// **'Period ended this day'**
  String get periodEndedThisDay;

  /// No description provided for @periodEndHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Helps learn her period length'**
  String get periodEndHint;

  /// No description provided for @endedOn.
  ///
  /// In en, this message translates to:
  /// **'Ended {date} ({days})'**
  String endedOn(String date, String days);

  /// No description provided for @howWasShe.
  ///
  /// In en, this message translates to:
  /// **'How was she? (optional)'**
  String get howWasShe;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @needOneDate.
  ///
  /// In en, this message translates to:
  /// **'Log at least one period start to see the forecast.'**
  String get needOneDate;

  /// No description provided for @nextStartProbability.
  ///
  /// In en, this message translates to:
  /// **'Next start probability'**
  String get nextStartProbability;

  /// No description provided for @forecastSummary.
  ///
  /// In en, this message translates to:
  /// **'Most likely {date} ({pct}%). 80% chance between {from} and {to}.'**
  String forecastSummary(String date, int pct, String from, String to);

  /// No description provided for @rangeLine.
  ///
  /// In en, this message translates to:
  /// **'80%: {from80} – {to80} · 95%: {from95} – {to95}'**
  String rangeLine(String from80, String to80, String from95, String to95);

  /// No description provided for @chartToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get chartToday;

  /// No description provided for @modelLearned.
  ///
  /// In en, this message translates to:
  /// **'What the model learned'**
  String get modelLearned;

  /// No description provided for @avgCycle.
  ///
  /// In en, this message translates to:
  /// **'Average cycle'**
  String get avgCycle;

  /// No description provided for @daysValue.
  ///
  /// In en, this message translates to:
  /// **'{v} days'**
  String daysValue(String v);

  /// No description provided for @plusMinusDays.
  ///
  /// In en, this message translates to:
  /// **'± {v} days'**
  String plusMinusDays(String v);

  /// No description provided for @uncertainty.
  ///
  /// In en, this message translates to:
  /// **'± {v} uncertainty'**
  String uncertainty(String v);

  /// No description provided for @variation.
  ///
  /// In en, this message translates to:
  /// **'Cycle-to-cycle variation'**
  String get variation;

  /// No description provided for @periodLength.
  ///
  /// In en, this message translates to:
  /// **'Period length'**
  String get periodLength;

  /// No description provided for @learnedFromEnds.
  ///
  /// In en, this message translates to:
  /// **'learned from end dates'**
  String get learnedFromEnds;

  /// No description provided for @defaultFromSettings.
  ///
  /// In en, this message translates to:
  /// **'default (set in Settings)'**
  String get defaultFromSettings;

  /// No description provided for @dataUsed.
  ///
  /// In en, this message translates to:
  /// **'Data used'**
  String get dataUsed;

  /// No description provided for @intervals.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 interval} other{{n} intervals}}'**
  String intervals(int n);

  /// No description provided for @multiCycle.
  ///
  /// In en, this message translates to:
  /// **'{n} span multiple cycles (gaps in log, handled)'**
  String multiCycle(int n);

  /// No description provided for @fromStarts.
  ///
  /// In en, this message translates to:
  /// **'from {n} logged starts'**
  String fromStarts(int n);

  /// No description provided for @oneDateHint.
  ///
  /// In en, this message translates to:
  /// **'With one date, the forecast uses typical cycle statistics. Add another date to personalise it.'**
  String get oneDateHint;

  /// No description provided for @moreDatesHint.
  ///
  /// In en, this message translates to:
  /// **'Each extra logged start narrows the uncertainty.'**
  String get moreDatesHint;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How does this work?'**
  String get howItWorks;

  /// No description provided for @howItWorksBody.
  ///
  /// In en, this message translates to:
  /// **'Each cycle length is modelled as a bell curve (Gaussian) with an unknown average and spread. Starting from typical values (about 28.5 ± 3.5 days), the app updates its belief with every gap between your logged dates using Bayes\' rule. Gaps don\'t need to be consecutive: a 3-month gap is automatically recognised as about 3 cycles. Recent data counts more than old data.\n\nThe forecast mixes all plausible averages and spreads, so the uncertainty honestly grows for cycles further ahead. Not medical advice and not contraception.'**
  String get howItWorksBody;

  /// No description provided for @regUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get regUnknown;

  /// No description provided for @regVeryRegular.
  ///
  /// In en, this message translates to:
  /// **'very regular'**
  String get regVeryRegular;

  /// No description provided for @regRegular.
  ///
  /// In en, this message translates to:
  /// **'regular'**
  String get regRegular;

  /// No description provided for @regSomewhatIrregular.
  ///
  /// In en, this message translates to:
  /// **'somewhat irregular'**
  String get regSomewhatIrregular;

  /// No description provided for @regIrregular.
  ///
  /// In en, this message translates to:
  /// **'irregular'**
  String get regIrregular;

  /// No description provided for @phaseNow.
  ///
  /// In en, this message translates to:
  /// **'{phase} (now)'**
  String phaseNow(String phase);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @tipsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These are ideas, not rules. What she tells you always wins.'**
  String get tipsDisclaimer;

  /// No description provided for @noTips.
  ///
  /// In en, this message translates to:
  /// **'No tips here.'**
  String get noTips;

  /// No description provided for @backToTips.
  ///
  /// In en, this message translates to:
  /// **'Back to tips'**
  String get backToTips;

  /// No description provided for @showHidden.
  ///
  /// In en, this message translates to:
  /// **'Show hidden tips'**
  String get showHidden;

  /// No description provided for @anyTime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get anyTime;

  /// No description provided for @helpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get helpful;

  /// No description provided for @hideTip.
  ///
  /// In en, this message translates to:
  /// **'Not for us (hide)'**
  String get hideTip;

  /// No description provided for @tipHidden.
  ///
  /// In en, this message translates to:
  /// **'Tip hidden'**
  String get tipHidden;

  /// No description provided for @notesIntro.
  ///
  /// In en, this message translates to:
  /// **'Things she told you or you learned: what helps, what doesn\'t, favourite comfort food. Tag a note with phases and it shows up on the Today screen at the right time.'**
  String get notesIntro;

  /// No description provided for @examples.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get examples;

  /// No description provided for @examplesBody.
  ///
  /// In en, this message translates to:
  /// **'• Period: doesn\'t want to be touched on day 1, but loves a heat pad\n• PMS: craves salty chips, NOT sweets\n• Always: favourite flowers are peonies\n• Follicular: loves hiking dates'**
  String get examplesBody;

  /// No description provided for @always.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get always;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @newNote.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get newNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wants space on day 1'**
  String get noteHint;

  /// No description provided for @showDuring.
  ///
  /// In en, this message translates to:
  /// **'Show during (none = always)'**
  String get showDuring;

  /// No description provided for @aboutHer.
  ///
  /// In en, this message translates to:
  /// **'About her'**
  String get aboutHer;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @herName.
  ///
  /// In en, this message translates to:
  /// **'Her name'**
  String get herName;

  /// No description provided for @typicalPeriodLength.
  ///
  /// In en, this message translates to:
  /// **'Typical period length'**
  String get typicalPeriodLength;

  /// No description provided for @learnedPeriodLength.
  ///
  /// In en, this message translates to:
  /// **'Learned: {n} days (from logged end dates)'**
  String learnedPeriodLength(int n);

  /// No description provided for @defaultPeriodLength.
  ///
  /// In en, this message translates to:
  /// **'{n} days. Log end dates to learn it automatically'**
  String defaultPeriodLength(int n);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notifDiscreet.
  ///
  /// In en, this message translates to:
  /// **'Notification text stays discreet'**
  String get notifDiscreet;

  /// No description provided for @notifPeriodSoon.
  ///
  /// In en, this message translates to:
  /// **'Period coming soon'**
  String get notifPeriodSoon;

  /// No description provided for @notifPeriodSoonSub.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 day before the most likely start} other{{n} days before the most likely start}}'**
  String notifPeriodSoonSub(int n);

  /// No description provided for @leadDays.
  ///
  /// In en, this message translates to:
  /// **'Lead days'**
  String get leadDays;

  /// No description provided for @notifPms.
  ///
  /// In en, this message translates to:
  /// **'PMS window starting'**
  String get notifPms;

  /// No description provided for @notifDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily tip'**
  String get notifDaily;

  /// No description provided for @notifFertile.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get notifFertile;

  /// No description provided for @notifFertileSub.
  ///
  /// In en, this message translates to:
  /// **'Informational only, not contraception'**
  String get notifFertileSub;

  /// No description provided for @notifTime.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get notifTime;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get languageSystem;

  /// No description provided for @dataHeader.
  ///
  /// In en, this message translates to:
  /// **'Your data (stored only on this phone)'**
  String get dataHeader;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @exportSub.
  ///
  /// In en, this message translates to:
  /// **'Save or send a JSON file'**
  String get exportSub;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get importBackup;

  /// No description provided for @importSub.
  ///
  /// In en, this message translates to:
  /// **'Replaces current data'**
  String get importSub;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get deleteAll;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete everything?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All dates, notes, logs and settings will be erased from this phone. This can\'t be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'{app} estimates cycles statistically from the dates you enter. It is not medical advice and must not be used as contraception. Every person is different, so talk with her. If her cycles are often shorter than 21 or longer than 35 days, or very painful, suggest seeing a doctor.'**
  String aboutBody(String app);

  /// No description provided for @backupSubject.
  ///
  /// In en, this message translates to:
  /// **'{app} backup'**
  String backupSubject(String app);

  /// No description provided for @imported.
  ///
  /// In en, this message translates to:
  /// **'Imported {periods} periods and {notes} notes'**
  String imported(int periods, int notes);

  /// No description provided for @invalidBackup.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t a valid {app} backup'**
  String invalidBackup(String app);

  /// No description provided for @notifHeadsUp.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Heads-up for about 1 day from now (±{range}). Open the app for details.} other{Heads-up for about {n} days from now (±{range}). Open the app for details.}}'**
  String notifHeadsUp(int n, int range);

  /// No description provided for @notifSensitive.
  ///
  /// In en, this message translates to:
  /// **'A sensitive week likely starts now. Extra patience and kindness go a long way.'**
  String get notifSensitive;

  /// No description provided for @notifWindow.
  ///
  /// In en, this message translates to:
  /// **'A new window starts around now. Open for details.'**
  String get notifWindow;

  /// No description provided for @notifTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: {title}'**
  String notifTip(String title);

  /// No description provided for @guidePhases.
  ///
  /// In en, this message translates to:
  /// **'The phases'**
  String get guidePhases;

  /// No description provided for @typicalCycle.
  ///
  /// In en, this message translates to:
  /// **'A typical 28-day cycle'**
  String get typicalCycle;

  /// No description provided for @dayN.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String dayN(int n);

  /// No description provided for @gWhat.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening'**
  String get gWhat;

  /// No description provided for @gFeel.
  ///
  /// In en, this message translates to:
  /// **'How she may feel'**
  String get gFeel;

  /// No description provided for @gHelp.
  ///
  /// In en, this message translates to:
  /// **'How to help'**
  String get gHelp;

  /// No description provided for @gAvoid.
  ///
  /// In en, this message translates to:
  /// **'Better avoid'**
  String get gAvoid;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LEn();
    case 'es':
      return LEs();
    case 'it':
      return LIt();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
