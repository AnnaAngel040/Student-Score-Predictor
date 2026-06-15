import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScholarMetrics Predictor',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A1118),
        cardColor: const Color(0xFF121E29),
        primaryColor: const Color(0xFF58A6FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF58A6FF),
          surface: Color(0xFF121E29),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Parameters State
  double hoursPerWeek = 35;
  double attendancePct = 92;
  String gender = "Male";
  bool privateTutoring = true;
  String region = "Urban";

  // API response state
  double predictedScore = 85; // Default display score
  bool isLoading = false;

  // Fully Functional API Connection
  Future<void> predictScore() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse("https://student-score-predictor-oo0j.onrender.com/predict");


      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "hours": hoursPerWeek,
          "attendance": attendancePct,
          "gender": gender,
          "tutoring": privateTutoring ? "Yes" : "No",
          "region": region,
        }),
      );
      

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          predictedScore = (data["predicted_score"] as num).toDouble();
        });
      } else {
        _showSnackBar("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackBar("Connection Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 1. LEFT SIDEBAR
          _buildSidebar(),

          // 2. MAIN CONTENT AREA
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Parameters Control Card
                        Expanded(flex: 2, child: _buildParametersCard()),
                        const SizedBox(width: 24),
                        // Results and Analytics Insights Column
                        Expanded(flex: 3, child: _buildResultsColumn()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSidebar() {
    return Container(
      width: 260,
      color: const Color(0xFF070D14),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: Color(0xFF58A6FF), size: 28),
              const SizedBox(width: 10),
              Text(
                'ScholarMetrics',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Research Portal • Analytical Insights v2.4',
              style: TextStyle(fontSize: 10, color: Color(0xFF58A6FF)),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F3A52),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: predictScore,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Analysis'),
          ),
          const SizedBox(height: 32),
          _sidebarItem(Icons.dashboard_outlined, 'Dashboard', false),
          _sidebarItem(Icons.online_prediction, 'Score Predictor', true),
          _sidebarItem(Icons.history, 'Academic History', false),
          _sidebarItem(Icons.insights, 'Research Insights', false),
          _sidebarItem(Icons.folder_open, 'Resources', false),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF121E29) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? const Color(0xFF58A6FF) : Colors.grey),
        title: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 14),
        ),
        dense: true,
        horizontalTitleGap: 0,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0A1118),
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937), width: 1)),
      ),
      child: Row(
        children: [
          const Text(
            'Predictor',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 32),
          _headerTab('Active Session', true),
          _headerTab('Cloud Sync', false),
          const Spacer(),
          SizedBox(
            width: 240,
            height: 36,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 16, color: Colors.grey),
                hintText: 'Search datasets...',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                fillColor: const Color(0xFF121E29),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.notifications_none, color: Colors.grey),
          const SizedBox(width: 16),
          const Icon(Icons.settings, color: Colors.grey),
          const SizedBox(width: 16),
          const CircleAvatar(radius: 14, backgroundColor: Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _headerTab(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? const Color(0xFF58A6FF) : Colors.grey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildParametersCard() {
    return Card(
      elevation: 0,
      color: const Color(0xFF0E1720),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1F2937)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.tune, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Text('Parameters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Adjust your study habits and environment to see predicted outcomes.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // HOURS PER WEEK SLIDER
            _buildSliderLabel("HOURS / WEEK", "${hoursPerWeek.round()}"),
            Slider(
              value: hoursPerWeek,
              min: 0,
              max: 60,
              activeColor: const Color(0xFF58A6FF),
              inactiveColor: const Color(0xFF1F2937),
              onChangeEnd: (val) => predictScore(),
              onChanged: (val) => setState(() => hoursPerWeek = val),
            ),

            // ATTENDANCE SLIDER
            _buildSliderLabel("ATTENDANCE %", "${attendancePct.round()}%"),
            Slider(
              value: attendancePct,
              min: 0,
              max: 100,
              activeColor: const Color(0xFF58A6FF),
              inactiveColor: const Color(0xFF1F2937),
              onChangeEnd: (val) => predictScore(),
              onChanged: (val) => setState(() => attendancePct = val),
            ),
            const SizedBox(height: 16),

            // GENDER IDENTITY TOGGLE
            _buildComponentLabel("GENDER IDENTITY"),
            Row(
              children: [
                _buildSegmentButton("Male", gender == "Male", () {
                  setState(() => gender = "Male");
                  predictScore();
                }),
                _buildSegmentButton("Female", gender == "Female", () {
                  setState(() => gender = "Female");
                  predictScore();
                }),
              ],
            ),
            const SizedBox(height: 20),

            // PRIVATE TUTORING SWITCH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildComponentLabel("PRIVATE TUTORING"),
                Switch(
                  value: privateTutoring,
                  activeColor: const Color(0xFF58A6FF),
                  onChanged: (val) {
                    setState(() => privateTutoring = val);
                    predictScore();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // REGION TOGGLE
            _buildComponentLabel("REGION"),
            Row(
              children: [
                _buildSegmentButton("Rural", region == "Rural", () {
                  setState(() => region = "Rural");
                  predictScore();
                }),
                _buildSegmentButton("Urban", region == "Urban", () {
                  setState(() => region = "Urban");
                  predictScore();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsColumn() {
    return Column(
      children: [
        // Top Forecast Output Gauge Card
        Card(
          elevation: 0,
          color: const Color(0xFF0E1720),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF1F2937)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const Text(
                  'FORECAST RESULT',
                  style: TextStyle(fontSize: 11, letterSpacing: 1.5, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: isLoading ? null : predictedScore / 100,
                        strokeWidth: 12,
                        backgroundColor: const Color(0xFF1F2937),
                        color: const Color(0xFF58A6FF),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLoading ? '--' : '${predictedScore.round()}',
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const Text('out of 100', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Distinction Prediction',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Based on current trajectory and environmental variables, this model predicts a high-performing academic standing.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Bottom Insights Split Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInsightCard(
                icon: Icons.trending_up,
                title: 'Positive Impact',
                color: const Color.fromARGB(255, 8, 96, 102),
                items: [
                  'Attendance consistency (+12%)',
                  'Private tutoring efficacy (+8%)',
                  'Urban resource availability (+4%)',
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                icon: Icons.track_changes,
                title: 'Optimization Path',
                color: Colors.lightBlueAccent,
                items: [
                  'Increase study to 42 hrs/week',
                  'Maintain 90%+ attendance',
                  'Focus on STEM lab sessions',
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildInsightCard({required IconData icon, required String title, required Color color, required List<String> items}) {
    return Card(
      elevation: 0,
      color: const Color(0xFF0E1720),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1F2937)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE SUB-ELEMENTS ---

  Widget _buildSliderLabel(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildComponentLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
      ),
    );
  }

  Widget _buildSegmentButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1F2937) : const Color(0xFF111922),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? const Color(0xFF374151) : const Color(0xFF1F2937),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}