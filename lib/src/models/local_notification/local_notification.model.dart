import 'dart:convert';
import 'package:hive/hive.dart';

part 'local_notification.model.g.dart';

@HiveType(typeId: 2)
class LocalNotificationModel {

  LocalNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.payload = '',
    this.isRead = false
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime scheduledTime;

  final String payload;
  
  @HiveField(4)
  bool isRead;

  factory LocalNotificationModel.fromJsonString(String json) {
    return LocalNotificationModel.fromJson(jsonDecode(json));
  }

  factory LocalNotificationModel.fromJson(Map<String, dynamic> json) {
    return LocalNotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
    );
  }
}