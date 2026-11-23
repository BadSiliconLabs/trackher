import '../../engine/phases.dart';

import 'package:material_ui/material_ui.dart';

import 'guide_content.dart';

const guideEn = GuideContent(
  intro:
      'A menstrual cycle runs from the first day of one period to the day before the next. '
      'It is usually 21 to 35 days long (28 is only an average). Hormones rise and fall through it, '
      'and that can change energy, mood, appetite, sleep and how her body feels.\n\n'
      'Not everyone feels every phase strongly, and some feel very little. Use this as background, '
      'and let what she tells you come first.',
  cycleNote:
      'In longer or shorter cycles it is mostly the first half that stretches or shrinks. '
      'The time from ovulation to the next period stays around 14 days.',
  phases: _phases,
  general: _general,
);

const _phases = [
  PhaseGuide(
    phase: Phase.period,
    when: 'Days 1 to 5 (usually 3 to 7 days)',
    body:
        'The lining of the uterus sheds because no pregnancy happened. Estrogen and progesterone are at '
        'their lowest. Prostaglandins make the uterus contract, which causes cramps. Bleeding is usually '
        'heaviest on the first one or two days.',
    feel:
        'Cramps in the belly or lower back, tiredness, low energy, sometimes headaches, nausea or loose stools. '
        'Mood often lifts a bit once the bleeding starts, because PMS tends to ease.',
    help: [
      'Heat: a hot water bottle or heat pad on the belly or back.',
      'Warm, iron-rich food (red meat, lentils, spinach) and plenty of water.',
      'Take over chores and keep plans low-key.',
      'Ask whether she wants closeness or space, and respect the answer.',
      'Make sure pads, tampons and painkillers are in the house.',
    ],
    avoid: [
      'Jokes or comments about her period or mood.',
      'Pushing for big outings or intense activity.',
      'Making a fuss about stains or "accidents".',
    ],
  ),
  PhaseGuide(
    phase: Phase.follicular,
    when: 'About days 6 to 9 (after the period until the fertile window)',
    body:
        'The brain releases FSH, which makes follicles in the ovaries grow. They produce estrogen, '
        'which rises steadily. This is the stretchy part of the cycle: in long cycles this phase is longer.',
    feel:
        'Energy, mood, confidence and focus usually climb. Many people feel more social, curious and '
        'motivated, and sleep better.',
    help: [
      'Plan new things: a trip, a class, a hike, a new restaurant.',
      'Active dates and sport together.',
      'A good time for important conversations and planning.',
    ],
    avoid: ['Assuming she has endless energy: everyone is different.'],
  ),
  PhaseGuide(
    phase: Phase.fertile,
    when: 'About days 9 to 15 (5 days before ovulation to 1 day after)',
    body:
        'Estrogen peaks and a surge of LH triggers ovulation. Sperm can survive up to about 5 days, '
        'so the fertile window starts before ovulation itself.',
    feel:
        'Often the peak of energy, confidence and libido. Some notice clearer, stretchy discharge. '
        'Many feel more attractive and outgoing.',
    help: [
      'Plan a proper date night.',
      'Flirt, compliment, be affectionate.',
      'Say yes to her spontaneous ideas.',
      'Talk openly about contraception: this app is not birth control.',
    ],
    avoid: ['Relying on the app\'s estimate to avoid pregnancy.'],
  ),
  PhaseGuide(
    phase: Phase.ovulation,
    when: 'Around day 14 (about 14 days before the next period)',
    body:
        'An egg is released from an ovary and lives for about 12 to 24 hours. '
        'The exact day varies from cycle to cycle, so the app shows it as an estimate.',
    feel:
        'Usually similar to the fertile window. Some feel a short, sharp pain on one side of the lower belly '
        '(called mittelschmerz), mild bloating or slight spotting.',
    help: ['If she has ovulation pain: heat and sympathy.', 'Otherwise, enjoy the high-energy days together.'],
    avoid: ['Dismissing one-sided pain if it is severe: that is worth a doctor\'s visit.'],
  ),
  PhaseGuide(
    phase: Phase.luteal,
    when: 'About days 16 to 22 (after ovulation until PMS)',
    body:
        'The empty follicle becomes the corpus luteum and produces progesterone, which rises and calms the '
        'body. Body temperature goes up slightly. This phase is fairly fixed at about 12 to 14 days in total.',
    feel:
        'Energy slowly dips. She may want more rest, calm and comfort, and be hungrier than usual. '
        'Sleep can get lighter.',
    help: [
      'Swap intense plans for cozy ones: cooking, films, walks.',
      'Filling meals with complex carbs and some magnesium (nuts, seeds, dark chocolate).',
      'Extra patience: small things may bother her more.',
      'Check supplies early: the period is one to two weeks away.',
    ],
    avoid: ['Taking a shorter fuse personally.', 'Late-night arguments.'],
  ),
  PhaseGuide(
    phase: Phase.pms,
    when: 'About the last 6 days before the period',
    body:
        'If no pregnancy happens, progesterone and estrogen drop fast. That drop can affect serotonin '
        'and cause premenstrual symptoms (PMS). About 3 in 4 people notice some symptoms; a few have '
        'a severe form (PMDD) that deserves medical help.',
    feel:
        'Irritability, sadness or anxiety, mood swings, cravings (sweet or salty), bloating, tender breasts, '
        'headaches, tiredness, poor sleep, acne.',
    help: [
      'Listen without trying to fix, and ask before giving advice.',
      'Have her favourite comfort food and snacks ready.',
      'Offer a hug, a bath or a quiet evening; give space if she wants it.',
      'Keep the schedule light and postpone heavy topics if possible.',
      'Reassure her: "I\'m on your team."',
    ],
    avoid: [
      'Saying "Is it PMS?" when she\'s upset. Her feelings are real.',
      'Commenting on her body or what she eats.',
      'Too much caffeine and alcohol for both of you: they can make symptoms worse.',
    ],
  ),
];

