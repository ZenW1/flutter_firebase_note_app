import 'package:flutter/material.dart';
import 'package:jong_jam/shared/constant/app_color.dart';
import 'package:jong_jam/shared/constant/dimensions.dart';

class TodoCardWidget extends StatelessWidget {
  TodoCardWidget({
    Key? key,
    required this.title,
    required this.type,
    required this.category,
    required this.dateTime,
    required this.remindTime,
    required this.color,
    required this.description,
    required this.onTap,
    required this.onTapDelete,
    required this.onTapSave,
    required this.id,
  });

  final String title;
  final String id;
  final String type;
  final String category;
  final String dateTime;
  final String remindTime;
  final String color;
  final String description;
  final VoidCallback onTap;
  final VoidCallback onTapDelete;
  final VoidCallback onTapSave;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: Dimensions.paddingSizeSmall(),
            right: Dimensions.paddingSizeDefault(),
            top: Dimensions.paddingSizeExtraSmall(),
            bottom: Dimensions.paddingSizeDefault(),
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(int.parse(color)),
            borderRadius: BorderRadius.circular(
              Dimensions.radiusLarge(),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.noteAppColor2,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusExtraLarge(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.paddingSizeDefault(),
                      ),
                      Text(
                        type,
                        style: const TextStyle(),
                      ),
                      SizedBox(
                        width: Dimensions.paddingSizeDefault(),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 30),
                          maximumSize: const Size(100, 35),
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        child: Text(category),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusSmall(),
                        ),
                        color: AppColors.bgColor,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.tWhiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.tBlackColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              // bottom part of this card
              SizedBox(
                height: Dimensions.paddingSizeSmall(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.tBlackColor,
                      ),
                  overflow: TextOverflow.fade,
                  maxLines: 3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.calendar_today,
                      //       size: 12,
                      //     ),
                      //     SizedBox(
                      //       width: Dimensions.paddingSizeExtraSmall(),
                      //     ),
                      //     Text(
                      //       dateTime,
                      //       style: Theme.of(context).textTheme.labelSmall!.copyWith(color: AppColors.tBlackColor),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: Dimensions.paddingSizeSmall(),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraSmall(),
                          vertical: Dimensions.paddingSizeExtraSmall(),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusLarge()),
                          color: AppColors.tWhiteColor,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.watch_later_outlined,
                              size: 12,
                            ),
                            SizedBox(
                              width: Dimensions.paddingSizeExtraSmall(),
                            ),
                            Text(
                              remindTime,
                              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: AppColors.tBlackColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Checkbox(
                  //   shape: const CircleBorder(
                  //     side: BorderSide(
                  //       color: Colors.grey,
                  //       width: 0.2,
                  //     ),
                  //   ),
                  //   value: false,
                  //   onChanged: (value) {},
                  // ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                child: CircleAvatar(
                  backgroundColor: AppColors.tWhiteColor,
                  radius: 20,
                  child: IconButton(
                    onPressed: onTapDelete,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.paddingSizeSmall(),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                child: CircleAvatar(
                  backgroundColor: AppColors.tWhiteColor,
                  radius: 20,
                  child: IconButton(
                    onPressed: onTapSave,
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
