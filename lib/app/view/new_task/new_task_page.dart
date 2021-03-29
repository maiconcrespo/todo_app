import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/shared/time_component.dart';
import 'package:todo_app/app/view/new_task/new_task_controller.dart';

class NewTaskPage extends StatefulWidget {
  static String routerName = '/new';

  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<NewTaskController>(context, listen: false).addListener(() {
        NewTaskController controller = context.read<NewTaskController>();

        if (controller.saved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Todo Salvo com sucesso')),
          );
          Provider.of<NewTaskController>(context, listen: false)
              .removeListener(() {});
          Future.delayed(
              Duration(seconds: 1), () => Navigator.of(context).pop());
        } else
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(controller.error)));
      });
    });
  }

  // @override
  // void dispose() {
  //   Provider.of<NewTaskController>(context, listen: false)
  //       .removeListener(() {});
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTaskController>(
      builder: (BuildContext context, controller, _) {
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Container(
                  padding: EdgeInsets.all(21),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOVA TASK',
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 34),
                      Text(
                        'Data',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controller.dayFormated,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nome da Task obrigatorio';
                          }
                        },
                        controller: controller.nomeTaskCotroller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8)))),
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
                      TimeComponent(
                          date: controller.dayselected,
                          onSelectedTime: (date) {
                            controller.dayselected = date;
                          }),
                      SizedBox(height: 50),
                      _buildButton(controller, context),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildButton(NewTaskController controller, BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => !controller.saved ? controller.save() : {},
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          width: controller.saved
              ? MediaQuery.of(context).size.width * .3
              : MediaQuery.of(context).size.width * .8,
          height: controller.saved ? 40 : 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: controller.saved
                ? BorderRadius.circular(100)
                : BorderRadius.circular(20),
            // boxShadow: [
            //   BoxShadow(
            //       blurRadius: 34,
            //       color: Theme.of(context).primaryColor)]
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              alignment: Alignment.center,
              width: !controller.saved ? 0 : 80,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInBack,
                opacity: !controller.saved ? 0 : 1,
                child: Icon(Icons.check, color: Colors.white),
              ),
            ),
            Visibility(
              visible: !controller.saved,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
