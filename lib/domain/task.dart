
import 'package:json_annotation/json_annotation.dart';
part 'task.g.dart';
@JsonSerializable()
class Task {
  final String id;
  final String title;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json)=> _$TaskFromJson(json);
}


