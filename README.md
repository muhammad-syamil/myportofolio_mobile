# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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