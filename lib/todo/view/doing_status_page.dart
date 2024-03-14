import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jong_jam/bloc/todo/doing_status/doing_status_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../data/model/Todo_Model.dart';
import '../widget /todo_card_widget.dart';
import '../widget /todo_create_widget.dart';

class DoingStatusPage extends StatefulWidget {
  const DoingStatusPage({super.key});

  @override
  State<DoingStatusPage> createState() => _DoingStatusPageState();
}

class _DoingStatusPageState extends State<DoingStatusPage> {
  final scrollController = ScrollController();
  TextEditingController _taskTitleController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    context.read<DoingStatusBloc>().add(DoingStatusFetchEvent());
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _dateTimeController = TextEditingController();
    super.initState();
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
    return BlocConsumer<DoingStatusBloc, DoingStatusState>(
      listener: (context, state) {
        if (state is DoingDeleteSuccess) {
          context.read<DoingStatusBloc>().add(const DoingStatusFetchEvent());
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Delete success'), Icon(Icons.check)],
                ),
                backgroundColor: Colors.green,
              ),
            );
          context.loaderOverlay.hide();
        } else if (state is DoingUpdateSuccess) {
          context.read<DoingStatusBloc>().add(const DoingStatusFetchEvent());
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Update success'), Icon(Icons.check)],
                ),
                backgroundColor: Colors.green,
              ),
            );
          context.loaderOverlay.hide();
        } else if (state is DoingStatusLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
      builder: (context, state) {
        return BlocBuilder<DoingStatusBloc, DoingStatusState>(
          builder: (context, state) {
            if (state is DoingStatusInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoingStatusLoaded) {
              return ListView.builder(
                itemCount: state.doingList.length,
                itemBuilder: (context, index) {
                  return TodoCardWidget(
                    id: state.doingList[index].id,
                    title: state.doingList[index].title,
                    type: state.doingList[index].type,
                    category: state.doingList[index].category,
                    dateTime: state.doingList[index].dateTime,
                    remindTime: state.doingList[index].remindTime,
                    description: state.doingList[index].description,
                    color: state.doingList[index].color,
                    onTapDelete: () {
                      context.read<DoingStatusBloc>().add(DoingDeleteEvent(todoID: state.doingList[index].id));
                      context.read<DoingStatusBloc>().add(DoingStatusFetchEvent());
                    },
                    onTapSave: () async {
                      // context.read<TodoStatusBloc>().add(
                      //       TodoStatusAddEvent(
                      //         todoModel: TodoModel(
                      //           id: DateTime.now().microsecondsSinceEpoch.toString(),
                      //           title: state.doingList[index].title,
                      //           type: state.doingList[index].type,
                      //           category: state.doingList[index].category,
                      //           dateTime: state.doingList[index].dateTime,
                      //           remindTime: state.doingList[index].remindTime,
                      //           color: state.doingList[index].color,
                      //           description: state.doingList[index].description,
                      //         ),
                      //       ),
                      //     );
                      // context.read<DoingStatusBloc>().add(DoingAddEvent(
                      //       todoModel: TodoModel(
                      //         id: DateTime.now().microsecondsSinceEpoch.toString(),
                      //         title: state.doingList[index].title,
                      //         type: state.doingList[index].type,
                      //         category: state.doingList[index].category,
                      //         dateTime: state.doingList[index].dateTime,
                      //         remindTime: state.doingList[index].remindTime,
                      //         color: state.doingList[index].color,
                      //         description: state.doingList[index].description,
                      //       ),
                      //     ));
                    },
                    onTap: () {
                      _taskTitleController.text = state.doingList[index].title;
                      _taskDescriptionController.text = state.doingList[index].description;
                      _dateTimeController.text = state.doingList[index].remindTime;
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return TodoCreateWidget(
                            taskTitleController: _taskTitleController,
                            taskDescriptionController: _taskDescriptionController,
                            dateTimeController: _dateTimeController,
                            todo: state.doingList[index],
                            documentId: state.doingList[index].id,
                            title: 'Update',
                          );
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No Data'));
            }
          },
        );
      },
    );
  }
}
