import 'package:flutter/material.dart';

class ScenarioDetailScreen extends StatelessWidget {
  final String scenarioId;

  const ScenarioDetailScreen({super.key, required this.scenarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الخطوات')),
      body: Center(child: Text('Steps for: $scenarioId')),
    );
  }
}
