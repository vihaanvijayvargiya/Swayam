import 'package:flutter/material.dart';

class UserTileDoctor extends StatelessWidget {
  final String name;
  final String profileImageUrl;
  final void Function()? onTap;

  const UserTileDoctor({
    super.key,
    required this.name,
    required this.profileImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Added margin for better spacing
        padding: EdgeInsets.all(16), // Updated padding for better UI
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24, // Adjust the size as needed
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : AssetImage('assets/images/user.png') as ImageProvider, // Fallback image
              child: ClipOval(
                child: SizedBox(
                  width: 48, // Diameter of the CircleAvatar
                  height: 48,
                  child: profileImageUrl.isNotEmpty
                      ? Image.network(
                    profileImageUrl,
                    fit: BoxFit.cover, // Ensure the image covers the avatar's bounds
                    alignment: Alignment.topCenter, // Align the image to the top center
                  )
                      : null,
                ),
              ),
            ),
            SizedBox(width: 16), // Increased spacing between icon and text
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                  fontSize: 18, // Increased font size for better readability
                  fontWeight: FontWeight.bold, // Made text bold
                ),
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
