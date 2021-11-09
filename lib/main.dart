import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:search_map_place/search_map_place.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps',
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'home': (context) => HomePage(),
      },
      // home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
        color: Colors.tealAccent,
        child: SafeArea(
          child: Card(
            elevation: 10,
            shadowColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: MediaQuery.of(context).size.height * 0.08,
                  bottom: MediaQuery.of(context).size.height * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ! =======
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Username',
                    ),
                  ),
                  // ! =======
                  ListTile(
                    title: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      // obscuringCharacter: '*',
                    ),
                  ),
                  // ! =======
                  SizedBox(height: 25),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'home');
                      },
                      child: Text('Login'),
                    ),
                    subtitle: Text(
                      "This action will log-you in",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.tealAccent,
        child: Column(
          children: [
            SizedBox(height: 10),
            SearchMapPlaceWidget(
              hasClearButton: true,
              placeType: PlaceType.address,
              placeholder: 'search location',
              apiKey: 'AIzaSyBUILBxCa5yyQZawAA0pD6HII48R3haimM',
              onSelected: (Place place) async {
                Geolocation geolocation = await place.geolocation;
                mapController.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                mapController
                    .animateCamera(CameraUpdate.newLatLng(geolocation.bounds));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController googleMapController) {
                    setState(() {
                      mapController = googleMapController;
                    });
                  },
                  initialCameraPosition: const CameraPosition(
                    zoom: 15.0,
                    target: LatLng(21.1858, 79.5882),
                  ),
                  mapType: MapType.satellite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}









// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   static const historyLength = 5;

//   List<String> _searchHistory = [
//     'Prayagraj',
//     'Delhi',
//     'Banglore',
//     'Mumbai',
//     'Kolkata',
//   ];

//   List<String> filteredSearchHistory;

//   String selectedTerm;

//   List<String> filterSearchTerms({
//     @required String filter,
//   }) {
//     if (filter != null && filter.isNotEmpty) {
//       return _searchHistory.reversed
//           .where((term) => term.startsWith(filter))
//           .toList();
//     } else {
//       return _searchHistory.reversed.toList();
//     }
//   }

//   void addSearchTerm(String term) {
//     if (_searchHistory.contains(term)) {
//       putSearchTermFirst(term);
//       return;
//     }

//     _searchHistory.add(term);
//     if (_searchHistory.length > historyLength) {
//       _searchHistory.removeRange(0, _searchHistory.length - historyLength);
//     }

//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }

//   void deleteSearchTerm(String term) {
//     _searchHistory.removeWhere((t) => t == term);
//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }

//   void putSearchTermFirst(String term) {
//     deleteSearchTerm(term);
//     addSearchTerm(term);
//   }

//   FloatingSearchBarController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = FloatingSearchBarController();
//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FloatingSearchBar(
//         controller: controller,
//         body: FloatingSearchBarScrollNotifier(
//           child: SearchResultsListView(
//             searchTerm: selectedTerm,
//           ),
//         ),
//         transition: CircularFloatingSearchBarTransition(),
//         physics: BouncingScrollPhysics(),
//         title: Text(
//           selectedTerm ?? 'Search locations...',
//           style: Theme.of(context).textTheme.headline6,
//         ),
//         hint: 'Search and find out...',
//         actions: [
//           FloatingSearchBarAction.searchToClear(),
//         ],
//         onQueryChanged: (query) {
//           setState(() {
//             filteredSearchHistory = filterSearchTerms(filter: query);
//           });
//         },
//         onSubmitted: (query) {
//           setState(() {
//             addSearchTerm(query);
//             selectedTerm = query;
//           });
//           controller.close();
//         },
//         builder: (context, transition) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: Material(
//               color: Colors.white,
//               elevation: 4,
//               child: Builder(
//                 builder: (context) {
//                   if (filteredSearchHistory.isEmpty &&
//                       controller.query.isEmpty) {
//                     return Container(
//                       height: 30,
//                       width: double.infinity,
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Start searching...',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.caption,
//                       ),
//                     );
//                   } else if (filteredSearchHistory.isEmpty) {
//                     return ListTile(
//                       title: Text(controller.query),
//                       leading: const Icon(Icons.search),
//                       onTap: () {
//                         setState(() {
//                           addSearchTerm(controller.query);
//                           selectedTerm = controller.query;
//                         });
//                         controller.close();
//                       },
//                     );
//                   } else {
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: filteredSearchHistory
//                           .map(
//                             (term) => ListTile(
//                               title: Text(
//                                 term,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               leading: const Icon(Icons.history),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.clear),
//                                 onPressed: () {
//                                   setState(() {
//                                     deleteSearchTerm(term);
//                                   });
//                                 },
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   putSearchTermFirst(term);
//                                   selectedTerm = term;
//                                 });
//                                 controller.close();
//                               },
//                             ),
//                           )
//                           .toList(),
//                     );
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class SearchResultsListView extends StatelessWidget {
//   final String searchTerm;

//   const SearchResultsListView({
//     Key key,
//     @required this.searchTerm,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (searchTerm == null) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.search,
//               size: 60,
//             ),
//             Text(
//               'Start searching...',
//               style: Theme.of(context).textTheme.headline5,
//             )
//           ],
//         ),
//       );
//     }

//     final fsb = FloatingSearchBar.of(context);

//     return Container(
//       padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
//       child: ListTile(
//         title: Text('$searchTerm search result'),
//         subtitle: Text('Hello $searchTerm'),
//       ),
//     );
//   }
// }
