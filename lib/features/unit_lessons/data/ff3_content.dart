import '../../../core/models/unit_lesson_model.dart';
import '../../../core/models/listening_model.dart';
import '../../../core/models/speaking_model.dart';

class FF3Content {
  static const String level = 'Family and Friends 3';

  static final List<UnitLesson> lessons = [
    // ── UNIT 1 ─────────────────────────────────────────────────────────────

    // Lesson 1 — Words: Countries
    UnitLesson(
      id: 'ff3_unit1_lesson1',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: 'Lesson 1 – Countries of the World',
      bookType: 'classbook',
      flipbookUrl: '',
      objectives:
          'Name 8 countries, recognise their flags, listen to a dialogue at an airport, understand a short story',
      vocabulary: [
        'Egypt',
        'the UK',
        'Russia',
        'Spain',
        'Thailand',
        'Australia',
        'the USA',
        'Brazil',
        'country',
        'flag',
        'airport',
        'cousin',
        'photo',
      ],
      keyStructures: [
        "I'm from [country].",
        "He's / She's from [country].",
        "Where are you from?",
        "They're from [country].",
        "We're from [country].",
      ],
      activities: [
        'Look at the 8 flags and say each country name aloud',
        'Listen to Track 06 and point to the correct flag when you hear the country',
        'Listen to the airport dialogue story and follow along in your book',
        'Look at the 4-panel comic: who says what? Match the speech bubbles to Holly, Max, Mum, Amy, and Leo',
        'Practise saying: "I\'m from [your country]!" with a partner',
      ],
      keyPoints: [
        '🌍 EGYPT — Egypt is a country in north-east Africa. It is famous for the pyramids and the Nile River. Its flag is red, white and black with a golden eagle in the middle.',
        '🇬🇧 THE UK (United Kingdom) — The UK is in Europe. It includes four countries: England, Scotland, Wales and Northern Ireland. The capital is London. Its flag is called the Union Jack.',
        '🇷🇺 RUSSIA — Russia is the BIGGEST country in the world! It is so large that it stretches across both Europe and Asia. The capital is Moscow.',
        '🇪🇸 SPAIN — Spain is in Europe, on the Iberian Peninsula. People in Spain speak Spanish. The capital is Madrid. Spain is famous for its sunny weather and flamenco dancing.',
        '🇹🇭 THAILAND — Thailand is in South-East Asia. Its flag has red, white and blue horizontal stripes. The capital is Bangkok. Thailand is known for its beautiful temples.',
        '🇦🇺 AUSTRALIA — Australia is both a country AND a continent in the Southern Hemisphere. Its flag shows the Union Jack and the Southern Cross stars. The capital is Canberra.',
        '🇺🇸 THE USA (United States of America) — The USA is in North America. It has 50 states. The capital is Washington D.C. The flag has 50 stars (one for each state) and 13 stripes.',
        '🇧🇷 BRAZIL — Brazil is the largest country in South America. The capital is Brasília. Brazil is famous for the Amazon rainforest and football.',
        '📖 THE STORY — "Where Are You From?" at the Airport:\n• Holly and Max are at the airport waiting for their cousins Amy and Leo.\n• Mum shows them an old photo. In the photo, Amy and Leo are wearing Russian clothes — they look like they are from Russia!\n• Holly and Max are confused. "Are they from Russia?" they ask.\n• Then Amy and Leo arrive. They say: "We\'re from Australia!" The old photo was taken a long time ago when they lived in Russia, but now they have moved to Australia.\n• Lesson: People can move between countries! Someone might have lived in many places.',
      ],
      order: 1,
    ),

    // Lesson 2 — Grammar: To-be contractions
    UnitLesson(
      id: 'ff3_unit1_lesson2',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: "Lesson 2 – I'm from… / He's from… / They're from…",
      bookType: 'classbook',
      flipbookUrl: '',
      objectives:
          "Use I'm, He's, She's, We're and They're + 'from' + country correctly in sentences and questions",
      vocabulary: [
        'from',
        "I'm (I am)",
        "He's (He is)",
        "She's (She is)",
        "We're (We are)",
        "They're (They are)",
        'where',
        'are',
        'is',
        'contraction',
        'apostrophe',
      ],
      keyStructures: [
        "I'm from [country].  →  I am from [country].",
        "He's from [country].  →  He is from [country].",
        "She's from [country].  →  She is from [country].",
        "We're from [country].  →  We are from [country].",
        "They're from [country].  →  They are from [country].",
        "Where are you from?  →  I'm from [country].",
        "Where is he from?  →  He's from [country].",
        "Where is she from?  →  She's from [country].",
      ],
      activities: [
        'Study the grammar table carefully: match the short form (contraction) with its full form',
        'Read and tick exercise: read 4 sentences and tick TRUE or FALSE',
        'Write exercise: look at the pictures and complete the sentences using We\'re / She\'s / He\'s / They\'re',
        'Play a guessing game: write a country on paper, your partner asks "Where are you from?" and you answer',
      ],
      keyPoints: [
        "✏️ WHAT IS A CONTRACTION?\nA contraction is a SHORT form of two words joined together. We leave out one or more letters and put an apostrophe (') in their place.\nExamples:\n  • I am  →  I'm  (the apostrophe replaces the letter 'a')\n  • He is  →  He's  (the apostrophe replaces the letter 'i')\n  • They are  →  They're  (the apostrophe replaces the letters 'a')",
        "👤 I'M — Use 'I'm' when you are talking about YOURSELF.\n  ✅ I'm from Egypt.\n  ✅ I'm from Spain.\n  ❌ Do NOT say: 'I are from...' or 'I is from...'",
        "👦 HE'S — Use 'He's' when you are talking about a BOY or a MAN.\n  ✅ He's from the USA.\n  ✅ He's from Brazil.\n  ❌ Do NOT use 'she's' for a boy.",
        "👧 SHE'S — Use 'She's' when you are talking about a GIRL or a WOMAN.\n  ✅ She's from Thailand.\n  ✅ She's from the UK.\n  ❌ Do NOT use 'he's' for a girl.",
        "👫 THEY'RE — Use 'They're' when you are talking about TWO OR MORE people.\n  ✅ They're from Australia.\n  ✅ They're from Russia.",
        "🤝 WE'RE — Use 'We're' when YOU and OTHER PEOPLE are in the same group.\n  ✅ We're from Egypt.\n  ✅ We're from Spain.",
        "❓ ASKING QUESTIONS:\n  • To ask ONE person: 'Where are you from?'\n  • To ask about a boy: 'Where is he from?'\n  • To ask about a girl: 'Where is she from?'\n  • To ask about a group: 'Where are they from?'",
        "📝 GRAMMAR TABLE SUMMARY:\n  I  →  I'm\n  He  →  He's\n  She  →  She's\n  We  →  We're\n  They  →  They're",
      ],
      order: 2,
    ),

    // Lesson 3 — Grammar and Song
    UnitLesson(
      id: 'ff3_unit1_lesson3',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: 'Lesson 3 – Where Are You From? (Speaking & Song)',
      bookType: 'classbook',
      flipbookUrl: '',
      objectives:
          "Ask and answer 'Where are you from?' naturally; recognise classmates' countries; sing the unit song",
      vocabulary: [
        'guess',
        'cover',
        'reveal',
        'nice to meet you',
        'verse',
        'chorus',
        'clap',
        'sing along',
      ],
      keyStructures: [
        "Where are you from?  →  I'm from [country].",
        "Where is he/she from?  →  He's/She's from [country].",
        "How old are you?  →  I'm [age] years old.",
        "Nice to meet you!",
      ],
      activities: [
        'Look at the picture of 8 children with their names, ages and countries',
        'Guessing game: cover the labels and point to a child — ask your partner "Where is he/she from?" — then uncover to check!',
        'Listen to Track 08 — the "Where Are You From?" song',
        'Sing along with the song and clap on the beat',
        'Try to sing the song with YOUR OWN country in the last line',
      ],
      keyPoints: [
        '👧👦 THE CHILDREN IN THE PICTURE:\n  • Jane — age 8 — from the UK\n  • Tom — age 10 — from Australia\n  • Ellie — age 9 — from Australia\n  • Billy — age 8 — from Australia\n  • Lisa — age 9 — from the USA\n  • Jack — age 10 — from the UK\n  • Zoe — age 8 — from the USA\n  • Carl — age 8 — from the UK',
        "🎵 THE SONG — 'Where Are You From?' (Track 08)\n\nVerse 1:\n  Hello! Hello! Where are you from?\n  I'm from the UK, nice to meet you!\n  Hello! Hello! Where are you from?\n  I'm from the UK, nice to meet you!\n\nVerse 2:\n  Hello! Hello! Where are you from?\n  I'm from Australia, nice to meet you!\n  Hello! Hello! Where are you from?\n  I'm from Australia, nice to meet you!\n\nVerse 3:\n  Hello! Hello! Where are you from?\n  I'm from the USA, nice to meet you!\n  Hello! Hello! Where are you from?\n  I'm from the USA, nice to meet you!",
        "🗣️ SPEAKING TIP: 'Nice to meet you!' is a friendly phrase we say when we meet someone for the first time. Always smile when you say it!",
        "🎯 HOW TO PLAY THE GUESSING GAME:\n  Step 1: Cover the name labels on the picture.\n  Step 2: Point to a child and ask: 'Where is he from?' or 'Where is she from?'\n  Step 3: Your partner answers: 'He's from Australia!' (or guesses!)\n  Step 4: Uncover the label to check if the answer is correct.\n  Step 5: Swap roles — now your partner asks YOU!",
        "🎤 SINGING TIP: You can change the country in the song to YOUR country! Try singing:\n  'I'm from Egypt, nice to meet you!' or\n  'I'm from [your country], nice to meet you!'",
      ],
      order: 3,
    ),

    // Lesson 4 — Phonics: Consonant Blends
    UnitLesson(
      id: 'ff3_unit1_lesson4',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: 'Lesson 4 – Phonics: Consonant Blends (cr, dr, sp, sn, pl)',
      bookType: 'classbook',
      flipbookUrl: '',
      objectives:
          'Recognise and pronounce consonant blends cr, dr, sp, sn, pl; identify the blend at the start of picture-words; chant the blends',
      vocabulary: [
        'crayon',
        'draw',
        'spoon',
        'snake',
        'drink',
        'play',
        'consonant',
        'blend',
        'chant',
      ],
      keyStructures: [
        'cr → cr-ayon (CRAYON)',
        'dr → dr-aw (DRAW),  dr-ink (DRINK)',
        'sp → sp-oon (SPOON)',
        'sn → sn-ake (SNAKE)',
        'pl → pl-ay (PLAY)',
      ],
      activities: [
        'Look at the blend chart: 6 blends each with a picture and a word',
        'Say each blend sound and word out loud: cr-cr-crayon, dr-dr-draw…',
        'Listen to Track 10 — the consonant blends chant',
        'Chant along, clapping on every blend',
        'Listen to Track 11 — point to the correct picture each time you hear a blend word',
        'Write the missing blend for 8 picture-words (e.g. ___ake = snAKE)',
      ],
      keyPoints: [
        "🔤 WHAT IS A CONSONANT BLEND?\nA consonant blend (also called a consonant cluster) is when TWO consonant letters appear TOGETHER at the start of a word. You say BOTH sounds quickly without stopping between them.\n\nImportant: this is DIFFERENT from a digraph (like 'sh' or 'ch') — in a blend, each letter keeps its own sound!",
        "🖍️ cr — (c + r)\nSay 'c' then 'r' VERY quickly: /kr/\nExample word: CRAYON\nA crayon is the coloured stick you use to draw and colour pictures.\nTry it: cr-cr-cr-CRAYON!",
        "✏️ dr — (d + r)\nSay 'd' then 'r' VERY quickly: /dr/\nExample words: DRAW, DRINK\n• DRAW = make a picture with a pencil or pen\n• DRINK = take liquid into your mouth\nTry it: dr-dr-dr-DRAW!",
        "🥄 sp — (s + p)\nSay 's' then 'p' VERY quickly: /sp/\nExample word: SPOON\nA spoon is the utensil you use to eat soup or cereal.\nTry it: sp-sp-sp-SPOON!",
        "🐍 sn — (s + n)\nSay 's' then 'n' VERY quickly: /sn/\nExample word: SNAKE\nA snake is a long reptile with no legs that slithers on the ground.\nTry it: sn-sn-sn-SNAKE!",
        "⚽ pl — (p + l)\nSay 'p' then 'l' VERY quickly: /pl/\nExample word: PLAY\nTo play means to have fun with games or toys.\nTry it: pl-pl-pl-PLAY!",
        "🎶 THE CHANT (Track 10):\n  cr-cr-CRAYON!\n  dr-dr-DRAW!\n  sp-sp-SPOON!\n  sn-sn-SNAKE!\n  dr-dr-DRINK!\n  pl-pl-PLAY!\n(Repeat — faster each time!)",
        "💡 TOP TIP FOR BLENDS:\nWhen you see two consonants at the START of a word, try blending them — say them fast without any pause or extra vowel sound between them.\n❌ Don't say: 'c-uh-rayon'\n✅ Do say: 'cr-ayon' (smooth and fast!)",
      ],
      order: 4,
    ),

    // Lesson 5 — Skills Time! Reading: The Lazy Bear
    UnitLesson(
      id: 'ff3_unit1_lesson5',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: 'Lesson 5 – Skills Time! Reading: The Lazy Bear',
      bookType: 'classbook',
      flipbookUrl: '',
      objectives:
          'Read and understand a seasonal story; name the four seasons; order story events in sequence; learn new nature vocabulary',
      vocabulary: [
        'spring',
        'summer',
        'autumn',
        'winter',
        'season',
        'garden',
        'lazy',
        'bear',
        'asleep',
        'honey',
        'flowers',
        'leaves',
        'snow',
        'cave',
        'berries',
        'hungry',
        'hibernate',
      ],
      keyStructures: [
        'In [season], [something happens].',
        'The bear is [adjective].',
        'He [verb] in [season].',
        'It is [weather description] in [season].',
      ],
      activities: [
        'Look at the 6 vocabulary pictures: spring, summer, autumn, winter, garden, season — say each word',
        'Listen to Track 12 — the seasons vocabulary audio',
        'Read "The Lazy Bear" story — 4 paragraphs, one for each season',
        'Listen to Track 13 — the story audio (follow along in your book)',
        'Ordering exercise: read 6 sentences and write numbers 1–6 to show the correct story order',
      ],
      keyPoints: [
        "🌍 THE FOUR SEASONS — What Are They?\nA year is divided into FOUR seasons. Each season has different weather, different plants, and different activities. The seasons change because of how the Earth moves around the Sun.",
        "🌸 SPRING (March, April, May)\nWeather: getting warmer, sometimes rainy\nNature: flowers start to bloom, trees grow new green leaves, birds sing and build nests\nAnimals: bears WAKE UP from their winter sleep!\nActivities: planting seeds in the garden",
        "☀️ SUMMER (June, July, August)\nWeather: hot and sunny — the hottest season!\nNature: gardens are full of colourful flowers, trees have lots of green leaves\nAnimals: very active, eating lots of food\nActivities: swimming, playing outside, going on holiday",
        "🍂 AUTUMN (September, October, November)\nWeather: getting cooler and windier\nNature: leaves turn orange, red and yellow and fall from the trees — that's why autumn is also called 'fall' in American English!\nAnimals: eating as much as possible to prepare for winter\nActivities: collecting leaves, carving pumpkins",
        "❄️ WINTER (December, January, February)\nWeather: very cold, often snowy\nNature: many trees have no leaves, gardens look bare\nAnimals: some animals HIBERNATE (sleep all winter to save energy)\nActivities: building snowmen, staying warm inside",
        "📖 THE STORY — 'The Lazy Bear':\n\nParagraph 1 — SPRING:\nThe bear wakes up from his long winter sleep. He is very hungry! He stretches, yawns, and goes out of his cave to find food. He smells honey and goes to find it.\n\nParagraph 2 — SUMMER:\nThe bear plays in the beautiful garden. The flowers are bright and colourful. The sun is warm and the bear feels very happy. He eats berries and fruit.\n\nParagraph 3 — AUTUMN:\nThe leaves are turning orange and falling. The bear is eating lots of berries and nuts. He is getting bigger and bigger. He starts to feel sleepy again.\n\nParagraph 4 — WINTER:\nThe snow begins to fall. The bear walks slowly back to his cave. He curls up and falls into a deep, deep sleep. He will sleep all winter long!",
        "❓ WHY IS THE BEAR 'LAZY'?\nThe bear is called 'lazy' in the story because he sleeps for a very long time in winter. BUT — this is not really laziness! It is called HIBERNATION. Hibernation is when some animals (bears, hedgehogs, bats) go into a very deep sleep during cold winter months to save energy because there is not enough food. Their body temperature drops and their heartbeat slows down. It is a remarkable survival skill!",
        "📝 STORY ORDER — Comprehension Exercise:\nPut these 6 events in the correct order (1 = first, 6 = last):\n  ___ The bear feels sleepy in autumn\n  ___ The bear wakes up in spring and feels hungry\n  ___ The bear plays in the summer garden\n  ___ The bear finds honey in spring\n  ___ The bear goes back to his cave in winter\n  ___ The bear eats berries and nuts in autumn\n\nCORRECT ORDER:\n  1 → The bear wakes up in spring and feels hungry\n  2 → The bear finds honey in spring\n  3 → The bear plays in the summer garden\n  4 → The bear eats berries and nuts in autumn\n  5 → The bear feels sleepy in autumn\n  6 → The bear goes back to his cave in winter",
      ],
      order: 5,
    ),
  ];

