import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Random Words App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getnext(){
    current = WordPair.random();
    notifyListeners();
  }
  var favwords = <WordPair>[];
 

 void toggleFavourite(){
  if(favwords.contains(current)){
    favwords.remove(current);
  }else{
    favwords.add(current);
  }

  print(favwords.toString());
  notifyListeners();
 }
}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
var selectedIndex  =0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var current = appState.current;
    
    IconData icon;
    if(appState.favwords.contains(current)){
      icon = Icons.favorite;
    }else{
      icon = Icons.favorite_border;
    }
    var generatorPage = GeneratorPage(
                      current: current, 
                      appState: appState, 
                      icon: icon
                    );
    
    var page ;
    switch (selectedIndex) {
      case 0:
        page = generatorPage;
        break;
      case 1:
        page = favouritesPage();
        break;
      default: throw UnimplementedError("No widget");
    }
    
    return LayoutBuilder(
      builder: (context,constraints) {
        return Scaffold(
          body: Center(
            child: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth>=600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_filled), 
                        label: Text("Home"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite_rounded), 
                        label: Text("Favourite"),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                       setState(() {
                         selectedIndex = value;
                       });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({
    super.key,
    required this.current,
    required this.appState,
    required this.icon,
  });

  final WordPair current;
  final MyAppState appState;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      
      children: [
        BigCard(current: current),
        SizedBox(width: 10,height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          
          children: [
            ElevatedButton.icon(
              onPressed: (){
              appState.toggleFavourite();
              }, 
              icon: Icon(icon),
              label: Text("Favourite"),
            ),
            
            SizedBox(width: 10,height: 10,),
            ElevatedButton(
              onPressed: (){
                appState.getnext();
              }, 
              child: Text("Next")),
          ],
        )
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.current,
  });

  final WordPair current;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          current.asLowerCase,
          style: style,
          semanticsLabel: "${current.first} ${current.second}"
          ),
        
      ),
      
    );
  }
}

class favouritesPage extends StatelessWidget {
  
  const favouritesPage({
    super.key, 
    
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
 var str;
    if(appState.favwords.isEmpty){
      return Center(
        child: Text("You have no favourites yet!"),
      );
    }
      
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${appState.favwords.length} favourites :'),
        ),
        for(var msg in appState.favwords)
          ListTile(
            title: Text(msg.toString()),
            leading: Icon(Icons.favorite_outlined,color: Theme.of(context).primaryColor,),
            onTap: () {
              appState.favwords.remove(msg.toString());
              
            },
          ),
        
      ],
    );
  }
}