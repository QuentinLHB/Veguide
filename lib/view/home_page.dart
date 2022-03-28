import 'package:flutter/material.dart';
import 'package:veguide/view/root.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cityTextFieldController =
  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
          /// Top menu
          Flexible(
            flex: 2,
            child: Container(
              color: Colors.red,
              child: Row(
                children: [
                  // Text("Ville"),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.loose,
                    child: TextField(
                      controller: cityTextFieldController,
                      decoration: const InputDecoration(
                          hintText: "Lille", labelText: "Ville"),
                      maxLength: 40,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width : 10),
                  Flexible(
                    flex: 2,
                      child: ElevatedButton(child: Icon(Icons.search_rounded),
                      onPressed: searchButton_onPressed,)),
                  SizedBox(width : 10),
                  Flexible(flex: 1,child: IconButton(icon: Icon(Icons.eco_rounded), onPressed: (){},)),
                  Flexible(flex: 1,child: IconButton(icon: Icon(Icons.eco_rounded), onPressed: (){},)),
                  Flexible(flex: 1, child: IconButton(icon: Icon(Icons.eco_rounded), onPressed: (){},)),
                  Flexible(flex: 1, child: IconButton(icon: Icon(Icons.help), onPressed: (){},)),
                ],
              ),
            ),
            // Text("test haut"),
          ),

          /// Center page
          Flexible(
            flex: 8,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ]),
      ),
    );
  }

  void searchButton_onPressed(){
    // Search for a city
  }
}
