import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
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
            Icon(Icons.person, color: Colors.white), // Set icon color to white
            SizedBox(width: 16), // Increased spacing between icon and text
            Expanded(
              child: Text(
                text,
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
