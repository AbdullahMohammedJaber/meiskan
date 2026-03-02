class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool seen;
  final DateTime createdAt;
  final String projectId;
  NotificationModel({
    required this.id,
    required this.message,
    required this.title,
    required this.seen,
    required this.createdAt,
    required this.projectId
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["notification_Id"] as int? ?? 0,
        message: (json["notification_Message"] as String? ?? ""),
        title: (json["notification_Title"] as String? ?? ""),
        seen: (json["is_Read"] as bool? ?? false),
        createdAt: DateTime.tryParse((json["created_At"] as String? ?? "")) ??
            DateTime.now(),
        projectId: (json["project_Id"] as String? ?? ""),
      );
}
