// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LEs extends L {
  LEs([String locale = 'es']) : super(locale);

  @override
  String get navToday => 'Hoy';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navForecast => 'Previsión';

  @override
  String get navTips => 'Consejos';

  @override
  String get navNotes => 'Notas';

  @override
  String get titleNotes => 'Notas sobre ella';

  @override
  String get guide => 'Guía';

  @override
  String get settings => 'Ajustes';

  @override
  String get herDefault => 'ella';

  @override
  String get herDefaultCap => 'Ella';

  @override
  String get phasePeriod => 'Menstruación';

  @override
  String get phaseFollicular => 'Fase folicular';

  @override
  String get phaseFertile => 'Ventana fértil';

  @override
  String get phaseOvulation => 'Ovulación';

  @override
  String get phaseLuteal => 'Fase lútea';

  @override
  String get phasePms => 'Fase premenstrual';

  @override
  String get blurbPeriod =>
      'Su regla. La energía puede estar baja y los cólicos son comunes. Lo que más ayuda es comodidad, calor y paciencia.';

  @override
  String get blurbFollicular =>
      'Las hormonas suben y la energía y el ánimo suelen mejorar. Buen momento para planes y aventuras.';

  @override
  String get blurbFertile =>
      'Alrededor de la ovulación. Suele ser el momento de más energía, seguridad y deseo.';

  @override
  String get blurbOvulation =>
      'Día estimado de ovulación. Algunas personas notan una punzada o un dolor leve en un lado.';

  @override
  String get blurbLuteal =>
      'Sube la progesterona. Puede estar más cansada o querer más calma y mimos.';

  @override
  String get blurbPms =>
      'Los días antes de la regla. Son comunes los cambios de humor, los antojos, la hinchazón y la irritabilidad. Sé aún más amable.';

  @override
  String get catFood => 'Comida';

  @override
  String get catComfort => 'Confort';

  @override
  String get catAffection => 'Cariño';

  @override
  String get catSpace => 'Espacio';

  @override
  String get catPlans => 'Planes';

  @override
  String get catWords => 'Palabras';

  @override
  String get catPractical => 'Práctico';

  @override
  String get moodHappy => 'Feliz';

  @override
  String get moodNeutral => 'Normal';

  @override
  String get moodSad => 'Triste';

  @override
  String get moodIrritable => 'Irritable';

  @override
  String get moodTired => 'Cansada';

  @override
  String get symCramps => 'cólicos';

  @override
  String get symHeadache => 'dolor de cabeza';

  @override
  String get symFatigue => 'cansancio';

  @override
  String get symBloating => 'hinchazón';

  @override
  String get symAcne => 'acné';

  @override
  String get symCravings => 'antojos';

  @override
  String get symBackPain => 'dolor de espalda';

  @override
  String get symTenderBreasts => 'pechos sensibles';

  @override
  String get next => 'Siguiente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get undo => 'Deshacer';

  @override
  String get obTagline =>
      'Sabe en qué fase de su ciclo está y recibe ideas prácticas para apoyarla: cuándo llevarle algo de picar, cuándo darle espacio, cuándo planear una cita especial.';

  @override
  String get obRespect =>
      'Cada persona es diferente, y ella es la experta en sí misma. Funciona mejor si ella lo sabe y te ayuda a rellenarlo.';

  @override
  String get obPrivacy =>
      'Todo se queda en este teléfono. Sin cuenta, sin nube. No es consejo médico ni un anticonceptivo.';

  @override
  String get obStart => 'Empecemos';

  @override
  String get obNameTitle => '¿Cómo se llama?';

  @override
  String get obNameHint =>
      'Opcional. Solo sirve para que los textos sean más personales.';

  @override
  String get obNameLabel => 'Su nombre o apodo';

  @override
  String get obDatesTitle => '¿Cuándo empezaron sus reglas?';

  @override
  String get obDatesHint =>
      'Toca el primer día de las reglas que recuerdes. Con una basta. Más fechas (aunque estén separadas por meses) hacen la previsión más precisa.';

  @override
  String get obPickOne => 'Elige al menos una fecha';

  @override
  String obDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Listo ($count fechas)',
      one: 'Listo (1 fecha)',
    );
    return '$_temp0';
  }

  @override
  String get obSkip => 'Aún no lo sé, saltar';

  @override
  String get bannerStale =>
      'Hace tiempo que no registras una regla, así que la previsión supone que los ciclos han continuado. Registra el último inicio para más precisión.';

  @override
  String get bannerLog => 'Registrar';

  @override
  String get bannerSuspicious =>
      'Algunos inicios registrados están a menos de 15 días y se han ignorado (¿manchado o un duplicado?).';

  @override
  String get bannerReview => 'Revisar';

  @override
  String cycleDay(int n) {
    return 'Día $n del ciclo';
  }

  @override
  String likelyPhase(String phase) {
    return 'Probable: $phase';
  }

  @override
  String get aboutPhase => 'Sobre esta fase';

  @override
  String get anyDayNow => 'La regla podría empezar cualquier día';

  @override
  String nextIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Próxima regla en ~$n días',
      one: 'Próxima regla en ~1 día',
    );
    return '$_temp0';
  }

  @override
  String get startsToday => 'Lo más probable es que la regla empiece hoy';

  @override
  String get probablyStarted => 'La regla probablemente ya empezó';

  @override
  String mostLikelyRange(String date, String from, String to) {
    return 'Lo más probable: $date · 80% entre $from y $to';
  }

  @override
  String get loggedToday => 'Registrado hoy';

  @override
  String get periodStartedToday => 'La regla empezó hoy';

  @override
  String get periodEnded => 'La regla terminó';

  @override
  String loggedSnack(String name) {
    return 'Registrado. Previsión actualizada. Hoy sé aún más cariñoso con $name.';
  }

  @override
  String get nextTwoWeeks => 'Próximas dos semanas';

  @override
  String get remember => 'Recuerda';

  @override
  String get allNotes => 'Todas las notas';

  @override
  String get todaysTip => 'Consejo del día';

  @override
  String get moreTips => 'Más consejos';

  @override
  String get emptyTitle => 'Aún no hay fechas';

  @override
  String get emptyBody =>
      'Registra el primer día de una de sus reglas (en la pestaña Calendario, o toca abajo si empezó hoy) y aparecerá la previsión.';

  @override
  String get calHint =>
      'Toca un día para registrar o editar la regla, el ánimo o los síntomas.';

  @override
  String loggedPeriods(int n) {
    return 'Reglas registradas ($n)';
  }

  @override
  String get noPeriodsYet =>
      'Todavía ninguna. Toca el día en que empezó su última regla.';

  @override
  String nDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get endNotLogged => 'fin no registrado';

  @override
  String daysAfterPrevious(int n) {
    return '$n días después de la anterior';
  }

  @override
  String get legendLogged => 'Registrada';

  @override
  String get legendPredicted => 'Prevista (intensidad = probabilidad)';

  @override
  String chanceOfPeriod(int pct) {
    return '$pct% de probabilidad de regla';
  }

  @override
  String get futureDay =>
      'Este día está en el futuro. Podrás registrarlo cuando llegue.';

  @override
  String get periodStartedThisDay => 'La regla empezó este día';

  @override
  String firstDayFor(String name) {
    return 'Primer día de sangrado de $name';
  }

  @override
  String get periodEndedThisDay => 'La regla terminó este día';

  @override
  String get periodEndHint =>
      'Opcional. Ayuda a aprender cuánto le dura la regla';

  @override
  String endedOn(String date, String days) {
    return 'Terminó el $date ($days)';
  }

  @override
  String get howWasShe => '¿Cómo estaba? (opcional)';

  @override
  String get note => 'Nota';

  @override
  String get needOneDate =>
      'Registra al menos un inicio de regla para ver la previsión.';

  @override
  String get nextStartProbability => 'Probabilidad del próximo inicio';

  @override
  String forecastSummary(String date, int pct, String from, String to) {
    return 'Lo más probable: $date ($pct%). 80% de probabilidad entre $from y $to.';
  }

  @override
  String rangeLine(String from80, String to80, String from95, String to95) {
    return '80%: $from80 – $to80 · 95%: $from95 – $to95';
  }

  @override
  String get chartToday => 'hoy';

  @override
  String get modelLearned => 'Lo que ha aprendido el modelo';

  @override
  String get avgCycle => 'Ciclo medio';

  @override
  String daysValue(String v) {
    return '$v días';
  }

  @override
  String plusMinusDays(String v) {
    return '± $v días';
  }

  @override
  String uncertainty(String v) {
    return '± $v de incertidumbre';
  }

  @override
  String get variation => 'Variación entre ciclos';

  @override
  String get periodLength => 'Duración de la regla';

  @override
  String get learnedFromEnds => 'aprendida de las fechas de fin';

  @override
  String get defaultFromSettings => 'predeterminada (se cambia en Ajustes)';

  @override
  String get dataUsed => 'Datos usados';

  @override
  String intervals(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n intervalos',
      one: '1 intervalo',
    );
    return '$_temp0';
  }

  @override
  String multiCycle(int n) {
    return '$n abarcan varios ciclos (huecos en el registro, gestionados)';
  }

  @override
  String fromStarts(int n) {
    return 'de $n inicios registrados';
  }

  @override
  String get oneDateHint =>
      'Con una sola fecha, la previsión usa estadísticas típicas. Añade otra fecha para personalizarla.';

  @override
  String get moreDatesHint =>
      'Cada inicio registrado de más reduce la incertidumbre.';

  @override
  String get howItWorks => '¿Cómo funciona?';

  @override
  String get howItWorksBody =>
      'La duración de cada ciclo se modela como una curva de campana (gaussiana) con media y dispersión desconocidas. Partiendo de valores típicos (unos 28,5 ± 3,5 días), la app actualiza su estimación con cada intervalo entre tus fechas registradas usando la regla de Bayes. Las fechas no tienen que ser consecutivas: un hueco de 3 meses se reconoce automáticamente como unos 3 ciclos. Los datos recientes cuentan más que los antiguos.\n\nLa previsión combina todas las medias y dispersiones plausibles, así que la incertidumbre crece honestamente para los ciclos más lejanos. No es consejo médico ni un anticonceptivo.';

  @override
  String get regUnknown => 'desconocido';

  @override
  String get regVeryRegular => 'muy regular';

  @override
  String get regRegular => 'regular';

  @override
  String get regSomewhatIrregular => 'algo irregular';

  @override
  String get regIrregular => 'irregular';

  @override
  String phaseNow(String phase) {
    return '$phase (ahora)';
  }

  @override
  String get all => 'Todos';

  @override
  String get tipsDisclaimer =>
      'Son ideas, no reglas. Lo que ella te diga siempre gana.';

  @override
  String get noTips => 'No hay consejos aquí.';

  @override
  String get backToTips => 'Volver a los consejos';

  @override
  String get showHidden => 'Mostrar consejos ocultos';

  @override
  String get anyTime => 'Siempre';

  @override
  String get helpful => 'Útil';

  @override
  String get hideTip => 'No es para nosotros (ocultar)';

  @override
  String get tipHidden => 'Consejo oculto';

  @override
  String get notesIntro =>
      'Cosas que te ha contado o que has aprendido: qué ayuda, qué no, su comida reconfortante favorita. Asocia una nota a fases y aparecerá en la pantalla Hoy en el momento justo.';

  @override
  String get examples => 'Ejemplos';

  @override
  String get examplesBody =>
      '• Menstruación: el primer día no quiere que la toquen, pero le encanta la bolsa de agua caliente\n• Síndrome premenstrual: se le antojan patatas fritas saladas, NO dulces\n• Siempre: sus flores favoritas son las peonías\n• Fase folicular: le encanta salir de excursión';

  @override
  String get always => 'Siempre';

  @override
  String get addNote => 'Añadir nota';

  @override
  String get newNote => 'Nueva nota';

  @override
  String get editNote => 'Editar nota';

  @override
  String get noteHint => 'p. ej. El primer día quiere espacio';

  @override
  String get showDuring => 'Mostrar durante (ninguna = siempre)';

  @override
  String get aboutHer => 'Sobre ella';

  @override
  String get name => 'Nombre';

  @override
  String get notSet => 'Sin definir';

  @override
  String get herName => 'Su nombre';

  @override
  String get typicalPeriodLength => 'Duración típica de la regla';

  @override
  String learnedPeriodLength(int n) {
    return 'Aprendida: $n días (de las fechas de fin registradas)';
  }

  @override
  String defaultPeriodLength(int n) {
    return '$n días. Registra las fechas de fin para aprenderla automáticamente';
  }

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notifDiscreet => 'El texto de las notificaciones es discreto';

  @override
  String get notifPeriodSoon => 'Regla en camino';

  @override
  String notifPeriodSoonSub(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n días antes del inicio más probable',
      one: '1 día antes del inicio más probable',
    );
    return '$_temp0';
  }

  @override
  String get leadDays => 'Días de antelación';

  @override
  String get notifPms => 'Inicio de la fase premenstrual';

  @override
  String get notifDaily => 'Consejo del día';

  @override
  String get notifFertile => 'Ventana fértil';

  @override
  String get notifFertileSub => 'Solo informativa, no es un anticonceptivo';

  @override
  String get notifTime => 'Hora de las notificaciones';

  @override
  String get appearance => 'Apariencia';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Idioma del teléfono';

  @override
  String get dataHeader => 'Tus datos (guardados solo en este teléfono)';

  @override
  String get exportBackup => 'Exportar copia de seguridad';

  @override
  String get exportSub => 'Guarda o envía un archivo JSON';

  @override
  String get importBackup => 'Importar copia de seguridad';

  @override
  String get importSub => 'Reemplaza los datos actuales';

  @override
  String get deleteAll => 'Eliminar todos los datos';

  @override
  String get deleteConfirmTitle => '¿Eliminar todo?';

  @override
  String get deleteConfirmBody =>
      'Todas las fechas, notas, registros y ajustes se borrarán de este teléfono. No se puede deshacer.';

  @override
  String get about => 'Información';

  @override
  String aboutBody(String app) {
    return '$app estima los ciclos estadísticamente a partir de las fechas que introduces. No es consejo médico y no debe usarse como anticonceptivo. Cada persona es diferente, así que habla con ella. Si sus ciclos suelen durar menos de 21 o más de 35 días, o son muy dolorosos, sugiérele ver a un médico.';
  }

  @override
  String backupSubject(String app) {
    return 'Copia de seguridad de $app';
  }

  @override
  String imported(int periods, int notes) {
    return 'Importadas $periods reglas y $notes notas';
  }

  @override
  String invalidBackup(String app) {
    return 'Ese archivo no es una copia de seguridad válida de $app';
  }

  @override
  String notifHeadsUp(int n, int range) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          'Aviso para dentro de $n días aprox. (±$range). Abre la app para ver los detalles.',
      one:
          'Aviso para dentro de 1 día aprox. (±$range). Abre la app para ver los detalles.',
    );
    return '$_temp0';
  }

  @override
  String get notifSensitive =>
      'Probablemente empieza una semana delicada. Un poco más de paciencia y amabilidad ayudan mucho.';

  @override
  String get notifWindow =>
      'Una nueva ventana empieza más o menos ahora. Abre para ver los detalles.';

  @override
  String notifTip(String title) {
    return 'Consejo: $title';
  }

  @override
  String get guidePhases => 'Las fases';

  @override
  String get typicalCycle => 'Un ciclo típico de 28 días';

  @override
  String dayN(int n) {
    return 'Día $n';
  }

  @override
  String get gWhat => 'Qué está pasando';

  @override
  String get gFeel => 'Cómo puede sentirse';

  @override
  String get gHelp => 'Cómo ayudar';

  @override
  String get gAvoid => 'Mejor evitar';

  @override
  String get comingUp => 'Próximamente';

  @override
  String get evPms => 'Empieza la fase premenstrual';

  @override
  String get evPeriod => 'Regla prevista';

  @override
  String get evFertile => 'Empieza la ventana fértil';

  @override
  String get evOvulation => 'Ovulación estimada';

  @override
  String get relToday => 'hoy';

  @override
  String get relTomorrow => 'mañana';

  @override
  String relInDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'en $n días',
      one: 'en 1 día',
    );
    return '$_temp0';
  }

  @override
  String dayOfCycle(int day, int len) {
    return 'Día $day de ~$len';
  }

  @override
  String get otherDay => 'Empezó el…';

  @override
  String get whenDidItStart => '¿Cuándo empezó?';

  @override
  String loggedStartOn(String date) {
    return 'Inicio registrado el $date.';
  }

  @override
  String get anotherTip => 'Otro consejo';

  @override
  String get quickIdeas => 'Ideas rápidas';

  @override
  String get sugSpace => 'Quiere espacio';

  @override
  String get sugHugs => 'Le encantan los abrazos';

  @override
  String get sugSweet => 'Se le antojan dulces';

  @override
  String get sugSalty => 'Se le antoja algo salado';

  @override
  String get sugHeat => 'La bolsa de agua caliente ayuda';

  @override
  String get sugComfortFood => 'Comida reconfortante: ';

  @override
  String get sugFlowers => 'Flores favoritas: ';

  @override
  String get privacy => 'Privacidad';

  @override
  String get appLock => 'Bloqueo de la app';

  @override
  String get appLockSub =>
      'Pide huella, cara o PIN al abrirla. También oculta el contenido de la app en las apps recientes.';

  @override
  String get appLockUnavailable =>
      'Primero configura un bloqueo de pantalla en este teléfono.';

  @override
  String get unlock => 'Desbloquear';

  @override
  String unlockReason(String app) {
    return 'Desbloquear $app';
  }
}
