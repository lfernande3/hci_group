/// Demo chatbot message data
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? quickReplies;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.quickReplies,
  });
}

/// Demo chatbot conversation data
class ChatbotData {
  /// Get initial demo messages
  static List<ChatMessage> getInitialMessages() {
    return [
      ChatMessage(
        id: 'bot_1',
        text: 'Hello! I\'m CityUHK Assistant. How can I help you today?',
        isUser: false,
        timestamp: DateTime(2024, 1, 1, 10, 0),
        quickReplies: const [
          'Class Schedule',
          'Campus Services',
          'Library Help',
          'General Questions',
        ],
      ),
      ChatMessage(
        id: 'user_1',
        text: 'Hi! Can you help me find my class schedule?',
        isUser: true,
        timestamp: DateTime(2024, 1, 1, 10, 1),
      ),
      ChatMessage(
        id: 'bot_2',
        text: 'Of course! You can view your class schedule in the Timetable section. I can also help you find specific classes or check room availability. What would you like to know?',
        isUser: false,
        timestamp: DateTime(2024, 1, 1, 10, 2),
        quickReplies: const [
          'View Timetable',
          'Room Booking',
          'Find Building',
        ],
      ),
      ChatMessage(
        id: 'user_2',
        text: 'Where is the library?',
        isUser: true,
        timestamp: DateTime(2024, 1, 1, 10, 3),
      ),
      ChatMessage(
        id: 'bot_3',
        text: 'The Run Run Shaw Library is located in the Academic Building 3 (AC3). It\'s open Monday to Friday from 8:00 AM to 10:00 PM, and weekends from 9:00 AM to 5:00 PM. You can also use the Campus Map feature to get directions!',
        isUser: false,
        timestamp: DateTime(2024, 1, 1, 10, 4),
        quickReplies: const [
          'Library Hours',
          'Study Rooms',
          'Print Services',
        ],
      ),
      ChatMessage(
        id: 'user_3',
        text: 'Thanks!',
        isUser: true,
        timestamp: DateTime(2024, 1, 1, 10, 5),
      ),
      ChatMessage(
        id: 'bot_4',
        text: 'You\'re welcome! Feel free to ask me anything else about CityUHK services or campus life.',
        isUser: false,
        timestamp: DateTime(2024, 1, 1, 10, 6),
      ),
    ];
  }

  /// Get demo response for a user message
  static ChatMessage getBotResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('schedule') || lowerMessage.contains('timetable') || lowerMessage.contains('class')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'You can view your full class schedule in the Timetable tab. You can also check upcoming classes and get notifications about schedule changes.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['View Timetable', 'Next Class', 'Room Booking'],
      );
    } else if (lowerMessage.contains('library') || lowerMessage.contains('book') || lowerMessage.contains('study')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'The Run Run Shaw Library is in AC3. You can book study rooms, access online resources, and use printing services there. Would you like to know more about any of these services?',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Study Rooms', 'Print Services', 'Library Hours'],
      );
    } else if (lowerMessage.contains('cafeteria') || lowerMessage.contains('food') || lowerMessage.contains('eat')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'There are several dining options on campus: The Canteen (AC1), Cafe (AC2), and Food Court (AC3). All are open Monday to Friday from 7:30 AM to 8:00 PM.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Menu', 'Hours', 'Location'],
      );
    } else if (lowerMessage.contains('help') || lowerMessage.contains('support')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'I\'m here to help! I can assist with class schedules, campus services, library information, and general questions about CityUHK. What do you need help with?',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Class Schedule', 'Campus Services', 'Library Help'],
      );
    } else {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'I understand you\'re asking about "$userMessage". Let me help you with that. You can check the relevant sections in the app, or I can provide more specific information. What would you like to know?',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Class Schedule', 'Campus Services', 'Library Help'],
      );
    }
  }
}

