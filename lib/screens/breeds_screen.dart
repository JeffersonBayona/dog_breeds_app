import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/dog_breed_provider.dart';
import 'breed_detail_screen.dart';

class BreedsScreen extends StatefulWidget {
  @override
  _BreedsScreenState createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true; // Estado para controlar la carga
  bool _showNoResultsMessage =
      false; // Estado para mostrar el mensaje de "No hay resultados"

  @override
  void initState() {
    super.initState();
    final breedProvider = Provider.of<DogBreedProvider>(context, listen: false);
    if (breedProvider.breeds.isEmpty) {
      _loadBreeds(); // Solo cargar si la lista está vacía
    } else {
      _isLoading = false; // Ya hay datos cargados
    }
  }

  Future<void> _loadBreeds() async {
    final breedProvider = Provider.of<DogBreedProvider>(context, listen: false);
    await breedProvider.fetchBreeds();
    setState(() {
      _isLoading = false; // Finalizar la carga
    });
  }

  void _handleSearch(String query) {
    final breedProvider = Provider.of<DogBreedProvider>(context, listen: false);
    breedProvider.filterBreeds(query);

    setState(() {
      _showNoResultsMessage =
          query.isNotEmpty && breedProvider.filteredBreeds.isEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breedProvider = Provider.of<DogBreedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Razas de Perros'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // Spinner de carga
                  SizedBox(height: 20),
                  Text('Cargando información...'), // Mensaje de carga
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar raza...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      _handleSearch(value); // Manejar la búsqueda al escribir
                    },
                    onSubmitted: (value) {
                      _handleSearch(
                          value); // Manejar la búsqueda al presionar Enter
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<DogBreedProvider>(
                    builder: (context, breedProvider, child) {
                      final breedsToShow = breedProvider.filteredBreeds.isEmpty
                          ? breedProvider
                              .breeds // Mostrar todas las razas si no hay filtro
                          : breedProvider
                              .filteredBreeds; // Mostrar razas filtradas

                      // Mostrar mensaje si no hay resultados
                      if (_showNoResultsMessage) {
                        return Center(
                          child: Text(
                            'No existe una raza con el nombre "${_searchController.text}"',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      // Mostrar la lista de razas
                      return ListView.builder(
                        itemCount: breedsToShow.length,
                        itemBuilder: (context, index) {
                          final breed = breedsToShow[index];
                          return ListTile(
                            leading: breed.imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: breed.imageUrl!,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.pets, // Ícono de error
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.pets, // Ícono por defecto
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                            title: Text(breed.name),
                            subtitle: Text(breed.breedGroup ?? 'Sin grupo'),
                            trailing: IconButton(
                              icon: Icon(
                                breed.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: breed.isFavorite ? Colors.red : null,
                              ),
                              onPressed: () {
                                breedProvider.toggleFavorite(breed.id);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BreedDetailScreen(breed: breed),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
