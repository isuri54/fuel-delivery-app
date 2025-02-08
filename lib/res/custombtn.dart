import '../consts/consts.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;

  const CustomButton({
    super.key, 
    required this.buttonText, 
    required this.onTap, 
    required this.buttonColor, 
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: buttonColor, // Set button color
        ),
        onPressed: onTap, 
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor, // Set text color
          ),
        ),
      ),
    );
  }
}
