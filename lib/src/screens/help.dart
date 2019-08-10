import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/cube_grid.dart';

class HelpScreen extends StatefulWidget {
  // HelpScreen({ Key key }) : super(key: key);
  @override
  _HelpScreenState createState() => new _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  List<String> kWords = [];
  List<String> pin = [];
  _SearchAppBarDelegate _searchDelegate;
  bool loaded = false;
  //Initializing with sorted list of english words
  _HelpScreenState() {
    _fetchPlaces();
  }

  @override
  void initState() {
    super.initState();
    //Initializing search delegate with sorted list of English words
    _searchDelegate = _SearchAppBarDelegate(kWords);
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Service Areas'),
        actions: <Widget>[
          //Adding the search widget in AppBar
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            //Don't block the main thread
            onPressed: () {
              showSearchPage(context, _searchDelegate);
            },
          ),
        ],
      ),
      body: Scrollbar(
        //Displaying all English words in list in app's main page
        child: ListView.builder(
          itemCount: kWords.length,
          itemBuilder: (context, idx) => Card(
            child: ListTile(
              leading: Icon(
                Icons.location_city,
                color: Colors.green,
              ),
              title: Text(kWords[idx]),
              trailing: Text(
                pin[idx],
                style: TextStyle(color: Colors.orangeAccent),
              ),
              onTap: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Click the Search action"),
                    action: SnackBarAction(
                      label: 'Search',
                      onPressed: () {
                        showSearchPage(context, _searchDelegate);
                      },
                    )));
              },
            ),
          ),
        ),
      ),
    );
  }

  //Shows Search result
  void showSearchPage(
      BuildContext context, _SearchAppBarDelegate searchDelegate) async {
    final String selected = await showSearch<String>(
      context: context,
      delegate: searchDelegate,
    );

    if (selected != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Word Choice: $selected'),
        ),
      );
    }
  }

  void _fetchPlaces() async {
    List<String> test = [];
    QuerySnapshot result = await Firestore.instance.collection('ServArea').getDocuments();
    List<DocumentSnapshot> documents = result.documents;
    for (var i = 0; i < documents.length; i++) {
      // _serviceList[i].serviceName = documents[i].documentID;
      var doc = documents[i].documentID.toString();
      kWords.add(doc);
      pin.add(documents[i].data["pin"].toString());
    }
    setState(() {
      loaded = true;
    });
  }
}

//Search delegate
class _SearchAppBarDelegate extends SearchDelegate<String> {
  final List<String> _words;
  final List<String> _history;

  _SearchAppBarDelegate(List<String> words) 
      : _words = words,
        //pre-populated history of words
        _history = <String>[],
        super();

  // Setting leading icon for the search bar.
  //Clicking on back arrow will take control to main page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  // Builds page to populate search results.
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('===Your Word Choice==='),
            GestureDetector(
              onTap: () {
                //Define your action when clicking on result item.
                //In this example, it simply closes the page
                this.close(context, this.query);
              },
              child: Text(
                this.query,
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Suggestions list while typing search query - this.query.
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty
        ? _history
        : _words.where((word) => word.toLowerCase().startsWith(query.toLowerCase()));

    return _WordSuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this._history.insert(0, suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.mic),
              tooltip: 'Voice input',
              onPressed: () {
                this.query = 'TBW: Get input from voice';
              },
            ),
    ];
  }
}

// Suggestions list widget displayed in the search page.
class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}

//return Scaffold(
//   appBar: AppBar(
//     title: Text('Search'),
//   ),
//   body: ListView(
//     children: <Widget>[
//       Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: TextField(
//           onChanged: (val) {
//             //initiateSerch(val);
//           },
//           decoration: InputDecoration(
//             prefixIcon: IconButton(
//               color: Colors.black,
//               icon: Icon(Icons.arrow_back),
//               iconSize: 20.0,
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             contentPadding: EdgeInsets.only(left: 25.0),
//             hintText: 'Search',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(4.0),
//             ),
//           ),
//         ),
//       )
//     ],
//   ),
// );