const _general = [
  GeneralGuide(
    Icons.straighten_outlined,
    'What is normal?',
    'Cycle length: 21 to 35 days in adults, and it can vary by up to about 7 days from one cycle to the next.\n'
        'Period length: 2 to 7 days.\n'
        'Blood loss: usually 30 to 80 ml over the whole period, heaviest in the first days.\n\n'
        'Stress, illness, travel, sleep, weight changes, sport and hormonal contraception can all shift a cycle.',
  ),
  GeneralGuide(
    Icons.local_hospital_outlined,
    'When to suggest a doctor',
    'Gently encourage a check-up (and offer to come along) if:\n'
        '- cycles are often shorter than 21 or longer than 35 days, or very unpredictable\n'
        '- a period is 3 months late (and pregnancy is ruled out)\n'
        '- pain stops her from doing normal things, or painkillers don\'t help\n'
        '- bleeding soaks through a pad or tampon every hour, or lasts more than 7 days\n'
        '- mood symptoms before her period are severe (possible PMDD)\n'
        '- there is bleeding between periods or after sex.',
  ),
  GeneralGuide(
    Icons.medication_outlined,
    'Hormonal contraception',
    'The pill, patch, ring, hormonal IUD or implant change the cycle. On the combined pill, the monthly '
        'bleed is a "withdrawal bleed" during the break, and ovulation does not happen, so the fertile window '
        'and many phase effects don\'t apply. Bleeding can still be logged, and the tips about comfort still help.',
  ),
  GeneralGuide(
    Icons.insights_outlined,
    'How the forecast works',
    'Every logged start teaches the app her average cycle length and how much it varies. Dates don\'t need to be '
        'consecutive: gaps of several months are recognised automatically. The forecast shows the most likely day '
        'and a range; the more dates you log, the narrower it gets. It is an estimate, not medical advice, '
        'and not contraception.',
  ),
];