  // ── Listening exercises for FF3 Unit 1 ──────────────────────────────────

  static final List<ListeningExercise> listeningExercises = [
    ListeningExercise(
      id: 'ff3_unit1_listen_1',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: 'Track 06 – Countries Dialogue at the Airport',
      trackLabel: 'Unit 1 Track 06 – Airport Story',
      instructions:
          'Listen to the dialogue at the airport. Follow the story carefully. Then answer the questions.',
      transcriptHint:
          'Holly and Max wait at the airport for their cousins Amy and Leo. Mum shows an old photo. Amy and Leo arrive and say they are from Australia.',
      questions: [
        ListeningQuestion(
          id: 'ff3_u1l1_q1',
          question: 'Where are Holly and Max at the start of the story?',
          options: ['at school', 'at the airport', 'at home', 'at the park'],
          correctAnswer: 'at the airport',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'ff3_u1l1_q2',
          question: 'In the old photo, where do Amy and Leo look like they are from?',
          options: ['Australia', 'Spain', 'Russia', 'the UK'],
          correctAnswer: 'Russia',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'ff3_u1l1_q3',
          question: 'True or False: Amy and Leo are actually from Australia.',
          options: ['True', 'False'],
          correctAnswer: 'True',
          type: 'true_false',
        ),
      ],
      xpReward: 20,
      order: 1,
    ),
    ListeningExercise(
      id: 'ff3_unit1_listen_2',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: 'Track 08 – Where Are You From? (Song)',
      trackLabel: 'Unit 1 Track 08 – Unit Song',
      instructions:
          'Listen to the song. Clap along on the beat. Then answer the questions about the song.',
      transcriptHint:
          'A 3-verse song. Verse 1: from the UK. Verse 2: from Australia. Verse 3: from the USA.',
      questions: [
        ListeningQuestion(
          id: 'ff3_u1l2_q1',
          question: 'What question is repeated in every verse of the song?',
          options: [
            'How old are you?',
            'What is your name?',
            'Where are you from?',
            'How are you?',
          ],
          correctAnswer: 'Where are you from?',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'ff3_u1l2_q2',
          question: 'Which THREE countries are mentioned in the song?',
          options: [
            'Russia, Spain, Brazil',
            'the UK, Australia, the USA',
            'Egypt, Thailand, the UK',
            'Brazil, Australia, Spain',
          ],
          correctAnswer: 'the UK, Australia, the USA',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'ff3_u1l2_q3',
          question: 'True or False: The song includes the phrase "nice to meet you".',
          options: ['True', 'False'],
          correctAnswer: 'True',
          type: 'true_false',
        ),
      ],
      xpReward: 20,
      order: 2,
    ),
  ];

