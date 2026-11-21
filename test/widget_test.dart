import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
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
}
