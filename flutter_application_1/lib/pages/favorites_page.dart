import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMeals = prefs.getStringList('favorites') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoriteMeals.isEmpty
          ? Center(
              child: Text(
                'No favorite meals yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                final mealId = favoriteMeals[index];

                return ListTile(
                  title: Text('Meal ID: $mealId'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(mealId: mealId),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
