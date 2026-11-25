# myportofolio_mobile

Aplikasi portofolio mobile Muhammad Syamil untuk mata kuliah Pemrograman Berbasis Platform. Daftar dan formulir proyek kini terhubung ke API Django; formulir pengalaman masih menampilkan ringkasan input secara lokal.

## Tutorial 10: Integrasi API

Aplikasi Flutter sekarang mengambil daftar proyek publik dari Django REST Framework, menampilkan detailnya, dan mengirim proyek baru menggunakan token autentikasi. Token hanya disimpan di memori selama aplikasi berjalan. Model JSON dihasilkan dengan `json_serializable`; berkas `*.g.dart` dibuat ulang saat build dan tidak disimpan di Git.

Siapkan dependensi dan generator sebelum menjalankan aplikasi:

```sh
flutter pub get
dart run build_runner build
```

Gunakan URL backend sesuai perangkat:

```sh
# Emulator Android (default): http://10.0.2.2:8000
flutter run

# Chrome dengan Django lokal
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000

# Backend yang sudah di-deploy
flutter run --dart-define=API_BASE_URL=https://domain-backend.example
```

Backend Django yang digunakan harus menyediakan `GET/POST /api/v1/projects/`, `POST /api/v1/auth/token/`, dan `POST /api/v1/auth/logout/`. Skema proyek yang dipakai aplikasi adalah `id`, `title`, `description`, `tech_stack`, `project_url`, dan `project_image_url`. Aktifkan `rest_framework.authtoken`, `TokenAuthentication`, migrasi token, dan CORS untuk Flutter Web pada repositori Django. Tambahkan `10.0.2.2` ke `ALLOWED_HOSTS` untuk emulator Android. Repositori Django berada di luar folder ini, sehingga konfigurasi server perlu dikerjakan di sana sebelum pengujian end-to-end.

Workflow `.github/workflows/main.yaml` menjalankan analisis, tes, generator JSON, dan build APK. Untuk APK yang terhubung ke backend deploy, isi variabel repositori GitHub Actions `API_BASE_URL` dengan URL HTTPS backend tanpa `/` di akhir. Jika variabel tidak diisi, APK menggunakan URL emulator lokal bawaan.

## Getting Started

Pasang Flutter SDK, lalu dari direktori utama jalankan:

