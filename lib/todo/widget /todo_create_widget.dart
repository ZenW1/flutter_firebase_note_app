import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jong_jam/bloc/notification/send_notification_bloc.dart';

import '../../bloc/todo/todo_bloc.dart';
import '../../data/model/Todo_Model.dart';
import '../../data/model/category_model.dart';
import '../../data/model/color_model.dart';
import '../../shared/constant/app_color.dart';
import '../../shared/constant/constant_class.dart';
import '../../shared/constant/dimensions.dart';
import '../../shared/widget/app_title.dart';
import '../../shared/widget/custom_buttom_widget.dart';
import '../../shared/widget/global_text_field.dart';

class TodoCreateWidget extends StatefulWidget {
  TodoCreateWidget({
    Key? key,
    required this.taskTitleController,
    required this.taskDescriptionController,
    required this.dateTimeController,
    required this.title,
    this.todo,
    this.documentId,
  }) : super(key: key);

  final TextEditingController taskTitleController;
  final TextEditingController taskDescriptionController;
  final TextEditingController dateTimeController;
  TodoModel? todo;

  final String title;
  String? documentId;

  @override
  State<TodoCreateWidget> createState() => _TodoCreateWidgetState();
}

class _TodoCreateWidgetState extends State<TodoCreateWidget> {
  String? getTaskType;
  DateTime? newDateTime;
  String? categoryModelList;
  String? colorModelList;

  RegExp capword = RegExp(r'^[A-Z]');

  String dateTimeFormat = DateFormat.yMMMd().add_jm().format(DateTime.now());

  List<ColorModel> colorList = [
    //
    // ColorModel(color: '0xFFFE9391', isSelected: false),
    // ColorModel(color: '0xFF7380FF', isSelected: false),
    // ColorModel(color: '0xFFA7F3D0', isSelected: false),
    // ColorModel(color: '0xFFE2B0FF', isSelected: false),
    // ColorModel(color: '0xFFFCD329', isSelected: false),
    ColorModel(color: '0xFFDCF2E2', isSelected: false),
    ColorModel(color: '0xFFDFECFB', isSelected: false),
    ColorModel(color: '0xFFEFE9F6', isSelected: false),
    ColorModel(color: '0xFFF0DEE4', isSelected: false),
    ColorModel(color: '0xFFF8F6D3', isSelected: false),
    ColorModel(color: '0xFFF3F3F3', isSelected: false),
  ];

  List<CategoryModel> categories = [
    CategoryModel(categories: 'Work', isSelected: false),
    CategoryModel(categories: 'Home', isSelected: false),
    CategoryModel(categories: 'School', isSelected: false),
    CategoryModel(categories: 'Shopping', isSelected: false),
    CategoryModel(categories: 'Others', isSelected: false),
  ];

  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.fromDateTime(DateTime.now());

  Set<TaskType> selection = <TaskType>{};

