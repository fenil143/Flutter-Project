import "package:firebase_connect/ui/app/addDataScreen.dart";
import "package:firebase_connect/ui/app/exploreScreen.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";

// import "../../model/viewAllModel.dart";
import "../../utils/getUserImage.dart";
import "../../utils/utils.dart";
import "../auth/loginScreen.dart";

// ignore: must_be_immutable
class ViewAllScreen extends StatefulWidget {
  String? userImage;
  String? type;
  String? city;
  ViewAllScreen(this.userImage, this.city, this.type, {super.key});

  @override
  State<ViewAllScreen> createState() =>
      _ViewAllScreenState(userImage, city, type);
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  final userImage;
  String? type;
  String? city;
  final userEmail = getUserEmail();
  TextEditingController searchText = TextEditingController();
  DatabaseReference? ref;

  _ViewAllScreenState(this.userImage, this.city, this.type) {
    ref = FirebaseDatabase.instance.ref(city.toString().toLowerCase());

    if (ref != null) {
      ref = ref!.child(type.toString().toLowerCase());
    }
    print(ref);
  }

  @override
  void initState() {
    super.initState();
    // dummyData.addAll(tempData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.blue,
          // Theme.of(context).primaryColor.withOpacity(0.9),
          leading: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(userImage.toString()),
                ),
              )),
          title: Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(type![0].toUpperCase() + type!.substring(1),
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Text(city.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ],
              )),
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  utils().toastMessage(error.toString());
                });
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Column(
        children: [
          searchBar(context),
          // ref!.onValue.length == 0 ? emptyWidget() : allData(context),
          allData(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddData(false, city, type)));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  Widget searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: searchText,
        // onChanged: (query) {
        //   // filterData(query);
        //   setState(() {
        //     searchText.text = query;
        //   });
        // },
        onChanged: (Query) {
          setState(() {});
        },
        decoration: InputDecoration(
          labelText: 'Search by Name',
          hintText: 'Enter a name',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget emptyWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 48.0,
            color: Colors.grey,
          ),
          SizedBox(height: 10.0),
          Text(
            "No data available",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget allData(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: ref!.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return customLoadingWidget();
            } else if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return Text("Error occurred: ${snapshot.error}");
            } else if (!snapshot.hasData) {
              return Text("No data available");
            } else {
              Map<dynamic, dynamic>? map =
                  snapshot.data!.snapshot.value as dynamic;
              if (map == null) return emptyWidget();
              List<dynamic> list = [];
              List<dynamic> key = [];
              list.clear();
              key.clear();
              list = map.values.toList();
              key = map.keys.toList();

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  if (searchText.text.isNotEmpty) {
                    if (!item["placeName"]
                        .toString()
                        .toLowerCase()
                        .contains(searchText.text.toLowerCase())) {
                      return Container();
                    }
                  }
                  print(item);
                  return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExplorePage(
                                      city.toString().toLowerCase(),
                                      type.toString().toLowerCase(),
                                      key[index].toString(),item,ref)));
                        },
                        leading: CircleAvatar(
                          // backgroundColor: Colors.blue,
                          radius: 30,
                          // child: Icon(Icons.person, color: Colors.white),
                          backgroundImage:
                              AssetImage("assets/images/" + "${type}.png"),
                        ),
                        title: Text(
                          item["placeName"].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(item["address"].toString()),
                        trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      ref!
                                          .child(key[index].toString())
                                          .remove();
                                    },
                                  ))
                                ] // Add a trailing icon
                            ),
                      ));
                },
              );
            }
          }),
    );
  }

  Widget customLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 4.0,
          ),
          SizedBox(height: 10.0),
          Text(
            "Loading...",
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
