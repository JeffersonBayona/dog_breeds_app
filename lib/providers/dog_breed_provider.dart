import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/dog_breed_model.dart';

class DogBreedProvider with ChangeNotifier {
  List<DogBreed> _breeds = [];
  List<DogBreed> _filteredBreeds = [];
  final List<DogBreed> _favoriteBreeds = [];

  List<DogBreed> get breeds => _breeds;
  List<DogBreed> get filteredBreeds => _filteredBreeds;
  List<DogBreed> get favoriteBreeds => _favoriteBreeds;

  final String apiKey =
      'live_T360G12hGTOxTj6pcZd13JCS4qhKVz18WKxm1Fd11fTDCxWDnGXljeEsuZiZLdGHv';

  Future<void> fetchBreeds() async {
    if (_breeds.isNotEmpty) return; // No recargar si ya hay datos
    try {
      final response = await http.get(
        Uri.parse('https://api.thedogapi.com/v1/breeds'),
        headers: {'x-api-key': apiKey},
      ).timeout(
          const Duration(seconds: 10)); // Agregar un timeout de 10 segundos

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _breeds = await Future.wait(data.map((breed) async {
          final imageUrl = await fetchImageUrl(breed['reference_image_id']);

          return DogBreed(
            id: breed['id'].toString(),
            name: breed['name'].toString(),
            imageUrl: imageUrl, // URL de la imagen obtenida
            breedGroup: breed['breed_group']?.toString(),
            lifeSpan: breed['life_span']?.toString(),
            temperament: breed['temperament']?.toString(),
            origin: breed['origin']?.toString(),
          );
        }).toList());
        notifyListeners();
      } else {
        throw Exception('Failed to load breeds: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching breeds: $e'); // Imprimir el error en la consola
    }
  }

  Future<String?> fetchImageUrl(String? imageId) async {
    if (imageId == null) return null;

    try {
      final response = await http.get(
        Uri.parse('https://api.thedogapi.com/v1/images/$imageId'),
        headers: {'x-api-key': apiKey},
      ).timeout(
          const Duration(seconds: 10)); // Agregar un timeout de 10 segundos

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['url']?.toString(); // URL de la imagen
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e'); // Imprimir el error en la consola
      return null;
    }
  }

  void toggleFavorite(String breedId) {
    final breedIndex = _breeds.indexWhere((breed) => breed.id == breedId);
    _breeds[breedIndex].isFavorite = !_breeds[breedIndex].isFavorite;
    if (_breeds[breedIndex].isFavorite) {
      _favoriteBreeds.add(_breeds[breedIndex]);
    } else {
      _favoriteBreeds.removeWhere((breed) => breed.id == breedId);
    }
    notifyListeners(); // Notificar a los listeners que los datos han cambiado
  }

  void filterBreeds(String query) {
    if (query.isEmpty) {
      _filteredBreeds.clear(); // Limpiar la lista filtrada si no hay consulta
    } else {
      _filteredBreeds = _breeds
          .where(
              (breed) => breed.name.toLowerCase().contains(query.toLowerCase()))
          .toList(); // Filtrar las razas
    }
    notifyListeners(); // Notificar a los listeners que los datos han cambiado
  }
}
