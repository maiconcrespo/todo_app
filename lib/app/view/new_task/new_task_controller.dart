import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/models/todo_model.dart';
import 'package:todo_app/app/repositories/todo_repository.dart';

class NewTaskController extends ChangeNotifier {
  final TodosRepository repository;

  NewTaskController({required this.repository});
}
