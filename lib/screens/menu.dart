import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const items = [
    ItemHomepage('Lihat Proyek', Icons.folder, Colors.blue),
    ItemHomepage('Tambah Proyek', Icons.add_circle, Colors.green),
    ItemHomepage('Logout', Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Row(
            children: [
              Expanded(
                child: InfoCard(title: 'NPM', content: '2506547746'),
              ),
              Expanded(
                child: InfoCard(title: 'Name', content: 'Muhammad Syamil'),
              ),
              Expanded(
                child: InfoCard(title: 'Class', content: 'PBP D'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Selamat datang di MyPortfolio Mobile!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          GridView.count(
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: items.map((item) => ItemCard(item)).toList(),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
