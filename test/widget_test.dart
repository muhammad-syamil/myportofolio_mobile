import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

void main() {
  testWidgets('Tambah Proyek membuka form dan menampilkan ringkasan', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Aplikasi Portofolio',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Proyek Flutter');
    await tester.ensureVisible(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: Aplikasi Portofolio'), findsOneWidget);
    expect(find.text('Deskripsi: Proyek Flutter'), findsOneWidget);
    expect(find.text('Kategori: Web Development'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Proyek berhasil ditambahkan!'), findsNothing);
    expect(find.text('Aplikasi Portofolio'), findsNothing);
  });

  testWidgets('Drawer berpindah antara Home dan Add Project', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('Form Pengalaman memvalidasi input dan menampilkan ringkasan', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Pengalaman'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(find.byType(TextFormField).at(0), '   ');
    await tester.enterText(find.byType(TextFormField).at(1), 'Mengajar PBP');
    await tester.ensureVisible(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Asisten Dosen PBP',
    );
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'alamat-tidak-valid',
    );
    await tester.ensureVisible(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(
      find.text('Masukkan URL http:// atau https:// yang valid.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(
      find.byType(TextFormField).at(2),
      'https://example.com/gambar.jpg',
    );
    await tester.tap(find.text('Full-Time'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Research').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Pengalaman berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Judul: Asisten Dosen PBP'), findsOneWidget);
    expect(find.text('Deskripsi: Mengajar PBP'), findsOneWidget);
    expect(find.text('Kategori: Research'), findsOneWidget);
    expect(
      find.text('URL Thumbnail: https://example.com/gambar.jpg'),
      findsOneWidget,
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(0))
          .controller!
          .text,
      isEmpty,
    );
  });

  testWidgets('Drawer membuka Pengalaman dan Home pada layar sempit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await tester.ensureVisible(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Simpan'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });
}
