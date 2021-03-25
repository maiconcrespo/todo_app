import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/models/todo_model.dart';
import 'package:todo_app/app/repositories/todo_repository.dart';
import 'package:collection/collection.dart';

class HomeController extends ChangeNotifier {
  final TodosRepository repository;
  int selectedTab = 1;
  late DateTime startFilter;
  late DateTime endFilter;
  Map<String, List<TodoModel>>? listTodos;
  HomeController({required this.repository}) {
    findAllForWeek();
  }

  void changeSelectedTab(index) {
    selectedTab = index;
    notifyListeners();
  }

  Future<void> findAllForWeek() async {
    var dateFormat = DateFormat('dd/MM/yyyy');

    startFilter = DateTime.now();

    if (startFilter.weekday != DateTime.monday) {
      startFilter = startFilter.subtract(
        Duration(days: (startFilter.weekday - 1)),
      );
    }
    endFilter = startFilter.add(Duration(days: 6));

    var todos = await repository.findByPeriod(startFilter, endFilter);

    if (todos.isEmpty) {
      listTodos = {dateFormat.format(DateTime.now()): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.dataHora));
    }
    this.notifyListeners();
  }
}