```sh
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

Buka formulir melalui kartu pada halaman utama atau drawer. Untuk memeriksa kode dan perilaku widget, jalankan `flutter analyze` dan `flutter test`.

### Tugas 7

1. Widget tree adalah susunan widget yang membentuk antarmuka Flutter. Widget induk menerima widget anak melalui properti seperti `child` atau `children`. Contohnya, `Scaffold` menjadi induk bagi `AppBar` dan `Padding`, lalu `Padding` menjadi induk bagi `Column`.

2. Widget yang digunakan dalam proyek ini:
   - `MyApp`: widget utama aplikasi.
   - `MaterialApp`: mengatur tema dan halaman awal aplikasi.
   - `MyHomePage`: menampilkan halaman menu utama.
   - `Scaffold`: menyediakan struktur halaman seperti app bar dan body.
   - `AppBar`: menampilkan judul di bagian atas.
   - `Text`: menampilkan tulisan.
   - `Padding`: memberi jarak di sekitar widget.
   - `Column`: menyusun widget secara vertikal.
   - `Row`: menyusun kartu identitas secara horizontal.
   - `SizedBox`: memberi jarak antarbagian.
   - `Center`: menempatkan widget di tengah.
   - `GridView`: menyusun tombol aksi dalam tiga kolom.
   - `InfoCard` dan `Card`: menampilkan informasi profil dalam kartu.
   - `Container`: mengatur ukuran dan jarak dalam kartu.
   - `ItemCard` dan `Material`: menampilkan tombol aksi dengan warna masing-masing.
   - `InkWell`: mendeteksi ketukan pada tombol.
   - `Icon`: menampilkan ikon tombol.
   - `SnackBar`: menampilkan pesan saat tombol ditekan.

3. `MaterialApp` adalah widget yang menyediakan konfigurasi dasar aplikasi bergaya Material, termasuk tema dan halaman awal. Widget ini digunakan sebagai root agar widget di bawahnya dapat memakai konfigurasi tersebut melalui `BuildContext`.

4. `StatelessWidget` tidak menyimpan state lokal yang berubah selama widget digunakan. `StatefulWidget` memiliki objek `State` yang dapat diperbarui, misalnya dengan `setState()`. Halaman menu ini memakai `StatelessWidget` karena datanya tetap. `StatefulWidget` cocok untuk halaman dengan nilai yang berubah, seperti penghitung atau input formulir.

5. `BuildContext` menunjukkan posisi sebuah widget di dalam widget tree. Melalui context, widget dapat mengakses widget induk yang menyediakan fasilitas tertentu. Dalam metode `build`, proyek ini memakainya pada `Theme.of(context)` untuk mengambil tema, `MediaQuery.of(context)` untuk membaca ukuran layar, dan `ScaffoldMessenger.of(context)` untuk menampilkan `SnackBar`.

6. Hot reload memasukkan perubahan kode ke aplikasi yang sedang berjalan sambil mempertahankan state. Hot restart menjalankan ulang kode Dart dari awal sehingga state ter-reset. Hot restart diperlukan jika perubahan harus menjalankan ulang `main()` atau inisialisasi state. Perubahan pada kode native atau konfigurasi platform dapat memerlukan full restart atau build ulang.

#### Penggunaan AI

Saya menggunakan Codex untuk membantu menyusun kode Flutter, terutama ketika terjadinya error yang tidak saya pahami, saya menggunakan codex untuk solve error tsb.

### Tutorial 9

Mengikuti [Tutorial 09 PBP](https://pbp.cs.ui.ac.id/tutorial/tutorial-9.html), aplikasi sekarang memiliki drawer untuk berpindah antara Home dan Add Project. Tombol Tambah Proyek pada menu utama juga membuka formulir proyek. Formulir berisi nama, deskripsi, kategori, teknologi, dan tautan proyek; nama serta deskripsi wajib diisi. Setelah Save, dialog menampilkan ringkasan isian dan tombol OK mengosongkan formulir. Pada tahap tutorial ini, data proyek hanya ditampilkan di dialog.

Berkas halaman berada di `lib/screens/`, sedangkan drawer dan kartu menu berada di `lib/widgets/`. Implementasi dan pemeriksaan kode Tutorial 9 dibantu oleh Codex.

### Tugas 8

1. `Navigator.push()` menumpuk halaman baru di atas halaman saat ini sehingga tombol kembali dapat kembali ke halaman sebelumnya. `Navigator.pushReplacement()` mengganti halaman saat ini dalam riwayat navigasi. `Navigator.pop()` menutup halaman atau dialog paling atas. Kartu Tambah Pengalaman memakai `push()` agar pengguna bisa kembali ke menu dengan tombol kembali. Opsi Home pada drawer memakai `pushReplacement()` untuk membuka halaman utama saat berada di formulir.
2. `Scaffold` menyediakan kerangka yang sama untuk `AppBar`, `Drawer`, dan isi halaman. Drawer yang sama dipakai di halaman utama dan kedua formulir. Warna `Theme.of(context).colorScheme.primary` dipakai pada AppBar halaman utama dan formulir Pengalaman agar tampilannya konsisten.
3. Formulir Pengalaman memakai `SingleChildScrollView` yang berisi `Column` agar kolom dan tombol Simpan dapat digulir pada layar sempit atau saat papan ketik tampil. `SizedBox` memberi jarak tetap antarkolom supaya label, pesan validasi, dan tombol tidak saling menempel.
4. `GlobalKey<FormState>` memberi akses ke state formulir. Saat Simpan ditekan, `validate()` menjalankan setiap `validator` dan dialog hanya muncul jika semuanya valid. Judul yang hanya berisi spasi ditolak, begitu pula URL thumbnail seperti `alamat-tidak-valid`. Memilih papan ketik URL tidak menjamin pengguna memasukkan URL yang benar, sehingga pemeriksaan nilai tetap diperlukan.

Formulir Pengalaman mengikuti field `Experience` pada portofolio web: judul (`title`, maksimal 255 karakter), deskripsi, kategori dari pilihan model, dan URL thumbnail opsional. Input yang lolos validasi ditampilkan dalam dialog, lalu formulir dikosongkan setelah OK.

**Penggunaan AI:** Membantu nge spot eror
