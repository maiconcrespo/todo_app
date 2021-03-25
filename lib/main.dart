import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/database/connection.dart';
import 'package:todo_app/app/database/migration_v1.dart/database_adm_connection.dart';
import 'package:todo_app/app/repositories/todo_repository.dart';
import 'package:todo_app/app/view/home/home_controller.dart';
import 'package:todo_app/app/view/new_task/new_task_controller.dart';
import 'package:todo_app/app/view/new_task/new_task_page.dart';

import 'app/view/home/home_page.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  DatabaseAdmConnection databaseAdmConnection = DatabaseAdmConnection();

  @override
  void initState() {
    super.initState();
    Connection().instance;
    WidgetsBinding.instance!.addObserver(databaseAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(databaseAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TodosRepository(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xfff57f17),
          buttonColor: Color(0xfff57f17),
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        routes: {
          NewTaskPage.routerName: (context) => ChangeNotifierProvider(
                create: (context) => NewTaskController(
                    repository: context.read<TodosRepository>()),
                child: NewTaskPage(),
              )
        },
        home: ChangeNotifierProvider(
          create: (context) =>
              HomeController(repository: context.read<TodosRepository>()),
          child: HomePage(),
        ),
      ),
    );
  }
}
