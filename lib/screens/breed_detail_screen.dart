import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/dog_breed_model.dart';

class BreedDetailScreen extends StatelessWidget {
  final DogBreed breed;

  BreedDetailScreen({required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            breed.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: breed.imageUrl!,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(
                      Icons.pets, // Ícono de error
                      size: 100,
                      color: Colors.grey,
                    ),
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.contain,
                  )
                : Icon(
                    Icons.pets, // Ícono por defecto
                    size: 100,
                    color: Colors.grey,
                  ),
            SizedBox(height: 20),
            Text('Grupo: ${breed.breedGroup ?? 'Desconocido'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Tiempo de vida: ${breed.lifeSpan ?? 'Desconocido'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Temperamento: ${breed.temperament ?? 'Desconocido'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Origen: ${breed.origin ?? 'Desconocido'}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