  @override
  void initState() {
    if (widget.todo != null) {
      getTaskType = widget.todo!.type;
      categoryModelList = widget.todo!.category;
      colorModelList = widget.todo!.color;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            const AppTitle(
                              text: 'Task Title',
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            GlobalTextField(
                              textInputType: TextInputType.text,
                              controller: widget.taskTitleController,
                              hintText: 'Enter your task title',
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            const AppTitle(text: 'Task Type'),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            SegmentedButton(
                              emptySelectionAllowed: true,
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              segments: const <ButtonSegment<TaskType>>[
                                ButtonSegment(
                                  value: TaskType.urgent,
                                  label: Text('Urgent'),
                                ),
                                ButtonSegment(
                                  value: TaskType.important,
                                  label: Text('Important'),
                                ),
                                ButtonSegment(
                                  value: TaskType.notUrgent,
                                  label: Text('Not Urgent'),
                                ),
                                ButtonSegment(
                                  value: TaskType.notImportant,
                                  label: Text('Not Important'),
                                ),
                              ],
                              multiSelectionEnabled: false,
                              selected: selection,
                              onSelectionChanged: (Set<TaskType> newSelection) {
                                setState(() {
                                  selection = newSelection;
                                  if (selection.contains(TaskType.urgent)) {
                                    getTaskType = 'Urgent';
                                  } else if (selection.contains(TaskType.important)) {
                                    getTaskType = 'Important';
                                  } else if (selection.contains(TaskType.notUrgent)) {
                                    getTaskType = 'Not Urgent';
                                  } else if (selection.contains(TaskType.notImportant)) {
                                    getTaskType = 'Not Important';
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            const AppTitle(text: 'Remind time'),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            GlobalTextField(
                              textInputType: TextInputType.none,
                              controller: widget.dateTimeController,
                              readOnly: true,
                              onTap: () async {
                                await chooseDatePicker().whenComplete(() => pickTimeHour());
                                setState(
                                  () {
                                    newDateTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                    dateTimeFormat = DateFormat.yMMMMd().add_jm().format(newDateTime!);
                                    widget.dateTimeController.text = dateTimeFormat;
                                  },
                                );

                                // pickTimeHour();
                              },
                              hintText: dateTimeFormat.toString(),
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            const AppTitle(text: 'Choose Color'),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: colorList
                                    .map(
                                      (e) => Container(
                                        margin: EdgeInsets.only(right: Dimensions.paddingSizeSmall()),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              e.isSelected = !e.isSelected!;
                                              if (e.isSelected == true) {
                                                colorModelList = e.color;
                                              } else if (colorModelList == null) {
                                                colorModelList = null;
                                                ScaffoldMessenger.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Please choose color'),
                                                    ),
                                                  );
                                              }
                                              print(colorModelList!.toString());
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Color(
                                                  int.parse(e.color.toString()),
                                                ),
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                ),
                                              ),
                                              e.isSelected == true && e.isSelected != null || e.color == colorModelList
                                                  ? const Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            const AppTitle(text: 'Choose Category'),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: 5,
                              children: categories
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          e.isSelected = !e.isSelected;
                                          if (e.isSelected == true) {
                                            categoryModelList = e.categories;
                                          } else if (categoryModelList == null) {
                                            categoryModelList = null;
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                const SnackBar(
                                                  content: Text('Please choose category'),
                                                ),
                                              );
                                          }
                                        });
                                      },
                                      child: Chip(
                                        backgroundColor:
                                            e.isSelected == true && e.isSelected != null || e.categories == categoryModelList
                                                ? AppColors.bgColor.withOpacity(0.5)
                                                : AppColors.primaryColor,
                                        label: Text(e.categories),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            const AppTitle(text: 'Task Description'),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault(),
                            ),
                            GlobalTextField(
                                textInputType: TextInputType.text,
                                controller: widget.taskDescriptionController,
                                maxLines: 8,
                                hintText: 'Enter your task description'),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall(),
                              vertical: Dimensions.paddingSizeSmall(),
                            ),
                            child: BlocBuilder<TodoBloc, TodoState>(
                              builder: (context, state) {
                                return CustomButtonWidget(
                                  text: widget.title,
                                  onTap: () async {
                                    if (widget.title == 'Create') {
                                      if (newDateTime != null) {
                                        context.read<SendNotificationBloc>().add(
                                              SendScheduleNotificationEvent(
                                                title: widget.taskTitleController.text,
                                                body: widget.taskDescriptionController.text,
                                                dateTime: newDateTime!.toString(),
                                                token: '',
                                              ),
                                            );
                                      }
                                      context.read<TodoBloc>().add(
                                            TodoAddEvent(
                                              todoModel: TodoModel(
                                                id: DateTime.now().microsecondsSinceEpoch.toString(),
                                                title: widget.taskTitleController.text,
                                                type: getTaskType!,
                                                category: categoryModelList!.toString(),
                                                dateTime: DateFormat.d().add_jm().format(DateTime.now()),
                                                description: widget.taskDescriptionController.text,
                                                remindTime: dateTimeFormat.toString(),
                                                color: colorModelList!.toString(),
                                              ),
                                            ),
                                          );
                                      // DocumentSnapshot snapshot = await FirebaseFirestore.instance
                                      //     .collection('users')
                                      //     .doc(context.read<UserInfoCubit>().uid)
                                      //     .get();
                                      //
                                      // context.read<SendNotificationBloc>().add(
                                      //       SendScheduleNotificationEvent(
                                      //         title: widget.taskTitleController.text,
                                      //         body: widget.taskDescriptionController.text,
                                      //         dateTime: newDateTime!.toString(),
                                      //         token: snapshot['userFcmToken'],
                                      //       ),
                                      //     );
                                    } else if (widget.title == 'Update') {
                                      context.read<TodoBloc>().add(
                                            TodoUpdateEvent(
                                              todo: TodoModel(
                                                id: widget.documentId!,
                                                title: widget.taskTitleController.text,
                                                type: getTaskType!,
                                                category: categoryModelList!.toString(),
                                                dateTime: DateFormat.yMMMMd().add_jm().format(DateTime.now()),
                                                description: widget.taskDescriptionController.text,
                                                remindTime: dateTimeFormat.toString(),
                                                color: colorModelList!.toString(),
                                              ),
                                            ),
                                          );
                                      Navigator.of(context).pop();

                                      context.read<TodoBloc>().add(const TodoGetEvent());
                                    }
                                  },
                                );
                              },
                            ),
                          )),
                    ],
                  );
                }),
          ],
        ),
      ],
    );
  }

  Future<void> pickTimeHour() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(pickedDate),
    );
    setState(() {
      pickedTime = selectedTime!;
    });
  }

  Future<void> chooseDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(pickedDate.year - 1),
      lastDate: DateTime(pickedDate.year + 1),
    );
    setState(() {
      pickedDate = selectedDate!;
    });
  }
}
