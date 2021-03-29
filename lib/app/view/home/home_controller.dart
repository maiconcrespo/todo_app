import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/models/todo_model.dart';
import 'package:todo_app/app/repositories/todo_repository.dart';
import 'package:collection/collection.dart';

class HomeController extends ChangeNotifier {
  late DateTime daySelected;
  final TodosRepository repository;
  int selectedTab = 1;
  late DateTime startFilter;
  late DateTime endFilter;
  Map<String, List<TodoModel>> listTodos = {};
  var dateFormat = DateFormat('dd/MM/yyyy');

  HomeController({required this.repository}) {
    //repository.saveTodo(DateTime.now().add(Duration(days: 1)), 'Flutter 4');
    //repository.saveTodo(DateTime.now().subtract(Duration(days: 0)), 'Dart 3');
    findAllForWeek();
  }

  Future<void> findAllForWeek() async {
    daySelected = DateTime.now();

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
          // GroupBy nao importa por padrao
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.dataHora));
    }
    this.notifyListeners();
  }

  Future<void> changeSelectedTab(BuildContext context, int index) async {
    selectedTab = index;
    switch (index) {
      case 0:
        filterFinalized();
        break;
      case 1:
        findAllForWeek();
        break;
      case 2:
        var day = await showDatePicker(
          context: context,
          initialDate: daySelected,
          firstDate: DateTime.now().subtract(Duration(days: (360 * 3))),
          lastDate: DateTime.now().add(Duration(days: (360 * 10))),
        );
        if (day != null) {
          daySelected = day;
        }

        findTodosbySelectedDay();
        break;
    }
    notifyListeners();
  }

  void checkedOrUncheck(TodoModel todo) {
    todo.finalizado = !todo.finalizado;
    this.notifyListeners();
    repository.checkOrUncheckTodo(todo);
  }

  void filterFinalized() {
    listTodos = listTodos.map((key, value) {
      var todosFinalized = value.where((t) => t.finalizado).toList();
      return MapEntry(key, todosFinalized);
    });

    this.notifyListeners();
  }

  Future<void> findTodosbySelectedDay() async {
    var todos = await repository.findByPeriod(daySelected, daySelected);

    if (todos.isEmpty) {
      listTodos = {dateFormat.format(daySelected): []};
      print('data');
    } else {
      listTodos =
          // GroupBy nao importa por padrao
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.dataHora));
    }
    this.notifyListeners();
  }

  Future<void> update() async {
    if (selectedTab == 1) {
      this.findAllForWeek();
    } else if (selectedTab == 2) {
      this.findTodosbySelectedDay();
    }
  }

  Future<void> remove(TodoModel todo) async {
    await repository.removeTodo(todo.id);
    this.update();
  }
}
