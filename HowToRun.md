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

1. Aplikasi dibuka langsung ke dashboard tanpa login.
2. Untuk membuat atau mengganti akun, buka halaman akun dari menu profil.
3. Isi nama, email, dan kata sandi minimal 4 karakter, lalu pilih **Buat akun**.
4. Setiap akun memiliki ruang data subscription sendiri.
5. Tambahkan langganan manual dan verifikasi kartu serta ringkasan burn rate.
6. Edit langganan, kembali ke dashboard, lalu verifikasi nilai terbaru.
7. Buka detail dan hapus langganan setelah konfirmasi.
8. Uji OCR invoice dan parser notifikasi, konfirmasi hasil ekstraksi, lalu simpan.
9. Buka detail dan gunakan shortcut pembatalan.
10. Tutup dan jalankan ulang aplikasi untuk memverifikasi persistence.
