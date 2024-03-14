import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class TestWidgetScreen extends StatefulWidget {
  const TestWidgetScreen({super.key});

  @override
  State<TestWidgetScreen> createState() => _TestWidgetScreenState();
}

class _TestWidgetScreenState extends State<TestWidgetScreen> {
  List<DateTime?> _dates = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note App",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
              FilledButton.tonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: CalendarDatePicker2WithActionButtons(
                        config: CalendarDatePicker2WithActionButtonsConfig(
                          firstDayOfWeek: 1,
                          cancelButton: Container(),
                          okButton: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          calendarType: CalendarDatePicker2Type.range,
                          selectedDayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          selectedDayHighlightColor: Colors.purple[800],
                          centerAlignModePicker: true,
                          customModePickerIcon: SizedBox(),
                          dayBuilder: ({
                            required date,
                            textStyle,
                            decoration,
                            isSelected,
                            isDisabled,
                            isToday,
                          }) {
                            Widget? dayWidget;
                            if (date.day % 3 == 0 && date.day % 9 != 0) {
                              dayWidget = Container(
                                decoration: decoration,
                                child: Center(
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Text(
                                        MaterialLocalizations.of(context).formatDecimal(date.day),
                                        style: textStyle,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 27.5),
                                        child: Container(
                                          height: 4,
                                          width: 4,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: isSelected == true ? Colors.white : Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return dayWidget;
                          },
                          yearBuilder: ({
                            required year,
                            decoration,
                            isCurrentYear,
                            isDisabled,
                            isSelected,
                            textStyle,
                          }) {
                            return Center(
                              child: Container(
                                decoration: decoration,
                                height: 36,
                                width: 72,
                                child: Center(
                                  child: Semantics(
                                    selected: isSelected,
                                    button: true,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          year.toString(),
                                          style: textStyle,
                                        ),
                                        if (isCurrentYear == true)
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.only(left: 5),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        value: _dates,
                        onValueChanged: (dates) => _dates = dates,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Button",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
