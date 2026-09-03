import 'package:flutter/material.dart';

void main() {
  runApp(const WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const HydrationScreen(),
    );
  }
}

class IntakeLog {
  final int amountMl;
  final String time;

  IntakeLog({required this.amountMl, required this.time});
}

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  final int _dailyGoalMl = 2500;
  int _currentMl = 750;

  final List<IntakeLog> _logs = [
    IntakeLog(amountMl: 500, time: '09:15'),
    IntakeLog(amountMl: 250, time: '11:40'),
  ];

  void _addWater(int ml) {
    final now = TimeOfDay.now();
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _currentMl += ml;
      _logs.insert(0, IntakeLog(amountMl: ml, time: formattedTime));
    });
  }

  void _resetDay() {
    setState(() {
      _currentMl = 0;
      _logs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentMl / _dailyGoalMl).clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _resetDay,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Today',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.lightBlue.shade200),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 14,
                          backgroundColor: Colors.lightBlue.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.lightBlue.shade600,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: Colors.lightBlue.shade600,
                            size: 32,
                          ),
                          Text(
                            '$percent%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$_currentMl / $_dailyGoalMl ml',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _quickAddButton(200),
                      _quickAddButton(350),
                      _quickAddButton(500),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Today\'s History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _logs.isEmpty
                  ? const Center(child: Text('No water logged yet today.'))
                  : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (ctx, index) {
                        final log = _logs[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.local_drink,
                              color: Colors.lightBlue,
                            ),
                            title: Text(
                              '+${log.amountMl} ml',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              log.time,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAddButton(int ml) {
    return FilledButton.tonalIcon(
      onPressed: () => _addWater(ml),
      icon: const Icon(Icons.add, size: 18),
      label: Text('${ml}ml'),
    );
  }
}
