import '../config/app_config.dart';
import '../models/teacher_avatar.dart';
import '../models/quiz.dart';
import '../services/content_parser_service.dart';
import '../services/teacher_brain_service.dart';

class MockTeacherBrainService implements TeacherBrainService {
  @override
  Future<GeneratedScript> generateScript({
    required ParsedContent content,
    required RegionalLanguage language,
    required TeachingStyle style,
    required TeacherAvatar avatar,
  }) async {
    // Simulate AI synthesis & pedagogical framing
    await Future.delayed(const Duration(milliseconds: 1200));

    final isBengali = language.code == 'bn';
    final isHindi = language.code == 'hi';

    if (isBengali) {
      return _generateBengaliScript(content, style, avatar);
    } else if (isHindi) {
      return _generateHindiScript(content, style, avatar);
    } else {
      return _generateEnglishScript(content, style, avatar);
    }
  }

  GeneratedScript _generateBengaliScript(
    ParsedContent content,
    TeachingStyle style,
    TeacherAvatar avatar,
  ) {
    String intro;

    switch (style) {
      case TeachingStyle.strictCoaching:
        intro = 'নমস্কার ছাত্রছাত্রীরা! আমি ${avatar.name}। জয়েন্ট এন্ট্রান্স ও বোর্ডের জন্য নিউটনের সূত্র থেকে প্রতি বছর ৩টি প্রশ্ন থাকে। সময় নষ্ট না করে সরাসরি মূল কনসেপ্টে যাব!';
        break;
      case TeachingStyle.friendlySibling:
        intro = 'কী খবর বন্ধুরা! আমি তোমাদের ${avatar.name}। নিউটনের নিয়ম শুনলে কি খুব জটিল মনে হয়? একদম না! চলো ক্রিকেট বল আর সাইকেল চালানোর উদাহরণ দিয়ে বুঝে নিই!';
        break;
      case TeachingStyle.storyMode:
        intro = '১৬৮৭ সালের এক শান্ত বিকেল। ইংল্যান্ডে প্লেগের কারণে কেমব্রিজ বিশ্ববিদ্যালয় বন্ধ। তখন এক তরুণ বিজ্ঞানী আইজ্যাক নিউটন বাগানে বসে ভাবছিলেন—কী সেই অদৃশ্য টান?';
        break;
      case TeachingStyle.warmTeacher:
        intro = 'নমস্কার স্নেহের শিক্ষার্থীরা! আমি ${avatar.name}। আজকে আমরা অত্যন্ত সহজ ভাষায় পদার্থবিজ্ঞানের মূল ভিত্তি—নিউটনের গতির সূত্র ও ভরবেগের সংরক্ষণ নিয়ম বুঝব।';
    }

    final sections = [
      ScriptSection(
        title: '১. প্রথম সূত্র ও জড়তার ধারণা (Inertia)',
        scriptText:
            '$intro প্রথম সূত্র বলছে: কোনো বস্তুর ওপর বাইরে থেকে কোনো অসাম্য বল প্রয়োগ না করলে, স্থির বস্তু চিরকাল স্থির থাকবে এবং গতিশীল বস্তু সমবেগে সরলরেখায় চলতে থাকবে। একেই বলা হয় জড়তা বা Inertia। বাস হঠাৎ ব্রেক কষলে কেন আমরা সামনের দিকে ঝুঁকে পড়ি? কারণ আমাদের শরীরের গতি জড়তা!',
        estimatedSeconds: 45,
        examPointers: [
          'সংজ্ঞা: বাহ্যিক বল শূন্য হলে ত্বরণ a = 0',
          'বাস্তব উদাহরণ: চলন্ত বাস ব্রেক কষা (গতির জড়তা)',
        ],
        visualCue: 'চলন্ত বাসের অ্যানিমেশন ও জড়তার বলরেখা',
      ),
      ScriptSection(
        title: '২. দ্বিতীয় সূত্র: বল ও ভরবেগের পরিবর্তন (F = ma)',
        scriptText:
            'দ্বিতীয় সূত্র পদার্থবিজ্ঞানের হৃদস্পন্দন! বস্তুর ভরবেগের পরিবর্তনের হার তার ওপর প্রযুক্ত বলের সমানুপাতিক। অর্থাৎ F = dp/dt = m*a। এখান থেকেই আমরা বলের পরিমাপ পাই। ক্রিকেট খেলোয়াড়রা ক্যাচ ধরার সময় হাত পেছনের দিকে টানে কেন? কারণ সময় বৃদ্ধি করে বলের ঘাত (Impulse) কমানো হয়!',
        estimatedSeconds: 55,
        examPointers: [
          'ফর্মুলা: F = m × a (বলের এসআই একক: নিউটন N)',
          'ঘাত বল: J = F × Δt = Δp (ভরবেগের পরিবর্তন)',
        ],
        visualCue: 'ক্রিকেট বল ক্যাচ ধরার মোশন ভেক্টর ডায়াগ্রাম',
      ),
      ScriptSection(
        title: '৩. তৃতীয় সূত্র ও ভরবেগের সংরক্ষণ (Conservation of Momentum)',
        scriptText:
            'প্রত্যেক ক্রিয়ারই একটি সমান ও বিপরীতমুখী প্রতিক্রিয়া আছে। মনে রাখবে, ক্রিয়া ও প্রতিক্রিয়া কখনোই একই বস্তুর ওপর কাজ করে না! এই সূত্রের সেরা প্রয়োগ রকেট উৎক্ষেপণ এবং বন্দুক থেকে গুলি ছোড়ার পশ্চাদপসরণ (Recoil)। মোট প্রাথমিক ভরবেগ = মোট চূড়ান্ত ভরবেগ: m1*u1 + m2*u2 = m1*v1 + m2*v2।',
        estimatedSeconds: 60,
        examPointers: [
          'বন্দুকের রিকয়েল বেগ: V = - (m × v) / M',
          'রকেটের গতিবেগ নিউটনের ৩য় সূত্র ও ভরবেগ সংরক্ষণে চলে',
        ],
        visualCue: 'রকেট প্রপালশন ও মহাকর্ষীয় গ্যাস নির্গমন ডায়াগ্রাম',
      ),
    ];

    return GeneratedScript(
      title: 'নিউটনের গতির সূত্রাবলী ও ভরবেগ সংরক্ষণ',
      fullText: sections.map((s) => s.scriptText).join('\n\n'),
      sections: sections,
      highYieldExamPointers: [
        'ভরবেগের একক kg·m/s এবং বলের একক Newton (kg·m/s²)',
        'ক্রিয়া ও প্রতিক্রিয়া দুটি ভিন্ন বস্তুর ওপর যুগপৎ প্রযুক্ত হয়',
        'বন্দুকের পশ্চাদপসরণ সূত্র: V_recoil = - (m_bullet * v_bullet) / M_gun',
        'বাহ্যিক বল শূন্য হলে রৈখিক ভরবেগ সর্বদাই সংরক্ষিত থাকে'
      ],
      languageCode: 'bn',
      style: style,
      totalEstimatedDurationSeconds: 160,
    );
  }

