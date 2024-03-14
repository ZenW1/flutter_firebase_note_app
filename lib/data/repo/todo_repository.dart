import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jong_jam/data/model/Todo_Model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoRepository {
//GET USER
  final CollectionReference _todoCollection = FirebaseFirestore.instance.collection('users');

  final snapshot = FirebaseFirestore.instance.collection('users').snapshots();

  Future<void> addTodoList({required TodoModel todoModel}) async {
    await _todoCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('todo').add(
          todoModel.toJson(),
        );
  }

  Future<void> deleteTodoList({required String todoID}) async {
    await _todoCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('todo').doc(todoID.toString()).delete();
  }

  Future<void> addTodoListSave({required TodoModel todoModel}) async {
    await _todoCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('todo').add(
          todoModel.toJson(),
        );
  }

  Future<void> updateTodoList({required TodoModel todo}) async {
    await _todoCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('todo').doc(todo.id).update(
      {
        'title': todo.title,
        'type': todo.type,
        'category': todo.category,
        'remindTime': todo.remindTime,
        'color': todo.color,
        'description': todo.description,
      },
    );
  }

  Future<List<TodoModel>> getTodoList() async {
    final snapshot = await _todoCollection
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .collection('todo')
        .get();
    return snapshot.docs.map((doc) {
      return TodoModel(
        id: doc.id,
        title: doc['title'],
        type: doc['type'],
        category: doc['category'],
        dateTime: doc['dateTime'],
        remindTime: doc['remindTime'],
        color: doc['color'],
        description: doc['description'],
      );
    }).toList();
  }

  /* ----------------- DOING STATUS---------------------- */

  // add to do list save

  Future<void> addDoingList({required TodoModel todoModel}) async {
    await _todoCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('doing').add(
          todoModel.toJson(),
        );
  }

  Future<void> deleteDoingList({required String todoID}) async {
    await _todoCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('doing').doc(todoID.toString()).delete();
  }

  Future<void> updateDoingList({required TodoModel todo}) async {
    await _todoCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('doing').doc(todo.id).update(
      {
        'title': todo.title,
        'type': todo.type,
        'category': todo.category,
        'remindTime': todo.remindTime,
        'color': todo.color,
        'description': todo.description,
      },
    );
  }

  Future<List<TodoModel>> getDoingList() async {
    final snapshot = await _todoCollection
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .collection('doing')
        .get();
    return snapshot.docs.map((doc) {
      return TodoModel(
        id: doc.id,
        title: doc['title'],
        type: doc['type'],
        category: doc['category'],
        dateTime: doc['dateTime'],
        remindTime: doc['remindTime'],
        color: doc['color'],
        description: doc['description'],
      );
    }).toList();
  }
}
