class Profile {
  final String id;
  final String name;
  final String avatarUrl;

  Profile({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
    );
  }
}
