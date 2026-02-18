import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 3;
  bool isEditing = false;

  final TextEditingController nameController =
      TextEditingController(text: "Alex");
  final TextEditingController ageController =
      TextEditingController(text: "35");
  final TextEditingController conditionController =
      TextEditingController(text: "ME/CFS");
  final TextEditingController restingController =
      TextEditingController(text: "68");
  final TextEditingController maxController =
      TextEditingController(text: "180");

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    conditionController.dispose();
    restingController.dispose();
    maxController.dispose();
    super.dispose();
  }

  void toggleEditSave() {
    setState(() {
      if (isEditing) {
        // SAVE
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully")),
        );
      }
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Insights"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Zones"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🔴 HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(color: Colors.red),
                child: const Column(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Manage your personal information",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 👤 PROFILE CARD (updates dynamically)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.person,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameController.text,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("${ageController.text} years old"),
                          const SizedBox(height: 5),
                          Text(
                            "Condition: ${conditionController.text}",
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// HEALTH BASELINE TITLE + EDIT BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Health Baseline",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: toggleEditSave,
                      child: Text(isEditing ? "Save" : "Edit"),
                    )
                  ],
                ),
              ),

              buildCard([
                buildField("Name", nameController),
                buildField("Age", ageController),
                buildField("Condition", conditionController),
                buildField("Resting Heart Rate (bpm)", restingController),
                const Text(
                  "Your heart rate when completely at rest",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                buildField("Maximum Heart Rate (bpm)", maxController),
                const Text(
                  "Adjusted maximum for your condition",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ]),

              const SizedBox(height: 20),

              /// GOALS
              buildSectionTitle("Your Goals"),
              buildCard([
                goalItem("Improve pacing"),
                goalItem("Reduce PEM episodes"),
                goalItem("Track recovery"),
              ]),

              const SizedBox(height: 20),

              /// ZONES FULL CONTENT
              buildSectionTitle("How Your Zones Are Calculated"),
              buildCard([
                const Text(
                  "Your personalized activity zones are calculated using "
                  "your resting heart rate and maximum heart rate.\n\n"
                  "The formula uses Heart Rate Reserve (HRR), which is:\n"
                  "HRR = Maximum HR - Resting HR\n\n"
                  "Each zone represents a percentage of this reserve:\n\n"
                  "Zone 1 (Recovery): 0-30% of HRR\n"
                  "Zone 2 (Sustainable): 30-50% of HRR\n"
                  "Zone 3 (Caution): 50-65% of HRR\n"
                  "Zone 4 (Risk): 65-80% of HRR\n"
                  "Zone 5 (Overexertion): 80-100% of HRR\n\n"
                  "These percentages are adapted to be conservative and "
                  "safe for energy-limiting conditions.",
                  style: TextStyle(color: Colors.grey),
                )
              ]),

              const SizedBox(height: 20),

              /// DATA & PRIVACY (mixed properly)
              /// DATA & PRIVACY (updated for same width as Zones)
buildSectionTitle("Data & Privacy"),
buildCard([
  const Text(
    "All your health data is stored locally on your device. "
    "No data is sent to external servers. Your information "
    "remains private and under your control.\n\n"
    "You can export your data at any time for personal backup "
    "or permanently clear all stored information from the app.",
    style: TextStyle(color: Colors.grey),
  ),
  const SizedBox(height: 20),
  Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Exporting data...")),
            );
          },
          child: const Text("Export Data"),
        ),
      ),
      const SizedBox(width: 15),
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All data cleared!")),
            );
          },
          child: const Text("Clear All Data"),
        ),
      ),
    ],
  ),
]),

              const SizedBox(height: 20),

              /// ABOUT ELAROS
              buildSectionTitle("About Elaros"),
              buildCard([
                const Text(
                  "Elaros is designed to help individuals with energy-limiting "
                  "conditions such as ME/CFS, Long COVID, and Fibromyalgia "
                  "better understand and manage their activity levels.\n\n"
                  "By providing insights from wearable device data, "
                  "Elaros supports better pacing strategies and helps "
                  "prevent post-exertional malaise (PEM).\n\n"
                  "Version 1.0.0\n"
                  "Built with care for the chronic illness community.",
                  style: TextStyle(color: Colors.grey),
                )
              ]),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildCard(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  isEditing ? Colors.white : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget goalItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}