  GeneratedScript _generateHindiScript(
    ParsedContent content,
    TeachingStyle style,
    TeacherAvatar avatar,
  ) {
    String intro;
    switch (style) {
      case TeachingStyle.strictCoaching:
        intro = 'नमस्ते छात्रों! मैं हूँ ${avatar.name}। बोर्ड और जेईई में न्यूटन के नियमों से सीधे न्यूमेरिकल आते हैं। ध्यान भटकना नहीं चाहिए, सीधे कॉन्सेप्ट पर आते हैं!';
        break;
      case TeachingStyle.friendlySibling:
        intro = 'हेलो दोस्तों! मैं हूँ आपका ${avatar.name}। न्यूटन के नियम रटने की ज़रूरत नहीं है! आज हम इसे बाइक राइडिंग और फुटबॉल के मजेदार उदाहरण से समझेंगे।';
        break;
      case TeachingStyle.storyMode:
        intro = 'साल १६८৭ की बात है। जब दुनिया गति के रहस्यों को नहीं समझती थी, तब आइज़क न्यूटन ने प्रकृति के सबसे बड़े नियमों को दुनिया के सामने रखा।';
        break;
      case TeachingStyle.warmTeacher:
        intro = 'नमस्ते प्यारे विद्यार्थियों! मैं ${avatar.name}। आज हम भौतिक विज्ञान का सबसे महत्वपूर्ण अध्याय—न्यूटन के गति के नियम और संवेग संरक्षण बहुत ही सरल तरीके से समझेंगे।';
    }

    final sections = [
      ScriptSection(
        title: '१. प्रथम नियम और जड़त्व (Inertia)',
        scriptText:
            '$intro पहला नियम कहता है: यदि किसी वस्तु पर कोई बाहरी असंतुलित बल न लगे, तो स्थिर वस्तु स्थिर रहेगी और गतिशील वस्तु उसी वेग से सरल रेखा में चलती रहेगी। इसे जड़त्व का नियम भी कहते हैं।',
        estimatedSeconds: 45,
        examPointers: [
          'परिभाषा: बाह्य बल अनुपस्थित होने पर त्वरण a = 0',
          'जड़त्व वस्तु के द्रव्यमान (Mass) पर निर्भर करता है',
        ],
        visualCue: 'जड़त्व का प्रदर्शन: चलती बस में ब्रेक लगने पर शरीर का आगे झुकना',
      ),
      ScriptSection(
        title: '२. द्वितीय नियम: बल एवं संवेग परिवर्तन (F = ma)',
        scriptText:
            'दूसरा नियम बल का गणितीय रूप देता है: संवेग परिवर्तन की दर लगाए गए असंतुलित बल के समानुपाती होती है। यानी F = dp/dt = m*a। जब कैच लेते समय खिलाड़ी हाथ पीछे खींचता है, तो वह समय बढ़ाकर चोट के बल को कम करता है!',
        estimatedSeconds: 50,
        examPointers: [
          'सूत्र: F = m × a (SI मात्रक: न्यूटन N)',
          'आवेग (Impulse): J = F × Δt = संवेग में परिवर्तन Δp',
        ],
        visualCue: 'क्रिकेट गेंद कैच करते समय बल और समय का ग्राफ',
      ),
      ScriptSection(
        title: '३. तृतीय नियम एवं रेखीय संवेग संरक्षण',
        scriptText:
            'प्रत्येक क्रिया के बराबर और विपरीत दिशा में प्रतिक्रिया होती है। क्रिया और प्रतिक्रिया हमेशा दो अलग-अलग वस्तुओं पर लगती हैं। जब बंदूक से गोली निकलती है, तो बंदूक पीछे की ओर झटका देती है—यही संवेग संरक्षण का प्रत्यक्ष प्रमाण है!',
        estimatedSeconds: 65,
        examPointers: [
          'बंदूक का प्रतिक्षेप वेग (Recoil): V = - (m * v) / M',
          'रॉकेट का आगे बढ़ना संवेग संरक्षण सिद्धांत पर आधारित है',
        ],
        visualCue: 'रॉकेट प्रक्षेपण और निष्कासित गैसों का वेग वेक्टर',
      ),
    ];

    return GeneratedScript(
      title: 'न्यूटन के गति के नियम एवं संवेग संरक्षण',
      fullText: sections.map((s) => s.scriptText).join('\n\n'),
      sections: sections,
      highYieldExamPointers: [
        'संवेग का मात्रक: kg·m/s, बल का मात्रक: Newton (N)',
        'क्रिया और प्रतिक्रिया कभी एक ही वस्तु पर नहीं लगतीं',
        'यदि कुल बाहरी बल शून्य है, तो कुल संवेग हमेशा संरक्षित रहता है (m1u1 + m2u2 = m1v1 + m2v2)'
      ],
      languageCode: 'hi',
      style: style,
      totalEstimatedDurationSeconds: 160,
    );
  }

