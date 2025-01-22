import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/dog_breed_provider.dart';
import 'breed_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final breedProvider = Provider.of<DogBreedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Razas Favoritas'),
      ),
      body: ListView.builder(
        itemCount: breedProvider.favoriteBreeds.length,
        itemBuilder: (context, index) {
          final breed = breedProvider.favoriteBreeds[index];
          return ListTile(
            leading: breed.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: breed.imageUrl!,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.pets),
            title: Text(breed.name),
            subtitle: Text(breed.breedGroup ?? 'Sin grupo'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BreedDetailScreen(breed: breed),
                ),
              );
            },
          );
        },
      ),
    );
  }
}