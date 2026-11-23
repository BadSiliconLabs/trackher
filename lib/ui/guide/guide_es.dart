import 'package:material_ui/material_ui.dart';

import '../../engine/phases.dart';
import 'guide_content.dart';

const guideEs = GuideContent(
  intro:
      "Un ciclo menstrual va desde el primer día de una regla hasta el día anterior a la siguiente. "
      "Suele durar entre 21 y 35 días (28 es solo una media). A lo largo del ciclo las hormonas suben y bajan, "
      "y eso puede cambiar la energía, el ánimo, el apetito, el sueño y cómo se siente su cuerpo.\n\n"
      "No todas sienten cada fase con la misma intensidad, y algunas apenas la notan. Usa esto como base "
      "y da siempre prioridad a lo que ella te diga.",
  cycleNote:
      "En los ciclos más largos o más cortos es sobre todo la primera mitad la que se alarga o se acorta. "
      "El tiempo entre la ovulación y la siguiente regla se mantiene en unos 14 días.",
  phases: _phases,
  general: _general,
);

const _phases = [
  PhaseGuide(
    phase: Phase.period,
    when: "Días 1–5 (normalmente de 3 a 7 días)",
    body:
        "El revestimiento del útero se desprende porque no ha habido embarazo. Los estrógenos y la progesterona "
        "están en su nivel más bajo. Las prostaglandinas hacen que el útero se contraiga y causan los cólicos. "
        "El sangrado suele ser más abundante el primer o segundo día.",
    feel:
        "Cólicos en la barriga o la parte baja de la espalda, cansancio, poca energía y a veces dolor de cabeza, "
        "náuseas o tránsito intestinal alterado. A menudo el ánimo mejora un poco cuando empieza el sangrado, "
        "porque el síndrome premenstrual tiende a aliviarse.",
    help: [
      "Calor: una bolsa de agua caliente o una almohadilla térmica en la barriga o la espalda.",
      "Comida caliente y rica en hierro (carne roja, lentejas, espinacas) y mucha agua.",
      "Encárgate tú de las tareas de casa y mantén los planes tranquilos.",
      "Pregúntale si quiere cercanía o espacio, y respeta la respuesta.",
      "Asegúrate de que haya compresas, tampones y analgésicos en casa.",
    ],
    avoid: [
      "Bromas o comentarios sobre la regla o su humor.",
      "Insistir en grandes salidas o actividades intensas.",
      "Hacer un drama por manchas o \"accidentes\".",
    ],
  ),
  PhaseGuide(
    phase: Phase.follicular,
    when: "Aprox. días 6–9 (después de la regla hasta la ventana fértil)",
    body:
        "El cerebro libera FSH, que hace crecer los folículos de los ovarios. Estos producen estrógenos, que "
        "suben de forma constante. Es la parte \"elástica\" del ciclo: en los ciclos largos esta fase dura más.",
    feel:
        "La energía, el ánimo, la seguridad y la concentración suelen aumentar. Muchas se sienten más sociables, "
        "curiosas y motivadas, y duermen mejor.",
    help: [
      "Planea cosas nuevas: un viaje, una clase, una excursión, un restaurante nuevo.",
      "Citas activas y deporte juntos.",
      "Buen momento para conversaciones importantes y para hacer planes.",
    ],
    avoid: ["Dar por hecho que tiene energía infinita: cada persona es diferente."],
  ),
  PhaseGuide(
    phase: Phase.fertile,
    when: "Aprox. días 9–15 (de 5 días antes de la ovulación a 1 día después)",
    body:
        "Los estrógenos alcanzan su máximo y un pico de LH provoca la ovulación. Los espermatozoides pueden "
        "sobrevivir hasta unos 5 días, así que la ventana fértil empieza antes de la propia ovulación.",
    feel:
        "Suele ser el pico de energía, seguridad y deseo. Algunas notan un flujo más claro y elástico. "
        "Muchas se sienten más atractivas y extrovertidas.",
    help: [
      "Planea una cita romántica de verdad.",
      "Coquetea, hazle cumplidos, sé cariñoso.",
      "Di que sí a sus ideas espontáneas.",
      "Hablad abiertamente de anticoncepción: esta app no es un método anticonceptivo.",
    ],
    avoid: ["Confiar en la estimación de la app para evitar un embarazo."],
  ),
  PhaseGuide(
    phase: Phase.ovulation,
    when: "Alrededor del día 14 (unos 14 días antes de la siguiente regla)",
    body:
        "Un óvulo sale de un ovario y vive unas 12–24 horas. El día exacto varía de un ciclo a otro, "
        "por eso la app lo muestra como una estimación.",
    feel:
        "Normalmente parecido a la ventana fértil. Algunas sienten un dolor breve y agudo en un lado del bajo "
        "vientre (llamado mittelschmerz), algo de hinchazón o un ligero manchado.",
    help: [
      "Si tiene dolor de ovulación: calor y comprensión.",
      "Si no, disfrutad juntos de estos días llenos de energía.",
    ],
    avoid: ["Restar importancia a un dolor fuerte en un lado: merece una visita al médico."],
  ),
  PhaseGuide(
    phase: Phase.luteal,
    when: "Aprox. días 16–22 (después de la ovulación hasta la fase premenstrual)",
    body:
        "El folículo vacío se convierte en el cuerpo lúteo y produce progesterona, que sube y calma el cuerpo. "
        "La temperatura corporal aumenta ligeramente. Esta fase es bastante fija: unos 12–14 días en total.",
    feel:
        "La energía baja poco a poco. Puede querer más descanso, calma y comodidad, y tener más hambre de lo "
        "normal. El sueño puede volverse más ligero.",
    help: [
      "Cambia los planes intensos por otros tranquilos: cocinar, pelis, paseos.",
      "Comidas saciantes con hidratos complejos y algo de magnesio (frutos secos, semillas, chocolate negro).",
      "Más paciencia: las pequeñas cosas pueden molestarle más.",
      "Revisa las provisiones con tiempo: la regla llega en una o dos semanas.",
    ],
    avoid: ["Tomarte como algo personal que tenga menos paciencia.", "Discusiones a altas horas de la noche."],
  ),
  PhaseGuide(
    phase: Phase.pms,
    when: "Aprox. los últimos 6 días antes de la regla",
    body:
        "Si no hay embarazo, la progesterona y los estrógenos caen rápidamente. Esa caída puede afectar a la "
        "serotonina y causar síntomas premenstruales (síndrome premenstrual). Unas 3 de cada 4 personas notan "
        "algún síntoma; unas pocas tienen una forma grave (TDPM) que merece ayuda médica.",
    feel:
        "Irritabilidad, tristeza o ansiedad, cambios de humor, antojos (dulce o salado), hinchazón, pechos "
        "sensibles, dolor de cabeza, cansancio, mal sueño, granitos.",
    help: [
      "Escucha sin intentar arreglarlo todo, y pregunta antes de dar consejos.",
      "Ten a mano sus snacks y comidas reconfortantes favoritas.",
      "Ofrécele un abrazo, un baño o una noche tranquila; dale espacio si lo quiere.",
      "Mantén la agenda ligera y, si puedes, aplaza los temas difíciles.",
      "Tranquilízala: \"Estoy de tu lado.\"",
    ],
    avoid: [
      "Decir \"¿Te va a venir la regla?\" cuando está molesta. Sus sentimientos son reales.",
      "Comentar sobre su cuerpo o lo que come.",
      "Demasiada cafeína y alcohol para los dos: pueden empeorar los síntomas.",
    ],
  ),
];

