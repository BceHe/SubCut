# How to Run SubCut

## Prasyarat

- Flutter SDK yang kompatibel dengan Dart 3.3 atau lebih baru.
- Android emulator/perangkat untuk pengujian notifikasi dan OCR.
- Jalankan `flutter doctor` dan pastikan toolchain Android tidak bermasalah.

## Menjalankan aplikasi

```powershell
flutter pub get
flutter run
```

Untuk web/demo cepat:

```powershell
flutter run -d chrome
```

## Catatan `flutter doctor` di Windows

Jika muncul pesan:

```text
[X] Visual Studio - develop Windows apps
Visual Studio not installed
```

itu hanya berarti target **Windows Desktop** belum tersedia. Pesan tersebut
tidak menghalangi pengembangan atau demo melalui Android, iOS, maupun web.

Untuk menjalankan SubCut di Windows Desktop, install Visual Studio Community
dari https://visualstudio.microsoft.com/downloads/ lalu pilih workload:

- **Desktop development with C++**
- komponen default workload tersebut

Setelah instalasi selesai, jalankan:

```powershell
flutter doctor
flutter devices
flutter run -d windows
```

Untuk scope MVP SubCut, target yang direkomendasikan adalah Android emulator
atau perangkat Android karena fitur kamera/OCR dan notifikasi lokal perlu diuji
di platform mobile.

## Pengujian

```powershell
flutter analyze
flutter test
flutter test integration_test/subscription_persistence_test.dart -d <device-id>
```

Tes integration membutuhkan Android emulator atau perangkat fisik. Fitur kamera,
OCR, dan notifikasi harus didemonstrasikan pada Android/iOS, bukan web.

## Alur demo

1. Pada penggunaan pertama, masukkan nama untuk ditampilkan di halaman profil.
2. Nama disimpan secara lokal; setelah itu aplikasi langsung membuka dashboard.
3. Buka profil untuk memverifikasi nama yang tersimpan.
4. Dari profil, tetapkan anggaran bulanan dan simpan.
5. Kembali ke dashboard dan verifikasi perbandingan burn rate dengan anggaran.
6. Tambahkan langganan manual dan verifikasi kartu serta ringkasan burn rate.
7. Edit langganan, kembali ke dashboard, lalu verifikasi nilai terbaru.
8. Buka detail dan hapus langganan setelah konfirmasi.
9. Uji OCR invoice dan parser notifikasi, konfirmasi hasil ekstraksi, lalu simpan.
10. Buka detail dan gunakan shortcut pembatalan.
11. Tutup dan jalankan ulang aplikasi untuk memverifikasi nama, anggaran, dan data langganan tetap tersimpan.

### Uji kamera dan OCR

1. Buka form **Tambah langganan**.
2. Pilih **Scan invoice dengan kamera**.
3. Pilih **Ambil foto invoice** atau **Pilih dari galeri**.
4. Izinkan akses kamera jika Android memintanya.
5. Jika dibatalkan, form tetap aman dan dapat diisi manual.
6. Setelah OCR selesai, periksa nama, nominal, dan tanggal yang terdeteksi sebelum menyimpan.
