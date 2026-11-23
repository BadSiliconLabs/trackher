// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class LIt extends L {
  LIt([String locale = 'it']) : super(locale);

  @override
  String get navToday => 'Oggi';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navForecast => 'Previsioni';

  @override
  String get navTips => 'Consigli';

  @override
  String get navNotes => 'Note';

  @override
  String get titleNotes => 'Note su di lei';

  @override
  String get guide => 'Guida';

  @override
  String get settings => 'Impostazioni';

  @override
  String get herDefault => 'lei';

  @override
  String get herDefaultCap => 'Lei';

  @override
  String get phasePeriod => 'Mestruazioni';

  @override
  String get phaseFollicular => 'Fase follicolare';

  @override
  String get phaseFertile => 'Finestra fertile';

  @override
  String get phaseOvulation => 'Ovulazione';

  @override
  String get phaseLuteal => 'Fase luteale';

  @override
  String get phasePms => 'Fase premestruale';

  @override
  String get blurbPeriod =>
      'Il ciclo mestruale. L\'energia può essere bassa e i crampi sono comuni. Comfort, calore e pazienza aiutano più di tutto.';

  @override
  String get blurbFollicular =>
      'Gli ormoni salgono e spesso energia e umore migliorano. Un buon momento per progetti e avventure.';

  @override
  String get blurbFertile =>
      'Intorno all\'ovulazione. Spesso il periodo con più energia, sicurezza e desiderio.';

  @override
  String get blurbOvulation =>
      'Giorno stimato dell\'ovulazione. Alcune persone sentono una fitta o un lieve dolore su un lato.';

  @override
  String get blurbLuteal =>
      'Il progesterone sale. Potrebbe essere più stanca o desiderare più calma e coccole.';

  @override
  String get blurbPms =>
      'I giorni prima del ciclo. Sbalzi d\'umore, voglie, gonfiore e irritabilità sono comuni. Sii ancora più gentile.';

  @override
  String get catFood => 'Cibo';

  @override
  String get catComfort => 'Comfort';

  @override
  String get catAffection => 'Affetto';

  @override
  String get catSpace => 'Spazio';

  @override
  String get catPlans => 'Programmi';

  @override
  String get catWords => 'Parole';

  @override
  String get catPractical => 'Pratico';

  @override
  String get moodHappy => 'Felice';

  @override
  String get moodNeutral => 'Neutra';

  @override
  String get moodSad => 'Triste';

  @override
  String get moodIrritable => 'Irritabile';

  @override
  String get moodTired => 'Stanca';

  @override
  String get symCramps => 'crampi';

  @override
  String get symHeadache => 'mal di testa';

  @override
  String get symFatigue => 'stanchezza';

  @override
  String get symBloating => 'gonfiore';

  @override
  String get symAcne => 'acne';

  @override
  String get symCravings => 'voglie';

  @override
  String get symBackPain => 'mal di schiena';

  @override
  String get symTenderBreasts => 'seno dolente';

  @override
  String get next => 'Avanti';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get undo => 'Annulla';

  @override
  String get obTagline =>
      'Sai in che fase del ciclo si trova e ricevi idee pratiche per starle vicino: quando portarle uno snack, quando lasciarle spazio, quando organizzare un appuntamento speciale.';

  @override
  String get obRespect =>
      'Ogni persona è diversa, e lei è l\'esperta di sé stessa. Funziona meglio se lei lo sa e ti aiuta a compilarlo.';

  @override
  String get obPrivacy =>
      'Tutto resta su questo telefono. Nessun account, nessun cloud. Non è un consiglio medico né un contraccettivo.';

  @override
  String get obStart => 'Iniziamo';

  @override
  String get obNameTitle => 'Come si chiama?';

  @override
  String get obNameHint =>
      'Facoltativo. Serve solo a rendere i testi più personali.';

  @override
  String get obNameLabel => 'Il suo nome o soprannome';

  @override
  String get obDatesTitle => 'Quando sono iniziati i suoi cicli?';

  @override
  String get obDatesHint =>
      'Tocca il primo giorno dei cicli che ricordi. Ne basta uno. Più date (anche a mesi di distanza) rendono la previsione più precisa.';

  @override
  String get obPickOne => 'Scegli almeno una data';

  @override
  String obDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fatto ($count date)',
      one: 'Fatto (1 data)',
    );
    return '$_temp0';
  }

  @override
  String get obSkip => 'Non lo so ancora, salta';

  @override
  String get bannerStale =>
      'Non registri un ciclo da un po\', quindi la previsione presume che i cicli siano continuati. Registra l\'ultimo inizio per una maggiore precisione.';

  @override
  String get bannerLog => 'Registra';

  @override
  String get bannerSuspicious =>
      'Alcuni inizi registrati distano meno di 15 giorni e sono stati ignorati (perdite o un doppione?).';

  @override
  String get bannerReview => 'Controlla';

  @override
  String cycleDay(int n) {
    return 'Giorno $n del ciclo';
  }

  @override
  String likelyPhase(String phase) {
    return 'Probabile: $phase';
  }

  @override
  String get aboutPhase => 'Info su questa fase';

  @override
  String get anyDayNow => 'Il ciclo potrebbe iniziare da un giorno all\'altro';

  @override
  String nextIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Prossimo ciclo tra ~$n giorni',
      one: 'Prossimo ciclo tra ~1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get startsToday => 'Il ciclo probabilmente inizia oggi';

  @override
  String get probablyStarted => 'Il ciclo è probabilmente iniziato';

  @override
  String mostLikelyRange(String date, String from, String to) {
    return 'Più probabile il $date · 80% tra il $from e il $to';
  }

  @override
  String get loggedToday => 'Registrato oggi';

  @override
  String get periodStartedToday => 'Il ciclo è iniziato oggi';

  @override
  String get periodEnded => 'Il ciclo è finito';

  @override
  String loggedSnack(String name) {
    return 'Registrato. Previsione aggiornata. Oggi sii ancora più dolce con $name.';
  }

  @override
  String get nextTwoWeeks => 'Prossime due settimane';

  @override
  String get remember => 'Ricorda';

  @override
  String get allNotes => 'Tutte le note';

  @override
  String get todaysTip => 'Il consiglio di oggi';

  @override
  String get moreTips => 'Altri consigli';

  @override
  String get emptyTitle => 'Ancora nessuna data';

  @override
  String get emptyBody =>
      'Registra il primo giorno di uno dei suoi cicli (nella scheda Calendario, oppure tocca qui sotto se è iniziato oggi) e comparirà la previsione.';

  @override
  String get calHint =>
      'Tocca un giorno per registrare o modificare ciclo, umore o sintomi.';

  @override
  String loggedPeriods(int n) {
    return 'Cicli registrati ($n)';
  }

  @override
  String get noPeriodsYet =>
      'Ancora nessuno. Tocca il giorno in cui è iniziato il suo ultimo ciclo.';

  @override
  String nDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n giorni',
      one: '1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get endNotLogged => 'fine non registrata';

  @override
  String daysAfterPrevious(int n) {
    return '$n giorni dopo il precedente';
  }

  @override
  String get legendLogged => 'Registrato';

  @override
  String get legendPredicted => 'Previsto (intensità = probabilità)';

  @override
  String chanceOfPeriod(int pct) {
    return '$pct% di probabilità di ciclo';
  }

  @override
  String get futureDay =>
      'Questo giorno è nel futuro. Potrai registrarlo quando arriverà.';

  @override
  String get periodStartedThisDay => 'Il ciclo è iniziato in questo giorno';

  @override
  String firstDayFor(String name) {
    return 'Primo giorno di flusso per $name';
  }

  @override
  String get periodEndedThisDay => 'Il ciclo è finito in questo giorno';

  @override
  String get periodEndHint =>
      'Facoltativo. Aiuta a imparare la durata del suo ciclo';

  @override
  String endedOn(String date, String days) {
    return 'Finito il $date ($days)';
  }

  @override
  String get howWasShe => 'Come stava? (facoltativo)';

  @override
  String get note => 'Nota';

  @override
  String get needOneDate =>
      'Registra almeno un inizio di ciclo per vedere la previsione.';

  @override
  String get nextStartProbability => 'Probabilità del prossimo inizio';

  @override
  String forecastSummary(String date, int pct, String from, String to) {
    return 'Più probabile il $date ($pct%). 80% di probabilità tra il $from e il $to.';
  }

  @override
  String rangeLine(String from80, String to80, String from95, String to95) {
    return '80%: $from80 – $to80 · 95%: $from95 – $to95';
  }

  @override
  String get chartToday => 'oggi';

  @override
  String get modelLearned => 'Cosa ha imparato il modello';

  @override
  String get avgCycle => 'Ciclo medio';

  @override
  String daysValue(String v) {
    return '$v giorni';
  }

  @override
  String plusMinusDays(String v) {
    return '± $v giorni';
  }

  @override
  String uncertainty(String v) {
    return '± $v di incertezza';
  }

  @override
  String get variation => 'Variazione tra un ciclo e l\'altro';

  @override
  String get periodLength => 'Durata delle mestruazioni';

  @override
  String get learnedFromEnds => 'appresa dalle date di fine';

  @override
  String get defaultFromSettings =>
      'predefinita (modificabile nelle Impostazioni)';

  @override
  String get dataUsed => 'Dati usati';

  @override
  String intervals(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n intervalli',
      one: '1 intervallo',
    );
    return '$_temp0';
  }

  @override
  String multiCycle(int n) {
    return '$n coprono più cicli (buchi nel registro, gestiti)';
  }

  @override
  String fromStarts(int n) {
    return 'da $n inizi registrati';
  }

  @override
  String get oneDateHint =>
      'Con una sola data la previsione usa statistiche tipiche. Aggiungi un\'altra data per personalizzarla.';

  @override
  String get moreDatesHint =>
      'Ogni inizio registrato in più riduce l\'incertezza.';

  @override
  String get howItWorks => 'Come funziona?';

  @override
  String get howItWorksBody =>
      'La durata di ogni ciclo è modellata come una curva a campana (gaussiana) con media e dispersione sconosciute. Partendo da valori tipici (circa 28,5 ± 3,5 giorni), l\'app aggiorna la sua stima con ogni intervallo tra le date registrate usando la regola di Bayes. Le date non devono essere consecutive: un intervallo di 3 mesi viene riconosciuto automaticamente come circa 3 cicli. I dati recenti contano più di quelli vecchi.\n\nLa previsione combina tutte le medie e dispersioni plausibili, quindi l\'incertezza cresce onestamente per i cicli più lontani. Non è un consiglio medico né un contraccettivo.';

  @override
  String get regUnknown => 'sconosciuto';

  @override
  String get regVeryRegular => 'molto regolare';

  @override
  String get regRegular => 'regolare';

  @override
  String get regSomewhatIrregular => 'abbastanza irregolare';

  @override
  String get regIrregular => 'irregolare';

  @override
  String phaseNow(String phase) {
    return '$phase (ora)';
  }

  @override
  String get all => 'Tutti';

  @override
  String get tipsDisclaimer =>
      'Sono idee, non regole. Quello che ti dice lei vale sempre di più.';

  @override
  String get noTips => 'Nessun consiglio qui.';

  @override
  String get backToTips => 'Torna ai consigli';

  @override
  String get showHidden => 'Mostra consigli nascosti';

  @override
  String get anyTime => 'Sempre';

  @override
  String get helpful => 'Utile';

  @override
  String get hideTip => 'Non fa per noi (nascondi)';

  @override
  String get tipHidden => 'Consiglio nascosto';

  @override
  String get notesIntro =>
      'Cose che ti ha detto o che hai imparato: cosa aiuta, cosa no, il suo cibo consolatorio preferito. Associa una nota alle fasi e comparirà nella schermata Oggi al momento giusto.';

  @override
  String get examples => 'Esempi';

  @override
  String get examplesBody =>
      '• Mestruazioni: il primo giorno non vuole essere toccata, ma adora la borsa dell\'acqua calda\n• Sindrome premestruale: ha voglia di patatine salate, NON di dolci\n• Sempre: i suoi fiori preferiti sono le peonie\n• Fase follicolare: adora le escursioni insieme';

  @override
  String get always => 'Sempre';

  @override
  String get addNote => 'Aggiungi nota';

  @override
  String get newNote => 'Nuova nota';

  @override
  String get editNote => 'Modifica nota';

  @override
  String get noteHint => 'es. Il primo giorno vuole stare per conto suo';

  @override
  String get showDuring => 'Mostra durante (nessuna = sempre)';

  @override
  String get aboutHer => 'Su di lei';

  @override
  String get name => 'Nome';

  @override
  String get notSet => 'Non impostato';

  @override
  String get herName => 'Il suo nome';

  @override
  String get typicalPeriodLength => 'Durata tipica delle mestruazioni';

  @override
  String learnedPeriodLength(int n) {
    return 'Appresa: $n giorni (dalle date di fine registrate)';
  }

  @override
  String defaultPeriodLength(int n) {
    return '$n giorni. Registra le date di fine per impararla automaticamente';
  }

  @override
  String get notifications => 'Notifiche';

  @override
  String get notifDiscreet => 'Il testo delle notifiche resta discreto';

  @override
  String get notifPeriodSoon => 'Ciclo in arrivo';

  @override
  String notifPeriodSoonSub(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n giorni prima dell\'inizio più probabile',
      one: '1 giorno prima dell\'inizio più probabile',
    );
    return '$_temp0';
  }

  @override
  String get leadDays => 'Giorni di anticipo';

  @override
  String get notifPms => 'Inizio della fase premestruale';

  @override
  String get notifDaily => 'Consiglio del giorno';

  @override
  String get notifFertile => 'Finestra fertile';

  @override
  String get notifFertileSub => 'Solo informativa, non è un contraccettivo';

  @override
  String get notifTime => 'Orario delle notifiche';

  @override
  String get appearance => 'Aspetto';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Lingua del telefono';

  @override
  String get dataHeader => 'I tuoi dati (salvati solo su questo telefono)';

  @override
  String get exportBackup => 'Esporta backup';

  @override
  String get exportSub => 'Salva o invia un file JSON';

  @override
  String get importBackup => 'Importa backup';

  @override
  String get importSub => 'Sostituisce i dati attuali';

  @override
  String get deleteAll => 'Elimina tutti i dati';

  @override
  String get deleteConfirmTitle => 'Eliminare tutto?';

  @override
  String get deleteConfirmBody =>
      'Tutte le date, le note, i registri e le impostazioni verranno cancellati da questo telefono. L\'operazione non si può annullare.';

  @override
  String get about => 'Informazioni';

  @override
  String aboutBody(String app) {
    return '$app stima i cicli statisticamente a partire dalle date che inserisci. Non è un consiglio medico e non va usata come contraccettivo. Ogni persona è diversa, quindi parlane con lei. Se i suoi cicli sono spesso più corti di 21 o più lunghi di 35 giorni, o molto dolorosi, suggeriscile di vedere un medico.';
  }

  @override
  String backupSubject(String app) {
    return 'Backup di $app';
  }

  @override
  String imported(int periods, int notes) {
    return 'Importati $periods cicli e $notes note';
  }

  @override
  String invalidBackup(String app) {
    return 'Questo file non è un backup valido di $app';
  }

  @override
  String notifHeadsUp(int n, int range) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          'Promemoria per tra circa $n giorni (±$range). Apri l\'app per i dettagli.',
      one:
          'Promemoria per tra circa 1 giorno (±$range). Apri l\'app per i dettagli.',
    );
    return '$_temp0';
  }

  @override
  String get notifSensitive =>
      'Probabilmente inizia una settimana delicata. Un po\' di pazienza e gentilezza in più fanno molto.';

  @override
  String get notifWindow =>
      'Una nuova finestra inizia più o meno ora. Apri per i dettagli.';

  @override
  String notifTip(String title) {
    return 'Consiglio: $title';
  }

  @override
  String get guidePhases => 'Le fasi';

  @override
  String get typicalCycle => 'Un ciclo tipico di 28 giorni';

  @override
  String dayN(int n) {
    return 'Giorno $n';
  }

  @override
  String get gWhat => 'Cosa succede';

  @override
  String get gFeel => 'Come potrebbe sentirsi';

  @override
  String get gHelp => 'Come aiutarla';

  @override
  String get gAvoid => 'Meglio evitare';

  @override
  String get comingUp => 'In arrivo';

  @override
  String get evPms => 'Inizia la fase premestruale';

  @override
  String get evPeriod => 'Ciclo previsto';

  @override
  String get evFertile => 'Inizia la finestra fertile';

  @override
  String get evOvulation => 'Ovulazione stimata';

  @override
  String get relToday => 'oggi';

  @override
  String get relTomorrow => 'domani';

  @override
  String relInDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'tra $n giorni',
      one: 'tra 1 giorno',
    );
    return '$_temp0';
  }

  @override
  String dayOfCycle(int day, int len) {
    return 'Giorno $day di ~$len';
  }

  @override
  String get otherDay => 'Iniziato il…';

  @override
  String get whenDidItStart => 'Quando è iniziato?';

  @override
  String loggedStartOn(String date) {
    return 'Inizio registrato il $date.';
  }

  @override
  String get anotherTip => 'Un altro consiglio';

  @override
  String get quickIdeas => 'Idee rapide';

  @override
  String get sugSpace => 'Vuole spazio';

  @override
  String get sugHugs => 'Adora gli abbracci';

  @override
  String get sugSweet => 'Ha voglia di dolci';

  @override
  String get sugSalty => 'Ha voglia di salato';

  @override
  String get sugHeat => 'La borsa dell\'acqua calda aiuta';

  @override
  String get sugComfortFood => 'Cibo consolatorio: ';

  @override
  String get sugFlowers => 'Fiori preferiti: ';

  @override
  String get privacy => 'Privacy';

  @override
  String get appLock => 'Blocco app';

  @override
  String get appLockSub =>
      'Chiede impronta, volto o PIN all\'apertura. Nasconde anche il contenuto dell\'app tra le app recenti.';

  @override
  String get appLockUnavailable =>
      'Prima imposta un blocco schermo su questo telefono.';

  @override
  String get unlock => 'Sblocca';

  @override
  String unlockReason(String app) {
    return 'Sblocca $app';
  }
}
