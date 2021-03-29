import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:provider/provider.dart';
import 'package:todo_app/app/view/home/home_controller.dart';
import 'package:todo_app/app/view/new_task/new_task_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Atividades',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: ConvexAppBar(
            color: Colors.white70,
            backgroundColor: Theme.of(context).primaryColor,
            items: [
              TabItem(icon: Icons.check_circle, title: 'Finalizados'),
              TabItem(icon: Icons.view_week, title: 'Semanal'),
              TabItem(icon: Icons.calendar_today, title: 'Selec. Data'),
            ],
            initialActiveIndex: controller.selectedTab, //optional, default as 0
            onTap: (index) async {
              print(index);
              return await controller.changeSelectedTab(context, index);
            },
          ),
          body: Container(
            width: size.width,
            height: size.height,
            child: RefreshIndicator(
              onRefresh: () => controller.update(),
              child: ListView.builder(
                itemCount: controller.listTodos.keys.length,
                itemBuilder: (_, index) {
                  var dateFormat = DateFormat('dd/MM/yyyy');
                  var listTodos = controller.listTodos;
                  var dayKey = listTodos.keys.elementAt(index);
                  var day = dayKey;
                  var todos = listTodos[dayKey];

                  if (todos!.isEmpty && controller.selectedTab == 0) {
                    return SizedBox.shrink();
                  }

                  var today = DateTime.now();

                  if (dayKey == dateFormat.format(today)) {
                    day = 'HOJE';
                    print(day);
                  } else if (dayKey ==
                      dateFormat.format(today.add(Duration(days: 1)))) {
                    day = 'AMANHÃ';
                  }

                  return Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              day,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )),
                            IconButton(
                              onPressed: () async {
                                await Navigator.of(context).pushNamed(
                                    NewTaskPage.routerName,
                                    arguments: dayKey);
                                // ignore: unnecessary_statements
                                controller.update;
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: todos.length,
                        itemBuilder: (_, index) {
                          var todo = todos[index];
                          return Dismissible(
                            key: Key(todo.id.toString()),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (context) async {
                              return await _buildConfirmDismiss(_);
                            },
                            onDismissed: (_) => controller.remove(todo),
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: Theme.of(context).primaryColor,
                                value: todo.finalizado,
                                onChanged: (bool? value) =>
                                    controller.checkedOrUncheck(todo),
                              ),
                              title: (Text(
                                todo.descricao,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    decoration: todo.finalizado
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              )),
                              trailing: (Text(
                                '${todo.dataHora.hour.toString().padLeft(2, '0')}:${todo.dataHora.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    decoration: todo.finalizado
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              )),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _buildConfirmDismiss(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Excluir!'),
            content: const Text('Deseja Eliminar?'),
            actions: [
              OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('OK')),
              OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'))
            ],
          );
        });
  }
}
