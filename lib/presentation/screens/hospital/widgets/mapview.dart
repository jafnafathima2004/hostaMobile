// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class LocationMapPreview extends StatefulWidget {
//   final double latitude;
//   final double longitude;
//   final String hospitalName;
//   final String address;

//   const LocationMapPreview({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//     required this.hospitalName,
//     required this.address,
//   });

//   @override
//   State<LocationMapPreview> createState() => _LocationMapPreviewState();
// }

// class _LocationMapPreviewState extends State<LocationMapPreview> {
//   late final WebViewController _controller;
//   bool isLoading = true;
//   bool hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   void _initializeWebView() {
//     final mapsUrl = _getGoogleMapsUrl();
    
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             print("WebView loading: $progress%");
//           },
//           onPageStarted: (String url) {
//             setState(() {
//               isLoading = true;
//               hasError = false;
//             });
//           },
//           onPageFinished: (String url) {
//             setState(() => isLoading = false);
//           },
//           onWebResourceError: (WebResourceError error) {
//             print("WebView error: ${error.description}");
//             setState(() {
//               isLoading = false;
//               hasError = true;
//             });
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             // Allow all navigation
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(mapsUrl));
//   }

//   String _getGoogleMapsUrl() {
//     // Use OpenStreetMap as a free alternative that works without API key
//     // This will show a proper interactive map
//     return "https://www.openstreetmap.org/export/embed.html?bbox=${widget.longitude-0.01}%2C${widget.latitude-0.01}%2C${widget.longitude+0.01}%2C${widget.latitude+0.01}&layer=mapnik&marker=${widget.latitude}%2C${widget.longitude}";
//   }

//   String _getAlternativeMapUrl() {
//     // Alternative: Use Google Maps with simple search (no API key needed for basic display)
//     final query = "${widget.hospitalName} ${widget.address}".trim();
//     if (query.isNotEmpty) {
//       return 
//        "https://maps.google.com/maps?q=${Uri.encodeComponent(query)}&output=embed";
//     } else {
//        return 
//       "https://maps.google.com/maps?q=${widget.latitude},${widget.longitude}&output=embed";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
    
//     return Stack(
//       children: [
//         // WebView
//         WebViewWidget(controller: _controller),

