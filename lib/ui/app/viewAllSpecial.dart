import "package:firebase_connect/ui/app/exploreAndBookScreen.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "./addDataScreen.dart";
// import "../../model/viewAllSpecial.dart";

/*List<ViewAllSpecialModel> tempData = [
  ViewAllSpecialModel(
    id: '1',
    name: 'Gokul Krishna restaurant',
    networkImage:
        "https://ashaval.com/wp-content/uploads/2021/01/Feature-image.jpg",
    likes: '100',
  ),
  ViewAllSpecialModel(
    id: '2',
    name: 'The Great Kabab Factory',
    networkImage:
        'https://images.squarespace-cdn.com/content/v1/5e9852ea88b473135ac2bbb7/c7f1a21c-737a-4c77-a352-1fbf6b403532/Waldorf_3_2500x1660.jpg',
    likes: '75',
  ),
  ViewAllSpecialModel(
    id: '3',
    name: 'Silver Dine Maheshvala',
    networkImage:
        'https://images.squarespace-cdn.com/content/v1/5e9852ea88b473135ac2bbb7/59d3b267-c6f7-4376-81e4-d02f4089f0f6/Waldorf_1_2500x1660.jpg',
    likes: '50',
  ),
  ViewAllSpecialModel(
    id: '4',
    name: 'Adalaj Pavilion',
    networkImage:
        'https://media-cdn.tripadvisor.com/media/photo-s/25/40/66/fc/royal-vega.jpg',
    likes: '120',
  ),
  ViewAllSpecialModel(
    id: '5',
    name: 'Royal Vega',
    networkImage:
        'https://b.zmtcdn.com/data/pictures/5/19166625/8ab5e67bdb32e92dc7e491b176a43784.jpg',
    likes: '90',
  ),
  ViewAllSpecialModel(
    id: '6',
    name: 'Kuro-The Asian Bistro',
    networkImage:
        'https://b.zmtcdn.com/data/pictures/6/18711166/aa6363b3b9b80e202360421bfde3f5ed.jpg',
    likes: '110',
  ),

];*/

DatabaseReference? ref;

// ignore: must_be_immutable
class ViewAllSpecial extends StatefulWidget {
  String? city, type;
  ViewAllSpecial(this.city, this.type);

  @override
  State<ViewAllSpecial> createState() => _ViewAllSpecialState(city, type);
}

class _ViewAllSpecialState extends State<ViewAllSpecial> {
  String? city, type;
  TextEditingController searchText = TextEditingController();

  _ViewAllSpecialState(this.city, this.type) {
    ref = FirebaseDatabase.instance.ref(city.toString().toLowerCase());

    if (ref != null) {
      ref = ref!.child(type.toString().toLowerCase());
    }
  }
  @override
  void initState() {
    super.initState();
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
        title: Text(type![0].toUpperCase() + type!.substring(1),
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          searchBar(),
          Expanded(
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
                    int count = -1;
                    return ListView(
                      shrinkWrap: true, // Add this line
                      children: list.map((specialPlace) {
                        count++;
                        if (searchText.text.isNotEmpty) {
                          if (!specialPlace
                              .toString()
                              .toLowerCase()
                              .contains(searchText.text.toLowerCase())) {
                            return Container();
                          }
                        }
                        return Container(
                          height: 330,
                          width: MediaQuery.of(context).size.width / 2,
                          child: SpecialPlaceCard(
                              specialPlace: specialPlace, id: key[count]),
                        );
                      }).toList(),
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddData(
                        true, city!.toLowerCase(), type!.toLowerCase())));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: searchText,
        onChanged: (query) {
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

class SpecialPlaceCard extends StatelessWidget {
  final specialPlace;
  final id;

  SpecialPlaceCard({required this.specialPlace, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (contexxt) =>
                        ExploreAndBook(specialPlace["networkUrl"],id.toString(),specialPlace,ref))),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 2), // Offset from top
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                    child: Image.network(
                      specialPlace["networkUrl"],
                      width: double.infinity,
                      height: 175,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${specialPlace["likes"]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            // padding: EdgeInsets.all(10.0),
            padding: EdgeInsets.only(right: 0, top: 10, bottom: 10, left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    specialPlace["placeName"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 4),
                    Text(
                      specialPlace["address"],
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Open Now",
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 180),
                    PopupMenuButton(
                        // iconSize: 1,
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text("Delete"),
                                onTap: () {
                                  Navigator.pop(context);
                                  ref!.child(id.toString()).remove();
                                },
                              ))
                            ] // Add a trailing icon
                        ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
