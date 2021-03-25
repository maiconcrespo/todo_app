import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
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
            onTap: (index) {
              print(index);
              return controller.changeSelectedTab(index);
            },
          ),
          body: Container(
            width: size.width,
            height: size.height,
            child: ListView.builder(
              itemCount: controller.listTodos?.keys.length ?? 0,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Hoje',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                          IconButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(NewTaskPage.routerName),
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
                      itemCount: 4,
                      itemBuilder: (_, index) {
                        return ListTile(
                          leading: Checkbox(
                            value: false,
                            onChanged: (_) {},
                          ),
                          title: (Text(
                            'Tarefa X',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                decoration: true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          )),
                          trailing: (Text(
                            '06:00',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                decoration: true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          )),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
