import 'package:flutter/material.dart';

void deleteAlert(BuildContext context, {required VoidCallback onConfirm}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: screenWidth * 0.06),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.0125),

            Center(
              child: Text(
                'Are you sure you want to delete this blood details?',
                style: TextStyle(fontSize: screenWidth * 0.0375),
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Container(
                    height: screenHeight * 0.0625,
                    width: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      border: Border.all(color: Colors.black, width: screenWidth * 0.00125),
                    ),
                    child: Center(
                      child: Text(
                        'YES',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.red
                        ),
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: screenHeight * 0.0625,
                    width: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      border: Border.all(color: Colors.black, width: screenWidth * 0.00125),
                    ),
                    child: Center(
                      child: Text(
                        'NO',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}