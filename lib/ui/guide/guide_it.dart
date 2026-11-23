import 'package:material_ui/material_ui.dart';

import '../../engine/phases.dart';
import 'guide_content.dart';

const guideIt = GuideContent(
  intro:
      "Un ciclo mestruale va dal primo giorno di una mestruazione al giorno prima della successiva. "
      "Di solito dura tra 21 e 35 giorni (28 è solo una media). Nel corso del ciclo gli ormoni salgono e scendono, "
      "e questo può cambiare energia, umore, appetito, sonno e come si sente il suo corpo.\n\n"
      "Non tutte sentono ogni fase con la stessa intensità, e alcune la sentono appena. Usa queste informazioni "
      "come base, e dai sempre la precedenza a quello che ti dice lei.",
  cycleNote:
      "Nei cicli più lunghi o più corti è soprattutto la prima metà ad allungarsi o accorciarsi. "
      "Il tempo tra l'ovulazione e la mestruazione successiva resta di circa 14 giorni.",
  phases: _phases,
  general: _general,
);

const _phases = [
  PhaseGuide(
    phase: Phase.period,
    when: "Giorni 1–5 (di solito da 3 a 7 giorni)",
    body:
        "Il rivestimento dell'utero si sfalda perché non c'è stata una gravidanza. Estrogeni e progesterone sono "
        "al minimo. Le prostaglandine fanno contrarre l'utero e causano i crampi. Il flusso di solito è più "
        "abbondante nei primi uno o due giorni.",
    feel:
        "Crampi alla pancia o alla parte bassa della schiena, stanchezza, poca energia, a volte mal di testa, "
        "nausea o intestino irregolare. Spesso l'umore migliora un po' quando inizia il flusso, perché la "
        "sindrome premestruale tende ad attenuarsi.",
    help: [
      "Calore: una borsa dell'acqua calda o un cuscino termico sulla pancia o sulla schiena.",
      "Cibo caldo e ricco di ferro (carne rossa, lenticchie, spinaci) e tanta acqua.",
      "Occupati tu delle faccende e tieni i programmi tranquilli.",
      "Chiedile se vuole vicinanza o spazio, e rispetta la risposta.",
      "Assicurati che in casa ci siano assorbenti, tamponi e antidolorifici.",
    ],
    avoid: [
      "Battute o commenti sulle mestruazioni o sul suo umore.",
      "Insistere per grandi uscite o attività faticose.",
      "Fare storie per macchie o \"incidenti\".",
    ],
  ),
  PhaseGuide(
    phase: Phase.follicular,
    when: "Circa giorni 6–9 (dopo la mestruazione fino alla finestra fertile)",
    body:
        "Il cervello rilascia FSH, che fa crescere i follicoli nelle ovaie. Questi producono estrogeni, che "
        "salgono costantemente. È la parte \"elastica\" del ciclo: nei cicli lunghi questa fase dura di più.",
    feel:
        "Energia, umore, sicurezza e concentrazione di solito aumentano. Molte si sentono più socievoli, "
        "curiose e motivate, e dormono meglio.",
    help: [
      "Organizza cose nuove: un viaggio, un corso, un'escursione, un ristorante nuovo.",
      "Appuntamenti attivi e sport insieme.",
      "Un buon momento per discorsi importanti e per fare progetti.",
    ],
    avoid: ["Dare per scontato che abbia energia infinita: ogni persona è diversa."],
  ),
  PhaseGuide(
    phase: Phase.fertile,
    when: "Circa giorni 9–15 (da 5 giorni prima dell'ovulazione a 1 giorno dopo)",
    body:
        "Gli estrogeni raggiungono il picco e un'impennata di LH provoca l'ovulazione. Gli spermatozoi possono "
        "sopravvivere fino a circa 5 giorni, quindi la finestra fertile inizia prima dell'ovulazione stessa.",
    feel:
        "Spesso il picco di energia, sicurezza e desiderio. Alcune notano perdite più chiare ed elastiche. "
        "Molte si sentono più attraenti ed estroverse.",
    help: [
      "Organizza un vero appuntamento romantico.",
      "Flirta, falle complimenti, sii affettuoso.",
      "Di' di sì alle sue idee spontanee.",
      "Parlate apertamente di contraccezione: questa app non è un metodo contraccettivo.",
    ],
    avoid: ["Affidarti alla stima dell'app per evitare una gravidanza."],
  ),
  PhaseGuide(
    phase: Phase.ovulation,
    when: "Intorno al giorno 14 (circa 14 giorni prima della mestruazione successiva)",
    body:
        "Un ovulo viene rilasciato da un'ovaia e vive circa 12–24 ore. Il giorno esatto cambia da un ciclo "
        "all'altro, per questo l'app lo mostra come una stima.",
    feel:
        "Di solito simile alla finestra fertile. Alcune sentono un dolore breve e acuto su un lato del basso "
        "ventre (detto mittelschmerz), un leggero gonfiore o piccole perdite.",
    help: [
      "Se ha dolore da ovulazione: calore e comprensione.",
      "Altrimenti, godetevi insieme questi giorni pieni di energia.",
    ],
    avoid: ["Sottovalutare un dolore forte su un lato: vale la pena farlo vedere da un medico."],
  ),
  PhaseGuide(
    phase: Phase.luteal,
    when: "Circa giorni 16–22 (dopo l'ovulazione fino alla fase premestruale)",
    body:
        "Il follicolo vuoto diventa il corpo luteo e produce progesterone, che sale e calma il corpo. La "
        "temperatura corporea aumenta leggermente. Questa fase è abbastanza fissa: circa 12–14 giorni in totale.",
    feel:
        "L'energia cala lentamente. Potrebbe desiderare più riposo, calma e comfort, e avere più fame del solito. "
        "Il sonno può diventare più leggero.",
    help: [
      "Sostituisci i programmi intensi con quelli tranquilli: cucinare, film, passeggiate.",
      "Pasti sazianti con carboidrati complessi e un po' di magnesio (frutta secca, semi, cioccolato fondente).",
      "Più pazienza: le piccole cose potrebbero darle più fastidio.",
      "Controlla le scorte in anticipo: la mestruazione è tra una o due settimane.",
    ],
    avoid: ["Prendere sul personale un po' meno pazienza.", "Litigi a tarda notte."],
  ),
  PhaseGuide(
    phase: Phase.pms,
    when: "Circa gli ultimi 6 giorni prima della mestruazione",
    body:
        "Se non c'è una gravidanza, progesterone ed estrogeni calano rapidamente. Questo calo può influire sulla "
        "serotonina e causare i sintomi premestruali (sindrome premestruale). Circa 3 persone su 4 notano qualche "
        "sintomo; poche hanno una forma grave (PMDD) che merita un aiuto medico.",
    feel:
        "Irritabilità, tristezza o ansia, sbalzi d'umore, voglie (dolce o salato), gonfiore, seno dolente, "
        "mal di testa, stanchezza, sonno disturbato, brufoli.",
    help: [
      "Ascolta senza cercare di risolvere, e chiedi prima di dare consigli.",
      "Tieni pronti i suoi snack e cibi consolatori preferiti.",
      "Offrile un abbraccio, un bagno caldo o una serata tranquilla; lasciale spazio se lo vuole.",
      "Tieni l'agenda leggera e, se possibile, rimanda gli argomenti pesanti.",
      "Rassicurala: \"Sono dalla tua parte.\"",
    ],
    avoid: [
      "Dire \"Hai il ciclo?\" quando è arrabbiata. I suoi sentimenti sono reali.",
      "Commentare il suo corpo o quello che mangia.",
      "Troppa caffeina e alcol per entrambi: possono peggiorare i sintomi.",
    ],
  ),
];