  // ── Speaking topics for FF3 Unit 1 ──────────────────────────────────────

  static final List<SpeakingTopic> speakingTopics = [
    SpeakingTopic(
      id: 'ff3_unit1_speak_1',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: 'Countries Spin Wheel – Where Are You From?',
      instructions:
          'Spin the wheel and answer the question in English. Use full sentences and the vocabulary from the lesson!',
      spinWheelQuestions: [
        'Where are you from?',
        'Name 3 countries in Europe.',
        'Name a country in Asia.',
        'Name a country in South America.',
        'Which country is the biggest in the world?',
        'Say: "I\'m from [your country]!" with a big smile.',
        'What country is the UK in? (Europe, Asia, or Africa?)',
        'Name the country where the Amazon rainforest is.',
        'Which country has 50 states?',
        'What is the capital of Egypt?',
      ],
      sentenceStarters: [
        "I'm from...",
        "He's from...",
        "She's from...",
        "They're from...",
        "We're from...",
        'A country in [continent] is...',
        'The biggest country is...',
      ],
      vocabularyFocus:
          'Egypt, the UK, Russia, Spain, Thailand, Australia, the USA, Brazil, country, from',
      xpReward: 10,
      order: 1,
    ),
    SpeakingTopic(
      id: 'ff3_unit1_speak_2',
      level: 'Family and Friends 3',
      unit: 'Unit 1',
      title: "Where Are You From? – Role-Play Guessing Game",
      instructions:
          'Take turns! One student picks a country (keep it secret). The other asks questions to guess. Use the sentence starters to help you.',
      spinWheelQuestions: [
        'Are you from Europe?',
        'Are you from Asia?',
        'Is your country big or small?',
        'What language do people speak in your country?',
        'What is your country famous for?',
        'Describe the flag of your country.',
        'Is your country hot or cold?',
        "Say 'Hello' in the language of your country!",
        'Is your country in Africa, Asia, or America?',
        'Name something you can see in your country.',
      ],
      sentenceStarters: [
        "I'm from...",
        "My country is in...",
        "In my country, people speak...",
        "My country is famous for...",
        "The flag is...",
        "Are you from...?",
        "Is your country...?",
      ],
      vocabularyFocus:
          'country, flag, language, famous, continent, Europe, Asia, Africa, America, Australia',
      xpReward: 10,
      order: 2,
    ),
  ];
}