  GeneratedScript _generateEnglishScript(
    ParsedContent content,
    TeachingStyle style,
    TeacherAvatar avatar,
  ) {
    String intro;
    switch (style) {
      case TeachingStyle.strictCoaching:
        intro = 'Hello students! I am ${avatar.name}. Newton\'s Laws carry direct high-weightage marks in JEE & NEET. Pay sharp attention to force vectors and recoil equations!';
        break;
      case TeachingStyle.friendlySibling:
        intro = 'Hey everyone! I\'m your mentor ${avatar.name}. Don\'t let physics stress you out! Today we\'ll crack Newton\'s Laws with cricket and skateboard hacks.';
        break;
      case TeachingStyle.storyMode:
        intro = 'In 1687, amid a devastating plague pandemic, young Isaac Newton looked up at the stars and unlocked the universal grammar of physical motion.';
        break;
      case TeachingStyle.warmTeacher:
        intro = 'Welcome students! I am ${avatar.name}. Today we will explore Newton\'s Three Laws of Motion and the Conservation of Linear Momentum with clear conceptual clarity.';
    }

    final sections = [
      ScriptSection(
        title: '1. First Law & The Principle of Inertia',
        scriptText:
            '$intro Newton\'s First Law states: Every object continues in its state of rest or uniform motion in a straight line unless compelled to change by an external net force. This resistance to change is known as Inertia, which directly depends on mass.',
        estimatedSeconds: 45,
        examPointers: [
          'Condition: If Net External Force = 0, Acceleration = 0',
          'Inertia is directly proportional to mass',
        ],
        visualCue: 'Vector diagram showing balanced vs unbalanced forces',
      ),
      ScriptSection(
        title: '2. Second Law: Force & Momentum (F = ma)',
        scriptText:
            'The Second Law provides the quantitative definition of force: the rate of change of momentum is proportional to the net applied force. F = dp/dt = m*a. When a cricket fielder catches a high ball, pulling their hands back increases impact time, reducing peak impulse force on the palms!',
        estimatedSeconds: 50,
        examPointers: [
          'Fundamental Equation: F = m * a (SI Unit: Newton = kg·m/s²)',
          'Impulse: J = F * Δt = Δp (Change in momentum)',
        ],
        visualCue: 'Impulse curve showing force vs contact duration',
      ),
      ScriptSection(
        title: '3. Third Law & Conservation of Linear Momentum',
        scriptText:
            'For every action, there is an equal and opposite reaction acting simultaneously on different interacting bodies. Because internal forces cancel out, in an isolated system with no external force, total momentum is conserved: m1*u1 + m2*u2 = m1*v1 + m2*v2.',
        estimatedSeconds: 65,
        examPointers: [
          'Gun Recoil Velocity: V_recoil = - (m_bullet * v_bullet) / M_gun',
          'Rocket propulsion obeys Newton\'s 3rd Law & momentum conservation',
        ],
        visualCue: 'Rocket stage separation and thrust exhaust vector',
      ),
    ];

    return GeneratedScript(
      title: 'Newton\'s Laws of Motion & Momentum Conservation',
      fullText: sections.map((s) => s.scriptText).join('\n\n'),
      sections: sections,
      highYieldExamPointers: [
        'SI unit of Momentum is kg·m/s; SI unit of Force is Newton (N)',
        'Action and reaction forces act on two DIFFERENT bodies, never canceling each other',
        'Conservation of momentum holds in both elastic and inelastic collisions'
      ],
      languageCode: 'en',
      style: style,
      totalEstimatedDurationSeconds: 160,
    );
  }

