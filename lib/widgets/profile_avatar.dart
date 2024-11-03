import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roommaite/models/profile.dart';

class ProfileAvatar extends StatelessWidget {
  final Profile? profile;
  final double? radius;
  final void Function()? onClick;

  const ProfileAvatar({
    super.key,
    required this.profile,
    this.radius,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: profile == null
              ? CircleAvatar(
                  radius: radius,
                  child: const CircularProgressIndicator(),
                )
              : CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    profile!.avatarUrl,
                  ),
                  radius: radius,
                )),
    );
  }
}
