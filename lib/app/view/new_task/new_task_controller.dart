import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/models/todo_model.dart';
import 'package:todo_app/app/repositories/todo_repository.dart';

class NewTaskController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('dd/MM/yyyy');
  final TodosRepository repository;
  late DateTime dayselected;
  TextEditingController nomeTaskCotroller = TextEditingController();
  bool saved = false;
  bool loading = false;
  String error = 'error';

  String get dayFormated => dateFormat.format(dayselected);

  NewTaskController({required this.repository, String? day}) {
    dayselected = dateFormat.parse(day!);
  }

  Future<void> save() async {
    try {
      if (formKey.currentState!.validate()) {
        loading = true;
        saved = false;
        await repository.saveTodo(dayselected, nomeTaskCotroller.text);
        saved = true;
        loading = false;
      }
    } catch (e) {
      print(e);
      error = 'Erro ao salvar Todo';
    }
    notifyListeners();
  }
}