  @override
  Future<GeneratedScript> refineScript({
    required GeneratedScript currentScript,
    required String prompt,
    required TeachingStyle targetStyle,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final modifiedSections = currentScript.sections.map((s) {
      return s.copyWith(
        scriptText: '${s.scriptText} [Refined for: $prompt - simplified explanation added for clarity]',
      );
    }).toList();

    return currentScript.copyWith(
      style: targetStyle,
      sections: modifiedSections,
    );
  }

  @override
  Future<QuizData> generateQuiz({
    required String lessonId,
    required String lessonTitle,
    required String scriptText,
    required String languageCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final isBengali = languageCode == 'bn';
    final isHindi = languageCode == 'hi';

    if (isBengali) {
      return QuizData(
        id: 'quiz_$lessonId',
        lessonId: lessonId,
        lessonTitle: lessonTitle,
        questions: const [
          QuizQuestion(
            id: 'q1',
            question: 'নিউটনের প্রথম গতিসূত্র থেকে আমরা কিসের ধারণা পাই?',
            options: ['বলের পরিমাপ', 'জড়তা এবং বলের সংজ্ঞা', 'কাজের পরিমাণ', 'ত্বরণের মাত্রা'],
            correctOptionIndex: 1,
            explanation: 'প্রথম সূত্র থেকে জড়তা (Inertia) এবং বলের গুণগত সংজ্ঞা পাওয়া যায়। বলের পরিমাণ পাওয়া যায় দ্বিতীয় সূত্র থেকে।',
            topicTag: 'Inertia & Definitions',
          ),
          QuizQuestion(
            id: 'q2',
            question: 'ক্রিকেট খেলোয়াড় ক্যাচ ধরার সময় হাত পেছনে টানে কেন?',
            options: ['বল দ্রুত থামানোর জন্য', 'বলের ঘাত কমানোর জন্য সময় বাড়াতে', 'বাতাসের বাধা এড়াতে', 'হাত শক্ত রাখতে'],
            correctOptionIndex: 1,
            explanation: 'বলের সংস্পর্শ কাল (Δt) বৃদ্ধি পেলে প্রযুক্ত ঘাত বল (F = Δp/Δt) হ্রাস পায়, ফলে হাতে কম আঘাত লাগে।',
            topicTag: 'Impulse & Momentum',
          ),
          QuizQuestion(
            id: 'q3',
            question: 'একটি ১০ কেজি বন্দুক থেকে ০.০২ কেজি বুলেট ৫০০ মি/সে বেগে ছুড়লে বন্দুকের পশ্চাদপসরণ বেগ কত হবে?',
            options: ['- ১.০ মি/সে', '- ০.৫ মি/সে', '- ২.০ মি/সে', '- ০.১ মি/সে'],
            correctOptionIndex: 0,
            explanation: 'ভরবেগের সংরক্ষণ সূত্র: M*V + m*v = 0 => V = - (0.02 * 500) / 10 = - 1.0 m/s।',
            topicTag: 'Conservation Calculations',
          ),
          QuizQuestion(
            id: 'q4',
            question: 'রকেটের গতি কোন নীতির ওপর ভিত্তি করে কাজ করে?',
            options: ['শক্তির সংরক্ষণ', 'রৈখিক ভরবেগের সংরক্ষণ', 'ভরের সংরক্ষণ', 'চাপের নীতি'],
            correctOptionIndex: 1,
            explanation: 'রকেট থেকে নির্গত গ্যাসের পশ্চাদমুখী ভরবেগ রকেটকে সমপরিমাণ সম্মুখমুখী ভরবেগ প্রদান করে।',
            topicTag: 'Rocket Propulsion',
          ),
        ],
      );
    } else if (isHindi) {
      return QuizData(
        id: 'quiz_$lessonId',
        lessonId: lessonId,
        lessonTitle: lessonTitle,
        questions: const [
          QuizQuestion(
            id: 'q1',
            question: 'न्यूटन के प्रथम गति नियम से हमें किसकी परिभाषा मिलती है?',
            options: ['कार्य', 'जड़त्व एवं बल की परिभाषा', 'संवेग का परिमाण', 'गतिज ऊर्जा'],
            correctOptionIndex: 1,
            explanation: 'प्रथम नियम से जड़त्व तथा बल की गुणात्मक परिभाषा प्राप्त होती है।',
            topicTag: 'जड़त्व और परिभाषाएं',
          ),
          QuizQuestion(
            id: 'q2',
            question: 'क्रिकेट खिलाड़ी कैच लेते समय हाथ पीछे क्यों खींचता है?',
            options: ['गेंद को जल्दी रोकने के लिए', 'समय बढ़ाकर आवेग बल कम करने के लिए', 'हाथ की सुरक्षा हेतु', 'हवा का घर्षण कम करने के लिए'],
            correctOptionIndex: 1,
            explanation: 'समय (Δt) बढ़ाने से आरोपित बल F = Δp/Δt घट जाता है, जिससे हाथों पर चोट नहीं लगती।',
            topicTag: 'आवेग एवं संवेग',
          ),
          QuizQuestion(
            id: 'q3',
            question: 'रॉकेट प्रक्षेपण निम्नलिखित में से किस सिद्धांत पर आधारित है?',
            options: ['द्रव्यमान संरक्षण', 'रेखीय संवेग संरक्षण', 'ऊर्जा संरक्षण', 'कोणीय संवेग'],
            correctOptionIndex: 1,
            explanation: 'रॉकेट न्यूटन के तृतीय नियम तथा रेखीय संवेग संरक्षण के सिद्धांत पर कार्य करता है।',
            topicTag: 'रॉकेट गति',
          ),
        ],
      );
    }

    return QuizData(
      id: 'quiz_$lessonId',
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      questions: const [
        QuizQuestion(
          id: 'q1',
          question: 'Which physical concept is qualitatively defined by Newton\'s First Law?',
          options: ['Quantitative Force', 'Inertia & Definition of Force', 'Kinetic Energy', 'Work Done'],
          correctOptionIndex: 1,
          explanation: 'Newton\'s First Law defines inertia and the qualitative nature of external force.',
          topicTag: 'Inertia & Definitions',
        ),
        QuizQuestion(
          id: 'q2',
          question: 'Why does a cricketer draw their hands back while taking a catch?',
          options: ['To stop the ball instantly', 'To increase impact time and minimize peak impulse force', 'To keep arms relaxed', 'To counter aerodynamic drag'],
          correctOptionIndex: 1,
          explanation: 'By prolonging contact time Δt, the average force F = Δp/Δt is significantly reduced.',
          topicTag: 'Impulse & Momentum',
        ),
        QuizQuestion(
          id: 'q3',
          question: 'A 10 kg rifle fires a 0.02 kg bullet at 500 m/s. What is the rifle\'s recoil velocity?',
          options: ['- 1.0 m/s', '- 0.5 m/s', '- 2.0 m/s', '- 0.2 m/s'],
          correctOptionIndex: 0,
          explanation: 'By momentum conservation: M*V + m*v = 0 => V = - (0.02 * 500) / 10 = - 1.0 m/s.',
          topicTag: 'Conservation Calculations',
        ),
      ],
    );
  }

  @override
  Future<DoubtResponse> solveDoubt({
    required String lessonId,
    required String doubtQuery,
    required TeacherAvatar avatar,
    required String languageCode,
    required TeachingStyle style,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (languageCode == 'bn') {
      return DoubtResponse(
        question: doubtQuery,
        answerSummary: 'ক্রিয়া এবং প্রতিক্রিয়া কখনোই একে অপরকে প্রশমিত (cancel) করে না, কারণ তারা দুটি সম্পূর্ণ আলাদা বস্তুর ওপর কাজ করে।',
        fullExplanation:
            'নমস্কার! তোমার প্রশ্নটি খুবই গুরুত্বপূর্ণ। যখন তুমি টেবিলের ওপর হাত দিয়ে চাপ দাও (ক্রিয়া), টেবিলও তোমার হাতের ওপর সমান ও বিপরীত বল প্রয়োগ করে (প্রতিক্রিয়া)। একটি বল কাজ করছে টেবিলের ওপর, আর অন্য বলটি কাজ করছে তোমার হাতের ওপর! যেহেতু বল দুটি দুটি আলাদা বস্তুর ওপর প্রযুক্ত হচ্ছে, তাই তারা কখনো একে অপরকে বাতিল বা cancel করতে পারে না।',
        regionalAudioOrVideoUrl: 'https://vidyaguru.gov.in/demo/doubt_stream_bn.mp4',
        relatedConcepts: ['Newton 3rd Law', 'Free Body Diagrams', 'Action-Reaction Pairs'],
      );
    } else if (languageCode == 'hi') {
      return DoubtResponse(
        question: doubtQuery,
        answerSummary: 'क्रिया और प्रतिक्रिया बल कभी एक-दूसरे को निरस्त (cancel) नहीं करते क्योंकि वे दो अलग-अलग वस्तुओं पर लगते हैं।',
        fullExplanation:
            'शानदार सवाल! हमेशा याद रखें कि क्रिया और प्रतिक्रिया बल एक ही वस्तु पर नहीं लगते। जब आप गेंद को लात मारते हैं, तो क्रिया गेंद पर होती है और प्रतिक्रिया आपके पैर पर! चूँकि दोनों बल अलग-अलग पिंडों पर लग रहे हैं, इसलिए परिणामी बल शून्य नहीं होता।',
        regionalAudioOrVideoUrl: 'https://vidyaguru.gov.in/demo/doubt_stream_hi.mp4',
        relatedConcepts: ['न्यूटन का तीसरा नियम', 'मुक्त पिंड आरेख', 'क्रिया-प्रतिक्रिया युग्म'],
      );
    }

    return DoubtResponse(
      question: doubtQuery,
      answerSummary: 'Action and reaction forces never cancel each other because they act on two completely distinct interacting bodies.',
      fullExplanation:
          'Great question! For two forces to cancel each other into static equilibrium, they must act upon the EXACT SAME body. Action and reaction forces act simultaneously on different bodies (e.g., your foot vs the ball). Hence, they can never cancel out!',
      regionalAudioOrVideoUrl: 'https://vidyaguru.gov.in/demo/doubt_stream_en.mp4',
      relatedConcepts: ['Newton\'s 3rd Law', 'Free Body Diagram', 'Interaction Pairs'],
    );
  }
}
