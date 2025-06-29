import 'package:hive/hive.dart';

part 'scenario.g.dart';

@HiveType(typeId: 0)
class Scenario extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final String titleAr;

  @HiveField(3)
  final String titleEn;

  @HiveField(4)
  final List<Map<String, String>> steps;

  Scenario({
    required this.id,
    required this.categoryId,
    required this.titleAr,
    required this.titleEn,
    required this.steps,
  });
}
