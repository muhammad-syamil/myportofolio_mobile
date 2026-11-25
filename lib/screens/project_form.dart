import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _techStack = TextEditingController();
  final _projectUrl = TextEditingController();
  final _imageUrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _techStack.dispose();
    _projectUrl.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Kolom ini wajib diisi.' : null;

  String? _validUrl(String? value, {bool optional = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return optional ? null : 'URL wajib diisi.';
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return 'Masukkan URL http:// atau https:// yang valid.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context) || !mounted) return;
    final token = context.read<AuthState>().token;
    if (token == null) return;
    final project = Project(
      title: _title.text.trim(),
      description: _description.text.trim(),
      techStack: _techStack.text.trim(),
      projectUrl: _projectUrl.text.trim(),
      projectImageUrl: _imageUrl.text.trim(),
    );
    setState(() => _isSubmitting = true);
    try {
      final created = await context.read<ApiClient>().createProject(
        project,
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: Text('Proyek ${created.title} telah disimpan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
      _title.clear();
      _description.clear();
      _techStack.clear();
      _projectUrl.clear();
      _imageUrl.clear();
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi berakhir. Silakan login kembali.'),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan proyek (HTTP ${error.statusCode}).'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat menghubungi server.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Proyek')),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _techStack,
              decoration: const InputDecoration(
                labelText: 'Tech Stack',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _projectUrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Project URL',
                border: OutlineInputBorder(),
              ),
              validator: _validUrl,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Project Image URL (Optional)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validUrl(value, optional: true),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
