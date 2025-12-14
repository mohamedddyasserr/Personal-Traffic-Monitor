import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// IMPORTANT: This file assumes you have generated firebase_options.dart
// by running `flutterfire configure`.
// If you haven't, comment out `options: DefaultFirebaseOptions.currentPlatform`
// and follow Firebase setup instructions.
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    // Continue running, UI will show error or placeholders
  }

  runApp(const PersonTrafficApp());
}

class PersonTrafficApp extends StatelessWidget {
  const PersonTrafficApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Person Traffic Monitor',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      home: const TrafficDashboard(),
    );
  }
}

class TrafficDashboard extends StatefulWidget {
  const TrafficDashboard({super.key});

  @override
  State<TrafficDashboard> createState() => _TrafficDashboardState();
}

class _TrafficDashboardState extends State<TrafficDashboard> {
  DatabaseReference? _countRef;

  // Placeholder for when we don't have connection
  int _currentCount = 0;
  bool _connected = false;
  String? _firebaseError;

  @override
  void initState() {
    super.initState();
    _initFirebaseRef();
  }

  void _initFirebaseRef() {
    try {
      // Check if Firebase is initialized before accessing instance
      if (Firebase.apps.isNotEmpty) {
        _countRef = FirebaseDatabase.instance.ref(
          '/people_counter/current_count',
        );
      } else {
        _firebaseError = "Firebase not initialized";
      }
    } catch (e) {
      _firebaseError = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Person Traffic Monitor',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Live Video Feed Section
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.videocam_off_outlined,
                              size: 64,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Live Camera Feed',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Waiting for ESP-CAM stream...',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 8, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "LIVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Count Display Section
              Expanded(
                flex: 2,
                child: _countRef == null
                    ? _buildErrorState(
                        _firebaseError ?? "Firebase Setup Required",
                      )
                    : StreamBuilder(
                        stream: _countRef!.onValue,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return _buildErrorState("Connection Error");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildLoadingState();
                          }

                          if (snapshot.hasData &&
                              snapshot.data!.snapshot.value != null) {
                            try {
                              _currentCount = int.parse(
                                snapshot.data!.snapshot.value.toString(),
                              );
                              _connected = true;
                            } catch (e) {
                              // Fallback if data is not an integer
                            }
                          }

                          return _buildCountDisplay(_currentCount, _connected);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountDisplay(int count, bool active) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1E88E5), const Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Visitors',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            count.toString(),
            style: GoogleFonts.outfit(
              fontSize: 96,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: active
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.black12,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  active ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  active ? "Sensor Online" : "Sensor Offline",
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(String message) {
    bool isSetupError =
        message.contains("Setup") || message.contains("Firebase");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1E1E),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSetupError
                    ? Icons.settings_applications_outlined
                    : Icons.cloud_off,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                isSetupError ? "Setup Required" : "Connection Issue",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
              ),
              if (isSetupError) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Run 'flutterfire configure' in terminal",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
