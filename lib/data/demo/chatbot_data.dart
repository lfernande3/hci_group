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
    } else if (lowerMessage.contains('cafeteria') || lowerMessage.contains('food') || lowerMessage.contains('eat') || lowerMessage.contains('dining')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'There are several dining options on campus: The Canteen (AC1), Cafe (AC2), and Food Court (AC3). All are open Monday to Friday from 7:30 AM to 8:00 PM. The Canteen offers Chinese and Western meals, while the Cafe has coffee, sandwiches, and light snacks.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Menu', 'Hours', 'Location'],
      );
    } else if (lowerMessage.contains('print') || lowerMessage.contains('printing') || lowerMessage.contains('printer')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'You can print documents from the Print section in the app. Choose your building (AC2, CMC, or Library), select print type (Free B/W, Charged B/W, or Charged Color), and follow the release instructions. Make sure you\'re connected to CityU Wi-Fi!',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Print Locations', 'Print Types', 'Wi-Fi Help'],
      );
    } else if (lowerMessage.contains('book') || lowerMessage.contains('booking') || lowerMessage.contains('reserve')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'You can book study rooms, classrooms, sports facilities, and music rooms from the Booking section. Just select the category, choose a room, and pick an available time slot. Bookings are available up to 7 days in advance.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Study Rooms', 'Sports Facilities', 'How to Book'],
      );
    } else if (lowerMessage.contains('laundry') || lowerMessage.contains('washer') || lowerMessage.contains('dryer')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Check the Laundry Management section to see real-time status of washers and dryers in your hall. You can filter by machine type, book available machines, or set alerts for when machines become free. Each stack has a dryer on top and washer below.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Laundry Status', 'How to Book', 'Set Alert'],
      );
    } else if (lowerMessage.contains('event') || lowerMessage.contains('activity') || lowerMessage.contains('workshop')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Browse upcoming events in the Events section! You\'ll find academic workshops, sports competitions, cultural activities, and more. Events are organized by CRESDA, student clubs, and departments. You can filter by category or search for specific events.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['View Events', 'Academic Events', 'Sports Events'],
      );
    } else if (lowerMessage.contains('wifi') || lowerMessage.contains('wi-fi') || lowerMessage.contains('network')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Connect to "CityU" Wi-Fi network. Your CityU ID and password are required. For printing services, you must be on campus Wi-Fi. If you\'re having connection issues, try forgetting the network and reconnecting, or contact IT Support.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Wi-Fi Setup', 'IT Support', 'Print Help'],
      );
    } else if (lowerMessage.contains('help') || lowerMessage.contains('support') || lowerMessage.contains('question')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'I\'m here to help! I can assist with class schedules, campus services, library information, booking rooms, printing, laundry management, events, and general questions about CityUHK. What do you need help with?',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Class Schedule', 'Campus Services', 'Library Help', 'Booking Help'],
      );
    } else if (lowerMessage.contains('id') || lowerMessage.contains('card') || lowerMessage.contains('student id')) {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Your CityU ID card can be accessed in the CityU ID section. You can view your QR code for building access, library services, and more. Make sure to keep your ID card with you on campus.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['View ID', 'QR Code', 'Access Help'],
      );
    } else {
      return ChatMessage(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: 'I understand you\'re asking about "$userMessage". Let me help you with that. You can check the relevant sections in the app, or I can provide more specific information. What would you like to know?',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: ['Class Schedule', 'Campus Services', 'Library Help', 'Booking Help'],
      );
    }
  }
}

