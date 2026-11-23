import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();

  String _category = 'full-time';

  static const _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label tidak boleh kosong!';
    }
    return null;
  }

  String? _validateThumbnail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return 'Masukkan URL http:// atau https:// yang valid.';
    }
    return null;
  }

  void _showSummary() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final thumbnail = _thumbnailController.text.trim();
    final category = _categories[_category]!;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pengalaman berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: $title'),
              Text('Deskripsi: $description'),
              Text('Kategori: $category'),
              Text('URL Thumbnail: ${thumbnail.isEmpty ? '-' : thumbnail}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _formKey.currentState!.reset();
              setState(() => _category = 'full-time');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengalaman'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 255,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Judul Pengalaman',
                  hintText: 'Contoh: Asisten Dosen PBP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final requiredError = _validateRequired(value, 'Judul');
                  if (requiredError != null) return requiredError;
                  if (value!.trim().length > 255) {
                    return 'Judul maksimal 255 karakter.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Ceritakan pengalamanmu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _validateRequired(value, 'Deskripsi'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: 'full-time',
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _categories.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) _category = value;
                },
                validator: (value) => _categories.containsKey(value)
                    ? null
                    : 'Pilih kategori pengalaman.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thumbnailController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL Thumbnail (opsional)',
                  hintText: 'https://example.com/gambar.jpg',
                  border: OutlineInputBorder(),
                ),
                validator: _validateThumbnail,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _showSummary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
