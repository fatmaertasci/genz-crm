import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> schedulePaymentReminder({
    required String customerId,
    required String customerName,
    required DateTime paymentDate,
  }) async {
    // Ödeme tarihinden 3 gün önce bildirim gönder
    final scheduledDate = tz.TZDateTime.from(
      paymentDate.subtract(const Duration(days: 3)),
      tz.local,
    );

    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    await _notifications.zonedSchedule(
      int.parse(customerId), // Her müşteri için benzersiz bir ID
      'Ödeme Hatırlatması',
      '$customerName için ödeme tarihi yaklaşıyor',
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'payment_channel',
          'Ödeme Bildirimleri',
          channelDescription:
              'Ödeme tarihi yaklaşan müşteriler için bildirimler',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleServiceReminder({
    required String customerId,
    required String customerName,
    required DateTime endDate,
  }) async {
    // Hizmet bitiş tarihinden 1 hafta önce bildirim gönder
    final scheduledDate = tz.TZDateTime.from(
      endDate.subtract(const Duration(days: 7)),
      tz.local,
    );

    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    await _notifications.zonedSchedule(
      int.parse(customerId) + 100000, // Ödeme bildirimleriyle karışmasın
      'Hizmet Hatırlatması',
      '$customerName için hizmet bitiş tarihi yaklaşıyor',
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'service_channel',
          'Hizmet Bildirimleri',
          channelDescription:
              'Hizmet bitiş tarihi yaklaşan müşteriler için bildirimler',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelCustomerNotifications(String customerId) async {
    await _notifications.cancel(int.parse(customerId)); // Ödeme bildirimi
    await _notifications
        .cancel(int.parse(customerId) + 100000); // Hizmet bildirimi
  }
}
