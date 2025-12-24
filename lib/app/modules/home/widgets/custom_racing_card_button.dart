import 'package:flutter/material.dart';


// class CustomRacingCardButton extends StatelessWidget {
//   final String racingName;
//   final String sponsorName;
//   final String sponsorLogo;
//   final VoidCallback onTap;
//   const CustomRacingCardButton({super.key, required this.racingName, required this.sponsorName, required this.sponsorLogo, required this.onTap});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQuery = MediaQuery.of(context);
//     double screenWidth = mediaQuery.size.width;
//     double screenHeight = mediaQuery.size.height;
//
//     print(screenHeight);
//     print(screenWidth);
//
//     return ElevatedButton(
//       onPressed: onTap,
//       style: ButtonStyle(
//         backgroundColor: WidgetStatePropertyAll<Color>(const Color(0xFFF3F4F6)),
//         elevation: WidgetStatePropertyAll<double>(0.2),
//         shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
//       ),
//       child: SizedBox(
//         height:60,
//         width: double.infinity,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               //color: Colors.red,
//               child: Text(
//                 racingName,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w400,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               spacing: 16,
//               children: [
//                 Container(
//                   width: 80,
//                   //color: Colors.red,
//                   child:  Text(
//                     'Sponsored by',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   //padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                   decoration: ShapeDecoration(
//                    // color: const Color(0xFFF93939),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     spacing: 2,
//                     children: [
//                       //logo section
//                       Container(
//                         width: 40,
//                         height: 40,
//                         child: Image.network(sponsorLogo, fit: BoxFit.cover),
//                       ),
//                       Container(
//                         width: 55,
//                         decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
//                           child: Text(
//                             sponsorName,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w400,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




class CustomRacingCardButton extends StatelessWidget {
  final String racingName;
  final String sponsorLogo;
  final VoidCallback onTap;
  const CustomRacingCardButton({
    super.key,
    required this.racingName,
    required this.sponsorLogo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calculate dynamic sizes based on screen dimensions
    final double racingNameWidth = screenWidth * 0.32; // 32% of screen width
    final double sponsorTextWidth = screenWidth * 0.2; // 20% of screen width
    final double logoSize = screenHeight * 0.05; // 5% of screen height


    // Font sizes
    final double racingNameFontSize = screenWidth * 0.04; // 4% of screen width
    final double sponsorTextFontSize = screenWidth * 0.03; // 3% of screen width


    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(const Color(0xFFF3F4F6)),
        elevation: WidgetStatePropertyAll<double>(0.2),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: screenWidth * 0.03), // 3% of screen width
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Expanded(
            //   child: SizedBox(
            //     width: sponsorTextWidth,
            //     child: Text(
            //       'Sponsored by',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: sponsorTextFontSize,
            //         fontFamily: 'Inter',
            //         fontWeight: FontWeight.w400,
            //       ),
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: screenWidth * 0.04, // 4% of screen width
              children: [
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: screenWidth * 0.01, // 1% of screen width
                    children: [
                      // Logo section
                      SizedBox(
                        width: logoSize,
                        height: logoSize,
                        child: Image.network(
                          sponsorLogo,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image,);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                width: racingNameWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    racingName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: racingNameFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}