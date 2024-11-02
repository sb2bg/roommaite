class Profile {
  final String id;
  final String name;
  final String? username;
  final String avatarUrl;

  Profile({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      avatarUrl: json['avatar_url'],
    );
  }
}
