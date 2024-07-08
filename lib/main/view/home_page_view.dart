import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jong_jam/bloc/todo/doing_status/doing_status_bloc.dart';
import 'package:jong_jam/bloc/todo/todo_bloc.dart';
import 'package:jong_jam/bloc/todo/todo_status/todo_status_bloc.dart';
import 'package:jong_jam/data/model/Todo_Model.dart';
import 'package:jong_jam/todo/widget%20/todo_create_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../shared/constant/dimensions.dart';
import '../../todo/widget /todo_card_widget.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({
    Key? key,
  });

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final scrollController = ScrollController();
  TextEditingController _taskTitleController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    context.read<TodoBloc>().add(TodoGetEvent());
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
    return BlocListener<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoDeleteSuccess) {
          context.read<TodoBloc>().add(const TodoGetEvent());
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
        } else if (state is TodoUpdateSuccess) {
          context.read<TodoBloc>().add(const TodoGetEvent());
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
        } else if (state is TodoLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
      child: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
        if (state is TodoLoaded) {
          return Container(
            margin: const  EdgeInsets.only(top: 10),
            child: ListView.separated(
              controller: scrollController,
              itemBuilder: (context, index) {
                if (state.todoList.isNotEmpty) {
                  return BlocListener<DoingStatusBloc, DoingStatusState>(
                    listener: (context, states) {
                      if (states is DoingAddedSuccess) {
                        context.read<TodoBloc>().add(TodoDeleteEvent(todoID: state.todoList[index].id));
                        context.read<TodoBloc>().add(const TodoGetEvent());
                      } else if (states is TodoStatusLoading) {
                        context.loaderOverlay.show();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          TodoCardWidget(
                            id: state.todoList[index].id,
                            title: state.todoList[index].title,
                            type: state.todoList[index].type,
                            category: state.todoList[index].category,
                            dateTime: state.todoList[index].dateTime,
                            remindTime: state.todoList[index].remindTime,
                            description: state.todoList[index].description,
                            color: state.todoList[index].color,
                            onTapDelete: () {
                              context.read<TodoBloc>().add(TodoDeleteEvent(todoID: state.todoList[index].id));
                              context.read<TodoBloc>().add(TodoGetEvent());
                            },
                            onTapSave: () async {
                              // context.read<TodoStatusBloc>().add(
                              //       TodoStatusAddEvent(
                              //         todoModel: TodoModel(
                              //           id: DateTime.now().microsecondsSinceEpoch.toString(),
                              //           title: state.todoList[index].title,
                              //           type: state.todoList[index].type,
                              //           category: state.todoList[index].category,
                              //           dateTime: state.todoList[index].dateTime,
                              //           remindTime: state.todoList[index].remindTime,
                              //           color: state.todoList[index].color,
                              //           description: state.todoList[index].description,
                              //         ),
                              //       ),
                              //     );
                              context.read<DoingStatusBloc>().add(DoingAddEvent(
                                    todoModel: TodoModel(
                                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                                      title: state.todoList[index].title,
                                      type: state.todoList[index].type,
                                      category: state.todoList[index].category,
                                      dateTime: state.todoList[index].dateTime,
                                      remindTime: state.todoList[index].remindTime,
                                      color: state.todoList[index].color,
                                      description: state.todoList[index].description,
                                    ),
                                  ));
                            },
                            onTap: () {
                              _taskTitleController.text = state.todoList[index].title;
                              _taskDescriptionController.text = state.todoList[index].description;
                              _dateTimeController.text = state.todoList[index].remindTime;
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return TodoCreateWidget(
                                    taskTitleController: _taskTitleController,
                                    taskDescriptionController: _taskDescriptionController,
                                    dateTimeController: _dateTimeController,
                                    todo: state.todoList[index],
                                    documentId: state.todoList[index].id,
                                    title: 'Update',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: state.todoList.length,
            ),
          );
        } else if (state is TodoFailure) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      }),
    );
  }
}

class FilterDate extends StatefulWidget {
  const FilterDate({super.key});

  @override
  State<FilterDate> createState() => _FilterDateState();
}

class _FilterDateState extends State<FilterDate> {
  DateTime pickupDate = DateTime.now();
  String dateFormat = DateFormat.yMMMM().format(DateTime.now());
  DateTime? selectedWeek;
  bool isSelectDate = false;

  List<TimeModel> _timeModel = [
    TimeModel(time: '08:00 AM', isSelect: false),
    TimeModel(time: '09:00 AM', isSelect: false),
    TimeModel(time: '10:00 AM', isSelect: false),
    TimeModel(time: '11:00 AM', isSelect: false),
    TimeModel(time: '12:00 AM', isSelect: false),
    TimeModel(time: '01:00 PM', isSelect: false),
    TimeModel(time: '02:00 PM', isSelect: false),
    TimeModel(time: '03:00 PM', isSelect: false),
    TimeModel(time: '04:00 PM', isSelect: false),
    TimeModel(time: '05:00 PM', isSelect: false),
  ];

  List<DateTime> getWeekDays(DateTime date, {bool isSelect = true}) {
    // Find the start of the week (Monday).
    DateTime monday = date.subtract(Duration(days: date.weekday - 1));
    // Create a list of DateTime objects for the week (Monday to Friday).
    List<DateTime> weekDays = [];
    for (int i = 0; i < 5; i++) {
      weekDays.add(monday.add(Duration(days: i)));
    }

    return weekDays;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays = getWeekDays(pickupDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.paddingSizeSmall()),
          InkWell(
            onTap: () {
              pickAppointmentDate();
            },
            child: Row(
              children: [
                SizedBox(height: Dimensions.paddingSizeSmall()),
                Text(
                  dateFormat,
                  // style: robotoMedium().copyWith(
                  //     fontSize: Dimensions.subtitle2(),
                  //     fontWeight: FontWeight.w600,
                  //     color: Theme.of(context).textTheme.bodyLarge.color),
                ),
                SizedBox(width: Dimensions.paddingSizeSmall()),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          SizedBox(height: Dimensions.paddingSizeDefault()),
          Container(
            width: double.infinity,
            height: 90,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: weekDays.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _onWeekdaySelected(weekDays[index]);
                    });
                  },
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      color: pickupDate == weekDays[index] ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault()),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekDays[index].day.toString(),
                          // style: pickupDate == weekDays[index]
                          //     ? robotoMedium().copyWith(fontSize: Dimensions.subtitle2(), color: Colors.white)
                          //     : robotoMedium().copyWith(fontSize: Dimensions.subtitle2(), color: Colors.grey)),
                        ),
                        SizedBox(height: Dimensions.paddingSizeSmall()),
                        Text(
                          DateFormat.E().format(weekDays[index]),
                          // style: pickupDate == weekDays[index]
                          //     ? robotoMedium().copyWith(fontSize: Dimensions.subtitle2(), color: Colors.white)
                          //     : robotoMedium().copyWith(fontSize: Dimensions.subtitle2(), color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: Dimensions.paddingSizeExtraSmall());
              },
            ),
          ),
          SizedBox(height: Dimensions.paddingSizeDefault()),
        ],
      ),
    );
  }

  Future<void> pickAppointmentDate() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          height: 330,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        dateFormat = DateFormat.yMMMM().format(pickupDate);
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
              SizedBox(
                height: 270,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: pickupDate,
                    onDateTimeChanged: (DateTime selectedDate) {
                      setState(() => pickupDate = selectedDate);
                    },
                    maximumYear: DateTime.now().year + 1,
                    minimumYear: DateTime.now().year,
                    minimumDate: DateTime(DateTime.now().year),
                    maximumDate: DateTime(DateTime.now().year + 1),
                    dateOrder: DatePickerDateOrder.dmy,
                    mode: CupertinoDatePickerMode.date,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onWeekdaySelected(DateTime date) {
    setState(() {
      pickupDate = date;
    });
  }
}

class TimeModel {
  final String time;
  final bool isSelect;

  TimeModel({required this.time, required this.isSelect});
}
