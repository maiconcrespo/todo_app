import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/shared/time_component.dart';
import 'package:todo_app/app/view/new_task/new_task_controller.dart';

class NewTaskPage extends StatelessWidget {
  static String routerName = '/new';

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTaskController>(
      builder: (BuildContext context, controller, _) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOVA TASK',
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 34),
                    Text(
                      'Data',
                      style: TextStyle(
                          color: Colors.grey[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '08/05/2020',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nome da Task',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)))),
                    ),
                    SizedBox(height: 21),
                    Text(
                      'Hora',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 21),
                    TimeComponent(),
                    SizedBox(height: 50),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .8,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(0),
                          // boxShadow: [
                          //   BoxShadow(
                          //       blurRadius: 34,
                          //       color: Theme.of(context).primaryColor)]
                        ),
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Salvar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 21),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
