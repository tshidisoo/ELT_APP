import '../../../core/models/unit_lesson_model.dart';
import '../../../core/models/listening_model.dart';
import '../../../core/models/speaking_model.dart';

// Kept for backwards compatibility — UnitLesson is the shared model now.
typedef FF1UnitLesson = UnitLesson;

class FF1Content {
  static const String flipbookUrl = 'https://online.flipbuilder.com/xtrvf/xncb/';
  static const String level = 'Family and Friends 1';

  static final List<UnitLesson> lessons = [
    // STARTER UNIT - CLASSBOOK
    UnitLesson(
      id: 'ff1_starter_classbook',
      level: 'Family and Friends 1',
      unit: 'Starter Unit',
      title: 'Hello! – Classbook',
      bookType: 'classbook',
      flipbookUrl: 'https://online.flipbuilder.com/xtrvf/xncb/',
      objectives:
          'Greet friends, introduce yourself, say numbers 1–5, name classroom colors',
      vocabulary: [
        'hello',
        'goodbye',
        'hi',
        'bye',
        "what's your name?",
        "I'm...",
        'one',
        'two',
        'three',
        'four',
        'five',
        'red',
        'blue',
        'green',
        'yellow',
        'orange',
      ],
      keyStructures: [
        "Hello! I'm [name].",
        "What's your name?",
        'How old are you? I\'m [number].',
        'What color is it? It\'s [color].',
      ],
      activities: [
        'Listen and point to the characters',
        'Listen and repeat the greetings',
        'Sing the Hello song with actions',
        'Count and say the numbers 1–5',
        'Point to the colors in the picture',
        "Play \"What's your name?\" with a partner",
      ],
      keyPoints: [
        'Use "Hello" or "Hi" to greet people',
        'Say "I\'m [name]" to introduce yourself',
        'Numbers 1–5: one, two, three, four, five',
        'Colors: red, blue, green, yellow, orange',
        'Say "Goodbye" or "Bye" when leaving',
      ],
      order: 1,
    ),

    // STARTER UNIT - WORKBOOK
    UnitLesson(
      id: 'ff1_starter_workbook',
      level: 'Family and Friends 1',
      unit: 'Starter Unit',
      title: 'Hello! – Workbook',
      bookType: 'workbook',
      flipbookUrl: 'https://online.flipbuilder.com/xtrvf/xncb/',
      objectives:
          'Practice writing numbers, trace letters, color the correct items',
      vocabulary: [
        'one',
        'two',
        'three',
        'four',
        'five',
        'red',
        'blue',
        'green',
        'yellow',
        'orange',
      ],
      keyStructures: [
        'Trace the word: [number]',
        'Circle the correct color',
        'Color the picture',
      ],
      activities: [
        'Trace the numbers 1–5',
        'Color the balloons: red, blue, green, yellow, orange',
        'Circle the correct number in each group',
        'Draw yourself and write your name',
        'Count the objects and write the number',
      ],
      keyPoints: [
        'Write numbers 1–5 clearly',
        'Match colors to their names',
        'Count groups of objects',
      ],
      order: 2,
    ),

    // UNIT 1 - CLASSBOOK
    UnitLesson(
      id: 'ff1_unit1_classbook',
      level: 'Family and Friends 1',
      unit: 'Unit 1',
      title: 'My Family – Classbook',
      bookType: 'classbook',
      flipbookUrl: 'https://online.flipbuilder.com/xtrvf/xncb/',
      objectives:
          "Name family members, describe family relationships, use \"This is my...\" and \"He's/She's my...\"",
      vocabulary: [
        'mum',
        'dad',
        'brother',
        'sister',
        'grandma',
        'grandpa',
        'baby',
        'family',
        'happy',
      ],
      keyStructures: [
        'This is my [family member].',
        "He's / She's my [family member].",
        "Who's this? It's my [family member].",
        "Is this your [family member]? Yes, it is. / No, it isn't.",
      ],
      activities: [
        'Look at the picture and name the family members',
        'Listen and point to the family members',
        'Listen and repeat the family vocabulary',
        'Sing the "My Family" song',
        'Ask and answer: "Who\'s this?"',
        'Draw your own family and describe it',
      ],
      keyPoints: [
        'Family members: mum, dad, brother, sister, grandma, grandpa, baby',
        'Use "This is my..." to introduce a family member',
        'Use "He\'s my..." for males and "She\'s my..." for females',
        'Ask "Who\'s this?" to find out about family members',
        'The word "happy" describes how family members feel',
      ],
      order: 3,
    ),

    // UNIT 1 - WORKBOOK
    UnitLesson(
      id: 'ff1_unit1_workbook',
      level: 'Family and Friends 1',
      unit: 'Unit 1',
      title: 'My Family – Workbook',
      bookType: 'workbook',
      flipbookUrl: 'https://online.flipbuilder.com/xtrvf/xncb/',
      objectives:
          'Write family vocabulary, match pictures to words, complete sentences about family',
      vocabulary: [
        'mum',
        'dad',
        'brother',
        'sister',
        'grandma',
        'grandpa',
        'baby',
      ],
      keyStructures: [
        'This is my ___.',
        "He's / She's my ___.",
        'Circle the correct word',
        'Trace the family word',
      ],
      activities: [
        'Trace the family words',
        'Match the family member to the correct word',
        'Circle "He" or "She" for each family member',
        'Complete the sentence: "This is my ___."',
        'Draw your family tree and label each member',
        'Color the happy family picture',
      ],
      keyPoints: [
        'Trace and write family vocabulary clearly',
        'Use "He" for male family members',
        'Use "She" for female family members',
        'Complete sentences using "This is my..."',
      ],
      order: 4,
    ),
  ];