const _general = [
  GeneralGuide(
    Icons.straighten_outlined,
    "¿Qué es normal?",
    "Duración del ciclo: de 21 a 35 días en adultas, y puede variar hasta unos 7 días de un ciclo a otro.\n"
        "Duración de la regla: de 2 a 7 días.\n"
        "Pérdida de sangre: normalmente 30–80 ml en total, más abundante los primeros días.\n\n"
        "El estrés, las enfermedades, los viajes, el sueño, los cambios de peso, el deporte y los anticonceptivos "
        "hormonales pueden desplazar el ciclo.",
  ),
  GeneralGuide(
    Icons.local_hospital_outlined,
    "Cuándo sugerir un médico",
    "Anímala con tacto a hacerse una revisión (y ofrécete a acompañarla) si:\n"
        "- los ciclos suelen ser más cortos de 21 o más largos de 35 días, o muy imprevisibles\n"
        "- la regla se retrasa 3 meses (descartado un embarazo)\n"
        "- el dolor le impide hacer su vida normal o los analgésicos no ayudan\n"
        "- empapa una compresa o un tampón cada hora, o el sangrado dura más de 7 días\n"
        "- los síntomas de ánimo antes de la regla son muy fuertes (posible TDPM)\n"
        "- hay sangrado entre reglas o después de las relaciones.",
  ),
  GeneralGuide(
    Icons.medication_outlined,
    "Anticoncepción hormonal",
    "La píldora, el parche, el anillo, el DIU hormonal o el implante cambian el ciclo. Con la píldora combinada, "
        "el sangrado mensual es un \"sangrado por deprivación\" durante la pausa y no hay ovulación, así que la "
        "ventana fértil y muchos efectos de las fases no se aplican. Aun así puedes registrar el sangrado, y los "
        "consejos de confort siguen ayudando.",
  ),
  GeneralGuide(
    Icons.insights_outlined,
    "Cómo funciona la previsión",
    "Cada inicio registrado enseña a la app la duración media de su ciclo y cuánto varía. Las fechas no tienen "
        "que ser consecutivas: los huecos de varios meses se reconocen automáticamente. La previsión muestra el "
        "día más probable y un rango; cuantas más fechas registres, más se estrecha. Es una estimación, no consejo "
        "médico, y no es un anticonceptivo.",
  ),
];
