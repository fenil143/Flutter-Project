// import "dart:async";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";

// DatabaseReference? ref;

// ignore: must_be_immutable
class ExplorePage extends StatefulWidget {
  String id;
  String city, type;
  dynamic item;
  DatabaseReference? ref;
  ExplorePage(this.city, this.type, this.id, this.item, this.ref, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<ExplorePage> createState() =>
      _ExplorePageState(city, type, id, item, ref);
}

class _ExplorePageState extends State<ExplorePage> {
  String id;
  int likeCount = 0;
  bool isLiked = false;
  String city, type;
  dynamic item;
  DatabaseReference? ref;

  _ExplorePageState(this.city, this.type, this.id, this.item, this.ref) {
    likeCount = item["likes"] as int;
    print(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white)),
          backgroundColor: Colors.blue,
          title:
              Text("Explore the thing", style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 270,
                    width: double.infinity,
                    child: Image.network(
                      item["networkUrl"].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 270,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.blue.withOpacity(0.55),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 270,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 3),
                              child: Row(
                                children: [
                                  Icon(Icons.thumb_up,
                                      color: Colors.pinkAccent),
                                  SizedBox(width: 4),
                                  Text("${likeCount} Likes",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15, bottom: 3),
                              child: Row(
                                children: [
                                  Icon(Icons.money, color: Colors.pinkAccent),
                                  SizedBox(width: 4),
                                  Text("Entry Fee: ${item["fees"].toString()}",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        item["placeName"].toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item["address"].toString(),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Facilities",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: item["facilities"]
                          .toString()
                          .split(',')
                          .map((facility) => Chip(
                                label: Text(facility.trim()),
                                backgroundColor: Colors.blue,
                                labelStyle: TextStyle(color: Colors.white),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Opening and Closing Time:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          "${item["openingTime"]} - ${item["closingTime"]}",
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Description:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(item["description"].toString()),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: !isLiked
              ? () {
                  setState(() {
                    likeCount++;
                    isLiked = true;
                    ref!.child(id).update({"likes": likeCount});
                  });
                }
              : () {
                  setState(() {
                    likeCount++;
                    ref!.child(id).update({"likes": likeCount});
                  });
                },
          child: !isLiked
              ? Icon(Icons.thumb_up)
              : Icon(
                  Icons.thumb_up,
                  color: Colors.red,
                ),
        ));
  }

  @override
  void dispose() {
    super.dispose();

    // Update the likes value in Firebase when the user exits the screen
  }

  Widget customLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 4.0,
          ),
          const SizedBox(height: 10.0),
          Text(
            "Loading...",
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