  // Listening exercises for FF1
  static final List<ListeningExercise> listeningExercises = [
    // Starter Unit listening
    ListeningExercise(
      id: 'ff1_starter_listen_1',
      level: 'Family and Friends 1',
      unit: 'Starter Unit',
      title: 'Listen and Point – Greetings',
      trackLabel: 'Starter Track 1 – Greetings',
      instructions:
          'Listen to the audio. Point to the character who is speaking. Then repeat the greeting.',
      transcriptHint:
          'Children greet each other using "Hello", "Hi", "What\'s your name?" and "Goodbye".',
      questions: [
        ListeningQuestion(
          id: 'sq1',
          question: 'What does Rowan say first?',
          options: ['Hello!', 'Goodbye!', 'How are you?', 'See you later!'],
          correctAnswer: 'Hello!',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'sq2',
          question: 'What does Tim ask?',
          options: [
            "What's your name?",
            'How old are you?',
            'Where are you?',
            'What color is it?',
          ],
          correctAnswer: "What's your name?",
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'sq3',
          question: 'True or False: The children say "Goodbye" at the end.',
          options: ['True', 'False'],
          correctAnswer: 'True',
          type: 'true_false',
        ),
      ],
      xpReward: 15,
      order: 1,
    ),
    ListeningExercise(
      id: 'ff1_starter_listen_2',
      level: 'Family and Friends 1',
      unit: 'Starter Unit',
      title: 'Listen and Count – Numbers 1–5',
      trackLabel: 'Starter Track 2 – Numbers Song',
      instructions:
          'Listen to the numbers song. Hold up the correct number of fingers. Then repeat the numbers.',
      transcriptHint:
          'A fun counting song going from 1 to 5 with objects to count in the picture.',
      questions: [
        ListeningQuestion(
          id: 'sq4',
          question: 'How many pencils are there?',
          options: ['1', '2', '3', '4'],
          correctAnswer: '3',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'sq5',
          question: 'What number comes after three?',
          options: ['two', 'four', 'five', 'one'],
          correctAnswer: 'four',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'sq6',
          question: 'How many colors are named in the song?',
          options: ['3', '4', '5', '6'],
          correctAnswer: '5',
          type: 'multiple_choice',
        ),
      ],
      xpReward: 15,
      order: 2,
    ),

    // Unit 1 listening
    ListeningExercise(
      id: 'ff1_unit1_listen_1',
      level: 'Family and Friends 1',
      unit: 'Unit 1',
      title: 'Listen and Point – My Family',
      trackLabel: 'Unit 1 Track 1 – Family Members',
      instructions:
          'Listen to the audio. Point to the correct family member in your book. Then repeat the word.',
      transcriptHint:
          'A child introduces each family member one by one: mum, dad, brother, sister, grandma, grandpa, baby.',
      questions: [
        ListeningQuestion(
          id: 'u1q1',
          question: 'Who is introduced first?',
          options: ['dad', 'mum', 'grandma', 'sister'],
          correctAnswer: 'mum',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'u1q2',
          question: 'Is the baby a boy or a girl in the story?',
          options: ['boy', 'girl', "we don't know", 'both'],
          correctAnswer: "we don't know",
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'u1q3',
          question: 'How many family members are introduced?',
          options: ['5', '6', '7', '4'],
          correctAnswer: '7',
          type: 'multiple_choice',
        ),
      ],
      xpReward: 20,
      order: 1,
    ),
    ListeningExercise(
      id: 'ff1_unit1_listen_2',
      level: 'Family and Friends 1',
      unit: 'Unit 1',
      title: 'Listen and Sing – The Family Song',
      trackLabel: 'Unit 1 Track 2 – Family Song',
      instructions:
          'Listen to the family song. Clap along! Then try to sing with the audio.',
      transcriptHint:
          'An upbeat song about a happy family. Mentions mum, dad, brother, sister, grandma, grandpa.',
      questions: [
        ListeningQuestion(
          id: 'u1q4',
          question: 'Which word describes the family in the song?',
          options: ['big', 'happy', 'funny', 'small'],
          correctAnswer: 'happy',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'u1q5',
          question: 'True or False: The song mentions a baby.',
          options: ['True', 'False'],
          correctAnswer: 'True',
          type: 'true_false',
        ),
        ListeningQuestion(
          id: 'u1q6',
          question: 'Which family members are NOT in the song?',
          options: [
            'aunt and uncle',
            'mum and dad',
            'grandma and grandpa',
            'brother and sister',
          ],
          correctAnswer: 'aunt and uncle',
          type: 'multiple_choice',
        ),
      ],
      xpReward: 20,
      order: 2,
    ),
    ListeningExercise(
      id: 'ff1_unit1_listen_3',
      level: 'Family and Friends 1',
      unit: 'Unit 1',
      title: "Listen and Circle – Who's This?",
      trackLabel: 'Unit 1 Track 3 – Story Time',
      instructions:
          'Listen to the story. Circle the correct family member each time you hear "Who\'s this?".',
      transcriptHint:
          'A short story where a child shows a photo album and asks "Who\'s this?" for each family member.',
      questions: [
        ListeningQuestion(
          id: 'u1q7',
          question: 'Who does the child show first in the photo album?',
          options: ['grandpa', 'mum', 'dad', 'sister'],
          correctAnswer: 'dad',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'u1q8',
          question: 'Complete: "This is my ___."',
          options: ['teacher', 'friend', 'grandma', 'cat'],
          correctAnswer: 'grandma',
          type: 'multiple_choice',
        ),
        ListeningQuestion(
          id: 'u1q9',
          question: 'How does the family feel?',
          options: ['sad', 'angry', 'happy', 'tired'],
          correctAnswer: 'happy',
          type: 'multiple_choice',
        ),
      ],
      xpReward: 20,
      order: 3,
    ),
  ];

