import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationMapPreview extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String hospitalName;
  final String address;

  const LocationMapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.hospitalName,
    required this.address,
  });

  @override
  State<LocationMapPreview> createState() => _LocationMapPreviewState();
}

class _LocationMapPreviewState extends State<LocationMapPreview> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    final mapsUrl = _getGoogleMapsUrl();
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("WebView loading: $progress%");
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            print("WebView error: ${error.description}");
            setState(() {
              isLoading = false;
              hasError = true;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(mapsUrl));
  }

  String _getGoogleMapsUrl() {
    // Use OpenStreetMap as a free alternative that works without API key
    // This will show a proper interactive map
    return "https://www.openstreetmap.org/export/embed.html?bbox=${widget.longitude-0.01}%2C${widget.latitude-0.01}%2C${widget.longitude+0.01}%2C${widget.latitude+0.01}&layer=mapnik&marker=${widget.latitude}%2C${widget.longitude}";
  }

  String _getAlternativeMapUrl() {
    // Alternative: Use Google Maps with simple search (no API key needed for basic display)
    final query = "${widget.hospitalName} ${widget.address}".trim();
    if (query.isNotEmpty) {
      return "https://maps.google.com/maps?q=${Uri.encodeComponent(query)}&output=embed";
    } else {
      return "https://maps.google.com/maps?q=${widget.latitude},${widget.longitude}&output=embed";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Stack(
      children: [
        // WebView
        WebViewWidget(controller: _controller),

        // Loading Indicator
        if (isLoading)
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: screenWidth * 0.008,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Loading map...",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Error Message
        if (hasError && !isLoading)
          Container(
            color: Colors.grey[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: screenWidth * 0.16,
                    color: Colors.grey,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Map not available",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  ElevatedButton(
                    onPressed: _initializeWebView,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.0125,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                    ),
                    child: Text(
                      "Retry",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Hospital Info Overlay
        if (!isLoading && !hasError)
          Positioned(
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: screenWidth * 0.01,
                    offset: Offset(0, screenHeight * 0.0025),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hospitalName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  if (widget.address.isNotEmpty)
                    Text(
                      widget.address,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.035,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}