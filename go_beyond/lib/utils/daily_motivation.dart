import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class DailyMotivation {
  static final Random _random = Random();

  static const String _sessionMotivationKey = 'session_motivation';

  static const List<String> messages = [
    'Small steps every day lead to big results.',
    'You are stronger than you think.',
    'Progress is progress, no matter how small.',
    'Today is a new chance to improve.',
    'Discipline beats motivation when motivation fades.',
    'Do something today your future self will thank you for.',
    'You do not need to be perfect, you just need to begin.',
    'Consistency creates confidence.',
    'One good decision can change your whole day.',
    'Your effort today builds your success tomorrow.',
    'Keep going. You are closer than you think.',
    'A little progress each day adds up.',
    'Do not stop because it is hard. Continue because it matters.',
    'Your goals are worth the effort.',
    'You are capable of more than you realize.',
    'Start where you are. Use what you have. Do what you can.',
    'Every challenge is a chance to grow.',
    'You only fail when you stop trying.',
    'Focus on progress, not perfection.',
    'The best time to start is now.',
    'Believe in the work you are doing.',
    'Your future depends on what you do today.',
    'Stay patient. Good things take time.',
    'You are building something meaningful.',
    'Push yourself because no one else can do it for you.',
    'Success starts with showing up.',
    'Do not compare your journey to someone else’s.',
    'You have made it through hard days before.',
    'Your mindset can change your outcome.',
    'Keep your promise to yourself today.',
    'Great things come from small beginnings.',
    'Your effort is not wasted.',
    'One step forward is still forward.',
    'Stay focused on the person you are becoming.',
    'You can do hard things.',
    'The work you avoid is often the work that changes you.',
    'Make today count.',
    'You are allowed to grow slowly.',
    'Your habits shape your future.',
    'Choose progress over excuses.',
    'You do not need more time. You need more focus.',
    'Every day is a chance to reset.',
    'Do it even if you do not feel ready.',
    'Your discipline today becomes your freedom tomorrow.',
    'The pain of discipline is better than the pain of regret.',
    'Keep moving, even if it is slow.',
    'You are not behind. You are on your own path.',
    'Your dreams need action, not just wishes.',
    'You have the power to change your story.',
    'Hard work will pay off if you stay consistent.',
    'Be proud of yourself for trying.',
    'Today’s effort creates tomorrow’s confidence.',
    'You are becoming better every day.',
    'Do not let one bad day stop your progress.',
    'The goal is not to be perfect. The goal is to improve.',
    'Your future self is watching your choices today.',
    'Start small, but start now.',
    'You can restart as many times as you need.',
    'Every expert was once a beginner.',
    'You are one decision away from a better direction.',
    'Do not wait for confidence. Build it by taking action.',
    'Success is built when no one is watching.',
    'Your consistency is your superpower.',
    'You are not stuck. You are learning.',
    'The struggle is part of the process.',
    'Keep your eyes on your goal.',
    'You are stronger than your excuses.',
    'Take the next step, even if it is small.',
    'Your goals deserve your attention.',
    'Believe in your ability to figure things out.',
    'Today is another opportunity to become better.',
    'You have already come far. Keep going.',
    'Action creates momentum.',
    'You do not need to do everything today. Just do something.',
    'Do not quit on yourself.',
    'Better days are built by better habits.',
    'Your courage grows every time you try.',
    'Stay consistent, even when it feels boring.',
    'Your progress matters.',
    'You are learning, improving, and growing.',
    'One focused hour can change your day.',
    'You are in control of your next move.',
    'Every effort counts.',
    'You are building discipline one choice at a time.',
    'The beginning is always the hardest.',
    'Keep showing up for yourself.',
    'You are not failing. You are practicing.',
    'A better version of you is built daily.',
    'Your patience will be rewarded.',
    'Focus on what you can control.',
    'Make the next choice a good one.',
    'Your goals are possible with consistent action.',
    'You are stronger than today’s difficulty.',
    'Do not let fear make your decisions.',
    'The only way forward is to keep moving.',
    'You deserve the life you are working for.',
    'Every day you try, you win.',
    'Turn your intention into action.',
    'You are capable of building something great.',
    'Keep going. Your future is worth it.',
  ];

  static String randomMessage() {
    return messages[_random.nextInt(messages.length)];
  }

  static Future<String> chooseNewForSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    final message = randomMessage();

    await prefs.setString(_sessionMotivationKey, message);

    return message;
  }

  static Future<String> getCurrentSignInMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMessage = prefs.getString(_sessionMotivationKey);

    if (savedMessage != null && savedMessage.isNotEmpty) {
      return savedMessage;
    }

    return chooseNewForSignIn();
  }
}
