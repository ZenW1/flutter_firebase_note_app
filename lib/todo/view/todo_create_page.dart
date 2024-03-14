import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jong_jam/todo/widget%20/todo_create_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:jong_jam/main/view/home_page.dart';
import 'package:jong_jam/shared/widget/app_bar.dart';

import '../../bloc/todo/todo_bloc.dart';

class TodoCreatePage extends StatefulWidget {
  const TodoCreatePage({super.key});

  static String routePath = '/todo-create';

  @override
  State<TodoCreatePage> createState() => _TodoCreatePageState();
}

class _TodoCreatePageState extends State<TodoCreatePage> {
  TextEditingController _taskTitleController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _dateTimeController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _dateTimeController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoSuccess) {
          context.go(HomePage.routePath);
        }
      },
      child: Scaffold(
        appBar: const AppBarWidget(
          title: 'Create tasks Todo',
          showButton: false,
        ),
        body: TodoCreateWidget(
          taskTitleController: _taskTitleController,
          taskDescriptionController: _taskDescriptionController,
          dateTimeController: _dateTimeController,
          title: 'Create',
        ),
      ),
    );
  }
}

class TodoAddListener extends StatelessWidget {
  const TodoAddListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Success add todo'),
              ),
            );
          context.loaderOverlay.hide();
        } else if (state is TodoLoading) {
          context.loaderOverlay.show();
        } else if (state is TodoFailure) {
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Failed add todo'),
              ),
            );
        }
      },
      child: const SizedBox(),
    );
  }
}
