import '../../../features/events/data/models/event_model.dart';
import '../../../features/timetable/data/models/timetable_model.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/events/domain/entities/event.dart';
import '../../../features/auth/domain/entities/user.dart';

/// Mock JSON data for demo purposes
class MockJsonData {
  /// Mock user data
  static const UserModel mockUser = UserModel(
    id: 'user_123',
    email: 'john.doe@student.cityu.edu.hk',
    fullName: 'John Doe',
    studentId: '123456789',
    isLoggedIn: true,
    userType: UserType.student,
  );

  /// Mock events data
  static final List<EventModel> events = [
    // Today's events
    EventModel(
      id: 'event_1',
      title: 'Computer Networks',
      description: 'CS3201 - Introduction to Computer Networks',
      startTime: DateTime.now().add(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
      location: 'Academic Building 1',
      room: 'AC1-LT9',
      type: EventType.lecture,
      courseCode: 'CS3201',
      instructor: 'Dr. Smith',
    ),
    EventModel(
      id: 'event_2',
      title: 'Mobile App Development',
      description: 'CS4186 - Mobile Application Development',
      startTime: DateTime.now().add(const Duration(hours: 4)),
      endTime: DateTime.now().add(const Duration(hours: 5, minutes: 30)),
      location: 'Yeung Building',
      room: 'Y6-603',
      type: EventType.tutorial,
      courseCode: 'CS4186',
      instructor: 'Prof. Johnson',
    ),
    
    // Tomorrow's events
    EventModel(
      id: 'event_3',
      title: 'Database Systems',
      description: 'CS3334 - Database Systems',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 10, minutes: 30)),
      location: 'Academic Building 2',
      room: 'AC2-LT7',
      type: EventType.lecture,
      courseCode: 'CS3334',
      instructor: 'Dr. Wong',
    ),
    EventModel(
      id: 'event_4',
      title: 'Software Engineering',
      description: 'CS3342 - Software Engineering',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 14)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 15, minutes: 30)),
      location: 'Lau Ming Wai Academic Building',
      room: 'LMW-LT2',
      type: EventType.lecture,
      courseCode: 'CS3342',
      instructor: 'Prof. Chen',
    ),
    
    // Next week events
    EventModel(
      id: 'event_5',
      title: 'AI and Machine Learning',
      description: 'CS4480 - Artificial Intelligence',
      startTime: DateTime.now().add(const Duration(days: 7, hours: 10)),
      endTime: DateTime.now().add(const Duration(days: 7, hours: 11, minutes: 30)),
      location: 'Academic Building 3',
      room: 'AC3-LT4',
      type: EventType.lecture,
      courseCode: 'CS4480',
      instructor: 'Dr. Lee',
    ),
    
    // Upcoming exam
    EventModel(
      id: 'event_6',
      title: 'CS3201 Final Exam',
      description: 'Computer Networks Final Examination',
      startTime: DateTime.now().add(const Duration(days: 14, hours: 9)),
      endTime: DateTime.now().add(const Duration(days: 14, hours: 12)),
      location: 'Sports Complex',
      room: 'SC-Hall A',
      type: EventType.exam,
      courseCode: 'CS3201',
      instructor: 'Dr. Smith',
    ),
  ];

  /// Academic calendar events
  static final List<EventModel> academicEvents = [
    EventModel(
      id: 'academic_1',
      title: 'Semester 1 Begins',
      description: 'First semester classes begin',
      startTime: DateTime(DateTime.now().year, 9, 1, 9, 0),
      endTime: DateTime(DateTime.now().year, 9, 1, 17, 0),
      location: 'Campus Wide',
      type: EventType.event,
      isAllDay: true,
    ),
    EventModel(
      id: 'academic_2',
      title: 'Mid-term Break',
      description: 'Mid-semester break period',
      startTime: DateTime(DateTime.now().year, 10, 15, 0, 0),
      endTime: DateTime(DateTime.now().year, 10, 22, 23, 59),
      location: 'Campus Wide',
      type: EventType.event,
      isAllDay: true,
    ),
    EventModel(
      id: 'academic_3',
      title: 'Final Examinations',
      description: 'Final examination period begins',
      startTime: DateTime(DateTime.now().year, 12, 5, 9, 0),
      endTime: DateTime(DateTime.now().year, 12, 19, 18, 0),
      location: 'Various Locations',
      type: EventType.exam,
      isAllDay: false,
    ),
  ];

  /// Get timetable for user
  static TimetableModel getTimetable(String userId) {
    return TimetableModel(
      id: 'timetable_$userId',
      userId: userId,
      semester: 'Semester 1',
      year: DateTime.now().year,
      events: events,
      lastUpdated: DateTime.now(),
    );
  }

  /// Get timetable for specific semester
  static TimetableModel getTimetableForSemester(
    String userId,
    String semester,
    int year,
  ) {
    return TimetableModel(
      id: 'timetable_${userId}_${semester}_$year',
      userId: userId,
      semester: semester,
      year: year,
      events: events,
      lastUpdated: DateTime.now(),
    );
  }

  /// News feed mock data
  static final List<Map<String, dynamic>> newsFeed = [
    {
      'id': 'news_1',
      'title': 'CityUHK Ranks Among Top Universities',
      'summary': 'CityU continues to excel in global university rankings',
      'imageUrl': null,
      'publishDate': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'category': 'University News',
    },
    {
      'id': 'news_2',
      'title': 'New Research Center Opens',
      'summary': 'State-of-the-art AI research facility inaugurated',
      'imageUrl': null,
      'publishDate': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'category': 'Research',
    },
    {
      'id': 'news_3',
      'title': 'Student Exchange Programs',
      'summary': 'Applications now open for international exchange',
      'imageUrl': null,
      'publishDate': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'category': 'Student Life',
    },
  ];

  /// CAP (Co-curricular Activities Programme) mock data
  static final List<Map<String, dynamic>> capActivities = [
    {
      'id': 'cap_1',
      'title': 'Photography Workshop',
      'description': 'Learn basic photography techniques',
      'date': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'location': 'Student Activity Centre',
      'category': 'Arts & Culture',
      'spotsAvailable': 15,
    },
    {
      'id': 'cap_2',
      'title': 'Community Service Project',
      'description': 'Volunteer at local elderly center',
      'date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      'location': 'Off-campus',
      'category': 'Community Service',
      'spotsAvailable': 20,
    },
    {
      'id': 'cap_3',
      'title': 'Leadership Training',
      'description': 'Develop leadership skills workshop',
      'date': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
      'location': 'Conference Room A',
      'category': 'Leadership',
      'spotsAvailable': 25,
    },
  ];

  /// CityUTube (University video platform) mock data
  static final List<Map<String, dynamic>> cityuTubeVideos = [
    {
      'id': 'video_1',
      'title': 'Campus Tour 2024',
      'description': 'Virtual tour of CityU campus facilities',
      'thumbnailUrl': null,
      'duration': '12:34',
      'uploadDate': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'category': 'Campus Life',
      'views': 1250,
    },
    {
      'id': 'video_2',
      'title': 'Research Spotlight: AI Innovation',
      'description': 'Latest research in artificial intelligence',
      'thumbnailUrl': null,
      'duration': '8:45',
      'uploadDate': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'category': 'Research',
      'views': 890,
    },
    {
      'id': 'video_3',
      'title': 'Student Success Stories',
      'description': 'Alumni sharing their career journeys',
      'thumbnailUrl': null,
      'duration': '15:22',
      'uploadDate': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'category': 'Alumni',
      'views': 2100,
    },
  ];

  /// Combined feeds for homepage display
  static List<FeedItem> get feeds {
    final List<FeedItem> allFeeds = [];
    
    // Add news items
    for (final news in newsFeed) {
      allFeeds.add(FeedItem(
        id: news['id'],
        title: news['title'],
        summary: news['summary'],
        publishedDate: DateTime.parse(news['publishDate']),
        category: news['category'],
        type: 'news',
      ));
    }
    
    // Add CAP activities
    for (final cap in capActivities) {
      allFeeds.add(FeedItem(
        id: cap['id'],
        title: cap['title'],
        summary: cap['description'],
        publishedDate: DateTime.parse(cap['date']),
        category: cap['category'],
        type: 'cap',
      ));
    }
    
    // Add video items
    for (final video in cityuTubeVideos) {
      allFeeds.add(FeedItem(
        id: video['id'],
        title: video['title'],
        summary: video['description'],
        publishedDate: DateTime.parse(video['uploadDate']),
        category: video['category'],
        type: 'video',
      ));
    }
    
    // Sort by published date (newest first)
    allFeeds.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    
    return allFeeds;
  }
}

/// Feed item model for unified display
class FeedItem {
  final String id;
  final String title;
  final String summary;
  final DateTime publishedDate;
  final String category;
  final String type; // 'news', 'cap', 'video'
  
  FeedItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.publishedDate,
    required this.category,
    required this.type,
  });
}
