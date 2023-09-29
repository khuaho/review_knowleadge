import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../global/data/models/user/user.dart';
import 'upsert/upsert_user_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool loading = false;
  List<User> users = [];
  String? error;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<List<User>> loadUsersUseFutureBuilder() async {
    final url = Uri.https(
      'flutterapp-370bf-default-rtdb.firebaseio.com',
      'users.json',
    );

    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final data = listData.entries
        .map(
          (e) => User(
            id: e.key,
            name: e.value['name'],
            age: e.value['age'],
            profession: e.value['profession'],
          ),
        )
        .toList();

    return data;
  }

  Future<void> loadUsers() async {
    final url = Uri.https(
      'flutterapp-370bf-default-rtdb.firebaseio.com',
      'users.json',
    );
    setState(() {
      loading = true;
    });
    try {
      final response = await http.get(url);

      final Map<String, dynamic> listData = json.decode(response.body);
      final data = listData.entries
          .map(
            (e) => User(
              id: e.key,
              name: e.value['name'],
              age: e.value['age'],
              profession: e.value['profession'],
            ),
          )
          .toList();
      setState(() {
        users = data;
        loading = false;
      });
    } catch (err) {
      setState(() {
        error = 'Failed to fetch data. Please try again later';
        loading = false;
      });
    }
  }

  Future<void> navigateToAddUser() async {
    final newUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const UpsertUserPage();
        },
        // settings: RouteSettings(arguments: data),
      ),
    );
    if (newUser == null) {
      return;
    } else {
      loadUsers();
    }
  }

  Future<void> removeUser(User item) async {
    setState(() {
      loading = true;
    });
    final url = Uri.https(
      'flutterapp-370bf-default-rtdb.firebaseio.com',
      'users/${item.id}.json',
    );

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        error = 'Failed to fetch data. Please try again later';
        loading = false;
      });
    }
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: FutureBuilder(
        future: loadUsersUseFutureBuilder(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return const Center(
                child: Text('Data not found'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final item = snapshot.data[index];
                return userTile(item);
              },
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const SizedBox();
        },
      ),
      // body: ListViewData(
      //   loading: loading,
      //   list: users,
      //   error: error,
      //   display: Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: ListView.builder(
      //       itemCount: users.length,
      //       itemBuilder: (_, index) {
      //         final item = users[index];
      //         return Card(
      //           child: Padding(
      //             padding: const EdgeInsets.all(10),
      //             child: Row(
      //               children: [
      //                 Expanded(
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(item.name ?? ''),
      //                       Text(item.age.toString()),
      //                       Text(item.profession ?? '_'),
      //                     ],
      //                   ),
      //                 ),
      //                 IconButton(
      //                   onPressed: () => removeUser(item),
      //                   icon: const Icon(Icons.delete),
      //                 )
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddUser,
        tooltip: 'Add user',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget userTile(User item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name ?? ''),
                  Text(item.age.toString()),
                  Text(item.profession ?? '_'),
                ],
              ),
            ),
            IconButton(
              onPressed: () => removeUser(item),
              icon: const Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }
}