const _general = [
  GeneralGuide(
    Icons.straighten_outlined,
    "Cosa è normale?",
    "Durata del ciclo: da 21 a 35 giorni negli adulti, e può variare fino a circa 7 giorni da un ciclo all'altro.\n"
        "Durata della mestruazione: da 2 a 7 giorni.\n"
        "Perdita di sangue: di solito 30–80 ml in tutto, più abbondante nei primi giorni.\n\n"
        "Stress, malattie, viaggi, sonno, variazioni di peso, sport e contraccettivi ormonali possono spostare il ciclo.",
  ),
  GeneralGuide(
    Icons.local_hospital_outlined,
    "Quando suggerire un medico",
    "Incoraggiala con delicatezza a fare un controllo (e offriti di accompagnarla) se:\n"
        "- i cicli sono spesso più corti di 21 o più lunghi di 35 giorni, o molto imprevedibili\n"
        "- la mestruazione è in ritardo di 3 mesi (esclusa una gravidanza)\n"
        "- il dolore le impedisce di fare le cose normali, o gli antidolorifici non aiutano\n"
        "- il flusso inzuppa un assorbente o un tampone ogni ora, o dura più di 7 giorni\n"
        "- i sintomi d'umore prima della mestruazione sono molto forti (possibile PMDD)\n"
        "- ci sono perdite di sangue tra un ciclo e l'altro o dopo i rapporti.",
  ),
  GeneralGuide(
    Icons.medication_outlined,
    "Contraccezione ormonale",
    "Pillola, cerotto, anello, spirale ormonale o impianto modificano il ciclo. Con la pillola combinata il "
        "sanguinamento mensile è una \"emorragia da sospensione\" durante la pausa e l'ovulazione non avviene, "
        "quindi la finestra fertile e molti effetti delle fasi non valgono. Puoi comunque registrare il "
        "sanguinamento, e i consigli per il comfort restano utili.",
  ),
  GeneralGuide(
    Icons.insights_outlined,
    "Come funziona la previsione",
    "Ogni inizio registrato insegna all'app la durata media del suo ciclo e quanto varia. Le date non devono "
        "essere consecutive: intervalli di diversi mesi vengono riconosciuti automaticamente. La previsione mostra "
        "il giorno più probabile e un intervallo; più date registri, più si restringe. È una stima, non un "
        "consiglio medico, e non è un contraccettivo.",
  ),
];
