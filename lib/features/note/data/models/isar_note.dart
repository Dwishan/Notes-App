import 'package:isar/isar.dart';

part 'isar_note.g.dart';

@Collection()
class IsarNote {
  Id id = Isar.autoIncrement;
  late String title;
  String? description;
}

