class Profile {
  final String id;
  final String name;
  final String avatarUrl;
  final String? location;

  Profile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.location,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
      location: json['location'],
    );
  }
}
