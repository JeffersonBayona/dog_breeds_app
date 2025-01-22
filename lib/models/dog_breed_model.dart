class DogBreed {
  final String id;
  final String name;
  final String? imageUrl; // Campo para la URL de la imagen
  final String? breedGroup;
  final String? lifeSpan;
  final String? temperament;
  final String? origin;
  bool isFavorite;

  DogBreed({
    required this.id,
    required this.name,
    this.imageUrl,
    this.breedGroup,
    this.lifeSpan,
    this.temperament,
    this.origin,
    this.isFavorite = false,
  });
}