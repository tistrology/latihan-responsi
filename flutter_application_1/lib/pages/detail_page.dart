import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final String mealId;

  DetailPage({required this.mealId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map mealDetails = {};
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchMealDetails();
    _checkFavorite();
  }

  void _fetchMealDetails() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));

    if (response.statusCode == 200) {
      setState(() {
        mealDetails = json.decode(response.body)['meals'][0];
      });
    }
  }

  void _checkFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorite = favorites.contains(widget.mealId);
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (isFavorite) {
      favorites.remove(widget.mealId);
    } else {
      favorites.add(widget.mealId);
    }

    await prefs.setStringList('favorites', favorites);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mealDetails['strMeal'] ?? 'Loading...')),
      body: mealDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    mealDetails['strMealThumb'],
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealDetails['strMeal'] ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Category: ${mealDetails['strCategory']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Area: ${mealDetails['strArea']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Instructions:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          mealDetails['strInstructions'] ?? '',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _toggleFavorite,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          label: Text(isFavorite
                              ? 'Remove from Favorites'
                              : 'Add to Favorites'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