  // Speaking topics for FF1
  static final List<SpeakingTopic> speakingTopics = [
    // Starter Unit speaking
    SpeakingTopic(
      id: 'ff1_starter_speak_1',
      level: 'Family and Friends 1',
      unit: 'Starter Unit',
      title: 'Say Hello! – Greetings Spin Wheel',
      instructions:
          'Spin the wheel! Answer the question in English. Try to use full sentences.',
      spinWheelQuestions: [
        'Say hello to a friend!',
        'What is your name?',
        'How old are you?',
        'Say goodbye!',
        'What color is your bag?',
        'Count to five!',
        'What is your favorite color?',
        "Say \"Hi, I'm [name]!\" to the class.",
      ],
      sentenceStarters: [
        "Hello! I'm...",
        'My name is...',
        "I'm [number] years old.",
        'My favorite color is...',
        'One, two, three, four, five!',
      ],
      vocabularyFocus: 'hello, goodbye, name, colors, numbers 1–5',
      xpReward: 10,
      order: 1,
    ),

    // Unit 1 speaking
    SpeakingTopic(
      id: 'ff1_unit1_speak_1',
      level: 'Family and Friends 1',
      unit: 'Unit 1',
      title: 'My Family – Spin Wheel',
      instructions:
          'Spin the wheel and answer the question about your family. Use full sentences!',
      spinWheelQuestions: [
        'Who is in your family?',
        'Do you have a brother?',
        'Do you have a sister?',
        'How many people are in your family?',
        'Is your mum happy?',
        'Tell me about your grandma or grandpa.',
        'Who is older – you or your brother/sister?',
        'Say: "This is my mum!"',
        'Do you have a baby in your family?',
        'Who do you love most in your family?',
      ],
      sentenceStarters: [
        'This is my...',
        "He's my...",
        "She's my...",
        'I have a...',
        'My family is...',
        'Yes, I have a...',
        "No, I don't have a...",
      ],
      vocabularyFocus:
          'mum, dad, brother, sister, grandma, grandpa, baby, family, happy',
      xpReward: 10,
      order: 1,
    ),
    SpeakingTopic(
      id: 'ff1_unit1_speak_2',
      level: 'Family and Friends 1',
      unit: 'Unit 1',
      title: "Who's This? – Role Play",
      instructions:
          'Look at the pictures. Take turns asking "Who\'s this?" and answering "It\'s my [family member]!"',
      spinWheelQuestions: [
        'Point to a mum in the picture.',
        'Point to a dad in the picture.',
        'Who is the oldest person?',
        'Who is the youngest person?',
        'Is this a boy or a girl?',
        'Say: "She\'s my sister!"',
        'Say: "He\'s my brother!"',
        'Ask your friend: "Is this your grandma?"',
        'How many children are in the family?',
        'Which family member is smiling?',
      ],
      sentenceStarters: [
        "Who's this?",
        "It's my...",
        'Is this your...?',
        'Yes, it is.',
        "No, it isn't.",
      ],
      vocabularyFocus:
          'mum, dad, brother, sister, grandma, grandpa, baby, he, she',
      xpReward: 10,
      order: 2,
    ),
  ];
}
