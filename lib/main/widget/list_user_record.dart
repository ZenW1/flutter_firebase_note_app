import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jong_jam/bloc/user_record/user_record_bloc.dart';
import 'package:jong_jam/main/view/home_page.dart';
import 'package:jong_jam/todo/widget%20/todo_card_widget.dart';

class ListUserRecord extends StatefulWidget {
  const ListUserRecord({super.key});

  static String routePath = '/list-user-record';

  @override
  State<ListUserRecord> createState() => _ListUserRecordState();
}

class _ListUserRecordState extends State<ListUserRecord> {
  @override
  void initState() {
    BlocProvider.of<UserRecordBloc>(context).add(UserRecordLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('List User Record'),
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).go(HomePage.routePath);
            },
            icon: const Icon(Icons.arrow_back),
          )),
      body: BlocBuilder<UserRecordBloc, UserRecordState>(
        builder: (context, state) {
          if (state is UserRecordLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserRecordLoaded) {
            return ListView.builder(
                itemCount: state.userInfoModel.length,
                itemBuilder: (context, index) {
                  return TodoCardWidget(
                    title: state.userInfoModel[index].title,
                    description: state.userInfoModel[index].description,
                    type: state.userInfoModel[index].type,
                    category: state.userInfoModel[index].category,
                    remindTime: state.userInfoModel[index].remindTime,
                    dateTime: state.userInfoModel[index].dateTime,
                    color: state.userInfoModel[index].color,
                    onTap: () {},
                    onTapDelete: () {},
                    onTapSave: () {},
                    id: state.userInfoModel[index].id,
                  );
                });
          } else if (state is UserRecordFailed) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No Data'));
          }
        },
      ),
    );
  }
}
