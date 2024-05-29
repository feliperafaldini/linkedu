class Company {
  final int id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String imgPath;

  const Company({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.imgPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'imagePath': imgPath,
    };
  }
}
