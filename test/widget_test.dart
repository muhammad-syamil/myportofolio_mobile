import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const projectJson = {
  'id': '87c4cc02-2a5d-45f4-a29c-c4bbdf8475fe',
  'title': 'Portofolio Flutter',
  'description': 'Aplikasi portofolio',
  'tech_stack': 'Flutter, Django',
  'project_url': 'https://example.com/project',
  'project_image_url': '',
};

void main() {
  test('Model Project memetakan snake_case dan tidak mengirim id', () {
    final project = Project.fromJson(projectJson);
    expect(project.techStack, 'Flutter, Django');
    expect(project.toJson(), {
      'title': 'Portofolio Flutter',
      'description': 'Aplikasi portofolio',
      'tech_stack': 'Flutter, Django',
      'project_url': 'https://example.com/project',
      'project_image_url': '',
    });
    expect(
      Project.fromJson({...projectJson, 'project_image_url': null})
          .projectImageUrl,
      '',
    );
  });

  test('ApiClient memakai path dan header token yang benar', () async {
    final paths = <String>[];
    final client = ApiClient(
      baseUrl: 'http://localhost:8000',
      client: MockClient((request) async {
        paths.add(request.url.path);
        if (request.url.path.endsWith('/auth/token/')) {
          expect(jsonDecode(request.body), {
            'username': 'admin',
            'password': 'secret',
          });
          return http.Response('{"token":"abc"}', 200);
        }
        if (request.url.path.endsWith('/auth/logout/')) {
          expect(request.headers['authorization'], 'Token abc');
          return http.Response('', 204);
        }
        if (request.method == 'POST') {
          expect(request.headers['authorization'], 'Token abc');
          expect(jsonDecode(request.body)['tech_stack'], 'Flutter, Django');
          expect(jsonDecode(request.body).containsKey('id'), isFalse);
          return http.Response(jsonEncode(projectJson), 201);
        }
        return http.Response(jsonEncode([projectJson]), 200);
      }),
    );
    expect((await client.getProjects()).single.title, 'Portofolio Flutter');
    final token = await client.obtainToken('admin', 'secret');
    expect(token, 'abc');
    await client.createProject(Project.fromJson(projectJson), token: token);
    await client.logout(token: token);
    expect(paths, [
      '/api/v1/projects/',
      '/api/v1/auth/token/',
      '/api/v1/projects/',
      '/api/v1/auth/logout/',
    ]);
  });

  testWidgets('Daftar publik menampilkan proyek dan halaman detail', (
    tester,
  ) async {
    final client = ApiClient(
      client: MockClient(
        (_) async => http.Response(jsonEncode([projectJson]), 200),
      ),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Portofolio Flutter'), findsOneWidget);
    await tester.tap(find.text('Portofolio Flutter'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('Aplikasi portofolio'), findsOneWidget);
  });

  testWidgets('Tambah proyek meminta login lalu mengirim data', (tester) async {
    var created = false;
    final client = ApiClient(
      client: MockClient((request) async {
        if (request.url.path.endsWith('/auth/token/')) {
          return http.Response('{"token":"abc"}', 200);
        }
        if (request.method == 'POST') {
          created = true;
          expect(request.headers['authorization'], 'Token abc');
          return http.Response(jsonEncode(projectJson), 201);
        }
        return http.Response('[]', 200);
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Username'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(
      find.byType(ProjectFormPage),
      findsOneWidget,
      reason: tester
          .widgetList<Text>(find.byType(Text))
          .map((e) => e.data)
          .toList()
          .toString(),
    );
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Portofolio Flutter',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Aplikasi portofolio',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Flutter, Django');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'https://example.com/project',
    );
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(created, isTrue);
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
  });
}