//         // Loading Indicator
//         if (isLoading)
//           Container(
//             color: Colors.white,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     strokeWidth: screenWidth * 0.008,
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   Text(
//                     "Loading map...",
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//         // Error Message
//         if (hasError && !isLoading)
//           Container(
//             color: Colors.grey[100],
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     size: screenWidth * 0.16,
//                     color: Colors.grey,
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   Text(
//                     "Map not available",
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.01),
//                   ElevatedButton(
//                     onPressed: _initializeWebView,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.06,
//                         vertical: screenHeight * 0.0125,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.025),
//                       ),
//                     ),
//                     child: Text(
//                       "Retry",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: screenWidth * 0.035,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//         // Hospital Info Overlay
//         if (!isLoading && !hasError)
//           Positioned(
//             bottom: screenHeight * 0.02,
//             left: screenWidth * 0.04,
//             right: screenWidth * 0.04,
//             child: Container(
//               padding: EdgeInsets.all(screenWidth * 0.03),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(screenWidth * 0.02),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: screenWidth * 0.01,
//                     offset: Offset(0, screenHeight * 0.0025),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.hospitalName,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: screenWidth * 0.04,
//                     ),
//                   ),
//                   if (widget.address.isNotEmpty)
//                     Text(
//                       widget.address,
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: screenWidth * 0.035,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapView extends StatefulWidget {
//   final double latitude;
//   final double longitude;
//   final String hospitalName;
//   final String address;
//   final double? userLatitude;
//   final double? userLongitude;

//   const GoogleMapView({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//     required this.hospitalName,
//     required this.address,
//     this.userLatitude,
//     this.userLongitude,
//   });

//   @override
//   State<GoogleMapView> createState() => _GoogleMapViewState();
// }

// class _GoogleMapViewState extends State<GoogleMapView> {
//   late GoogleMapController mapController;
//   Set<Marker> markers = {};
//   bool isMapReady = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupMarkers();
//   }

//   void _setupMarkers() {
//     markers.clear();

//     // Hospital Marker (Red)
//     if (widget.latitude != 0 && widget.longitude != 0) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('hospital'),
//           position: LatLng(widget.latitude, widget.longitude),
//           infoWindow: InfoWindow(
//             title: widget.hospitalName,
//             snippet: widget.address,
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//       print("✅ Hospital Marker Added: ${widget.latitude}, ${widget.longitude}");
//     } else {
//       print("❌ Hospital Location NOT AVAILABLE");
//     }

//     // User Marker (Blue) - ✅ THIS IS YOUR CURRENT LOCATION
//     if (widget.userLatitude != null && widget.userLongitude != null) {
//       if (widget.userLatitude != 0 && widget.userLongitude != 0) {
//         markers.add(
//           Marker(
//             markerId: const MarkerId('user'),
//             position: LatLng(widget.userLatitude!, widget.userLongitude!),
//             infoWindow: const InfoWindow(
//               title: '📍 Your Current Location',
//               snippet: 'You are here',
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//           ),
//         );
//         print("✅ User Marker Added: ${widget.userLatitude}, ${widget.userLongitude}");
//       }
//     } else {
//       print("❌ User Location NOT AVAILABLE - Check permissions");
//     }

//     setState(() {});
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     setState(() {
//       isMapReady = true;
//     });
    
//     // ✅ Zoom to show both locations if user location exists
//     if (widget.userLatitude != null && widget.userLongitude != null) {
//       _zoomToFitBothLocations();
//     } else {
//       // Only hospital location - zoom to hospital
//       mapController.animateCamera(
//         CameraUpdate.newLatLngZoom(
//           LatLng(widget.latitude, widget.longitude),
//           16,
//         ),
//       );
//     }
//   }

//   void _zoomToFitBothLocations() {
//     if (!isMapReady) return;
    
//     try {
//       double minLat = widget.latitude < widget.userLatitude! ? widget.latitude : widget.userLatitude!;
//       double maxLat = widget.latitude > widget.userLatitude! ? widget.latitude : widget.userLatitude!;
//       double minLng = widget.longitude < widget.userLongitude! ? widget.longitude : widget.userLongitude!;
//       double maxLng = widget.longitude > widget.userLongitude! ? widget.longitude : widget.userLongitude!;
      
//       mapController.animateCamera(
//         CameraUpdate.newLatLngBounds(
//           LatLngBounds(
//             southwest: LatLng(minLat, minLng),
//             northeast: LatLng(maxLat, maxLng),
//           ),
//           60, // Padding
//         ),
//       );
//     } catch (e) {
//       print("❌ Error zooming: $e");
//       mapController.animateCamera(
//         CameraUpdate.newLatLngZoom(
//           LatLng(widget.latitude, widget.longitude),
//           14,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Check if hospital coordinates are valid
//     if (widget.latitude == 0 && widget.longitude == 0) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.location_off, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               "Location not available",
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     return Stack(
//       children: [
//         GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: LatLng(widget.latitude, widget.longitude),
//             zoom: 14,
//           ),
//           markers: markers,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           zoomControlsEnabled: true,
//           zoomGesturesEnabled: true,
//           compassEnabled: true,
//           mapToolbarEnabled: true,
//           padding: EdgeInsets.zero,
//         ),
        
//         // ✅ Show message if user location not available
//         if (widget.userLatitude == null || widget.userLongitude == null)
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.orange,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.location_disabled, color: Colors.white),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       "Enable location to see your current position",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class EmbedMapView extends StatefulWidget {
//   final double latitude;
//   final double longitude;
//   final String hospitalName;
//   final String address;
//   final double? userLatitude;
//   final double? userLongitude;

//   const EmbedMapView({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//     required this.hospitalName,
//     required this.address,
//     this.userLatitude,
//     this.userLongitude,
//   });

//   @override
//   State<EmbedMapView> createState() => _EmbedMapViewState();
// }

// class _EmbedMapViewState extends State<EmbedMapView> {
//   late final WebViewController _controller;
//   bool isLoading = true;
  
//   // ✅ Store validated coordinates
//   late double validLatitude;
//   late double validLongitude;

//   // Your existing API key
//   final String apiKey = 'AIzaSyA2yoMDvhHLgLc94IguuMcwvzOQNRmMD6Y';

//   @override
//   void initState() {
//     super.initState();
//     _validateAndLoadMap();
//   }

//   void _validateAndLoadMap() {
//     // ✅ Validate and fix coordinates before loading
//     double lat = widget.latitude;
//     double lng = widget.longitude;
    
//     // Check if hospital coordinates are invalid
//     bool isInvalid = (lat < -90 || lat > 90 || lat == 0 || lat > 180 || lat < -180);
    
//     if (isInvalid) {
//       print("⚠️ Invalid hospital coordinates: $lat, $lng");
      
//       // ✅ Use user location if available
//       if (widget.userLatitude != null && widget.userLongitude != null) {
//         validLatitude = widget.userLatitude!;
//         validLongitude = widget.userLongitude!;
//         print("✅ Using user location as fallback: $validLatitude, $validLongitude");
//       } else {
//         // ✅ Default to Manjeri coordinates
//         validLatitude = 11.0361432;
//         validLongitude = 76.1021836;
//         print("✅ Using default coordinates: $validLatitude, $validLongitude");
//       }
//     } else {
//       validLatitude = lat;
//       validLongitude = lng;
//       print("✅ Using hospital coordinates: $validLatitude, $validLongitude");
//     }
    
//     _loadMap();
//   }

//   void _loadMap() {
//     final hasUserLocation = widget.userLatitude != null && widget.userLongitude != null;
    
//     String embedUrl;
    
//     if (hasUserLocation && validLatitude != 0 && validLongitude != 0) {
//       // Show route from user to hospital (using validated coordinates)
//       embedUrl = 'https://www.google.com/maps/embed/v1/directions'
//           '?key=AIzaSyA2yoMDvhHLgLc94IguuMcwvzOQNRmMD6Y'
//           '&origin=${widget.userLatitude},${widget.userLongitude}'
//           '&destination=$validLatitude,$validLongitude'
//           '&mode=driving';
//     } else {
//       // Show only hospital (using validated coordinates)
//       embedUrl = 'https://www.google.com/maps/embed/v1/place'
//           '?key=AIzaSyA2yoMDvhHLgLc94IguuMcwvzOQNRmMD6Y'
//           '&q=$validLatitude,$validLongitude'
//           '&zoom=16';
//     }
    
//     print("🗺️ MAP URL: $embedUrl");

//     final String html = '''
//     <!DOCTYPE html>
//     <html>
//     <head>
//         <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
//         <style>
//             body { margin: 0; padding: 0; }
//             #map { width: 100%; height: 100%; }
//         </style>
//     </head>
//     <body>
//         <iframe
//             src="$embedUrl"
//             width="100%"
//             height="100%"
//             frameborder="0"
//             style="border:0"
//             allowfullscreen>
//         </iframe>
//     </body>
//     </html>
//     ''';
    
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageFinished: (String url) {
//             setState(() => isLoading = false);
//           },
//           onWebResourceError: (error) {
//             print("❌ Error loading map: ${error.description}");
//             setState(() => isLoading = false);
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('data:text/html;charset=utf-8,${Uri.encodeComponent(html)}'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         WebViewWidget(controller: _controller),
//         if (isLoading)
//           const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(color: Colors.green),
//                 SizedBox(height: 10),
//                 Text("Loading map..."),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OSMMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String hospitalName;
  final String address;
  final double? userLatitude;
  final double? userLongitude;

  const OSMMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.hospitalName,
    required this.address,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  State<OSMMapView> createState() => _OSMMapViewState();
}

class _OSMMapViewState extends State<OSMMapView> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMap();
  }

  void _loadMap() {
    double lat = widget.latitude;
    double lng = widget.longitude;
    
    // Fix invalid coordinates
    if (lat < -90 || lat > 90 || lat == 0 || lat == 123456789) {
      lat = widget.userLatitude ?? 11.03614;
      lng = widget.userLongitude ?? 76.10219;
    }
    
    final hasUser = widget.userLatitude != null && widget.userLongitude != null;
    
    final String html = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
        <style>
            body, html { margin: 0; padding: 0; height: 100%; width: 100%; }
            #map { height: 100%; width: 100%; }
        </style>
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    </head>
    <body>
        <div id="map"></div>
        <script>
            var hospitalLat = $lat;
            var hospitalLng = $lng;
            var hasUser = ${hasUser ? 'true' : 'false'};
            var userLat = ${widget.userLatitude ?? 0};
            var userLng = ${widget.userLongitude ?? 0};
            
            var map = L.map('map').setView([hospitalLat, hospitalLng], 16);
            
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '© OpenStreetMap'
            }).addTo(map);
            
            // Hospital marker
            L.marker([hospitalLat, hospitalLng]).bindPopup('<b>${widget.hospitalName}</b><br>${widget.address}').addTo(map).openPopup();
            
            ${hasUser ? '''
            // User marker
            L.marker([userLat, userLng]).bindPopup('<b>Your Location</b>').addTo(map);
            
            // Route line
            L.polyline([[userLat, userLng], [hospitalLat, hospitalLng]], {color: 'blue', weight: 3}).addTo(map);
            
            // Fit both locations
            var bounds = L.latLngBounds([[userLat, userLng], [hospitalLat, hospitalLng]]);
            map.fitBounds(bounds);
            ''' : ''}
        </script>
    </body>
    </html>
    """;
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) => setState(() => isLoading = false),
          onWebResourceError: (error) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse('data:text/html;charset=utf-8,${Uri.encodeComponent(html)}'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (isLoading)
          const Center(child: CircularProgressIndicator(color: Colors.green)),
      ],
    );
  }
}