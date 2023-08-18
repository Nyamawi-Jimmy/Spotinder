import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


enum Gender { male, female, other }

class GenderButton extends StatelessWidget {
  final String text;
  final Gender gender;
  final Gender? selectedGender;
  final VoidCallback onPressed;

  const GenderButton({
    required this.text,
    required this.gender,
    required this.selectedGender,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedGender == gender;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.blue : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
