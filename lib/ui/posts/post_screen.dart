import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_connect/ui/auth/loginScreen.dart";
import "package:firebase_connect/ui/posts/add_posts.dart";
import "package:firebase_connect/utils/utils.dart";
import "package:firebase_database/firebase_database.dart";
// import "package:firebase_database/ui/firebase_animated_list.dart";
import "package:flutter/material.dart";

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Post");
  final searchFilter = TextEditingController();
  final addedController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Screen-1"),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace) {
                utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          TextFormField(
            controller: searchFilter,
            decoration: InputDecoration(
                hintText: "Search", border: OutlineInputBorder()),
            onChanged: (String value) {
              setState() {}
              ;
              print(searchFilter.text.toString());
            },
          ),
          Expanded(
              child: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      Map<dynamic, dynamic>? map =
                          snapshot.data!.snapshot.value as dynamic;
                      if (map == null) return Container();
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();
                      return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          if (searchFilter.text.isEmpty) {
                            return ListTile(
                                title: Text(list[index]["title"]),
                                subtitle: Text(list[index]["id"].toString()),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text("Edit"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(
                                            list[index]["title"].toString(),
                                            list[index]["id"].toString());
                                      },
                                    )),
                                    PopupMenuItem(
                                        child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text("Delete"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref
                                            .child(list[index]["id"].toString())
                                            .remove();
                                      },
                                    )),
                                  ],
                                ));
                          } else if (list[index]["title"].toString().toLowerCase().contains(searchFilter.text.toLowerCase())) {
                            return ListTile(
                              title: Text(list[index]["title"]),
                              subtitle: Text(list[index]["id"].toString()),
                              trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text("Edit"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(
                                            list[index]["title"].toString(),
                                            list[index]["id"].toString());
                                      },
                                    )),
                                    PopupMenuItem(
                                        child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text("Delete"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref
                                            .child(list[index]["id"].toString())
                                            .remove();
                                      },
                                    )),
                                  ],
                                ));
                            // print("yes");
                          } else {
                            return Container();
                          }
                        },
                      );
                    }
                  })),
          // Expanded(
          //   child: FirebaseAnimatedList(
          //     query: ref,
          //     defaultChild: Text("Loading..."),
          //     itemBuilder: (context, snapshot, animation, index) {
          //       return ListTile(
          //         title: Text(snapshot.child("title").value.toString()),
          //         subtitle: Text(snapshot.child("id").value.toString()),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    addedController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
                child: TextField(
                    controller: addedController,
                    decoration: InputDecoration(hintText: "Edit"))),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                child: Text("Update"),
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update(
                      {"title": addedController.text.toString()}).then((value) {
                    utils().toastMessage("Data updated");
                  }).onError((error, stackTrace) {
                    utils().toastMessage(error.toString());
                  });
                  setState() {}
                  ;
                },
              )
            ],
          );
        });
  }
}
