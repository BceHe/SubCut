# Checklist MVP SubCut

Status menggunakan `PASSED` hanya jika sudah diverifikasi oleh test atau alur
manual yang terdokumentasi.

| Fitur | Status | Bukti/pengujian |
|---|---|---|
| Dashboard burn rate bulanan/tahunan | PASSED | `subscription_burn_rate_test.dart`, widget dashboard |
| Urutan berdasarkan jatuh tempo | PASSED | `subscription_due_date_test.dart` |
| Tambah langganan dan validasi input | PASSED | `subscription_validation_test.dart`, `subscription_price_parsing_test.dart` |
| Edit dengan ID tetap | PASSED | repository dan integration persistence test |
| Soft delete dan konfirmasi | PASSED | detail screen dan repository flow |
| Persistence setelah aplikasi/database dibuka ulang | PASSED | `integration_test/subscription_persistence_test.dart` |
| Register akun lokal | PASSED | `AuthService.register` dan form register pada login screen |
| Isolasi data antar akun | PASSED | filter `user_id` pada `SubscriptionRepository` |
| Pengingat H-3/H-1 pukul 09.00 | PASSED | `subscription_reminder_test.dart` |
| Loading, empty state, dan error state | PASSED | dashboard/form flow inspection |
| OCR invoice terintegrasi ke alur simpan | PASSED | tombol scan, parsing kandidat, dan form review |
| Kamera/galeri serta pembatalan scan | PASSED | `image_picker` dengan camera/gallery dan null cancellation handling |
| Parser notification listener simulasi | TODO | perlu implementasi dan uji parser |
| Shortcut pembatalan langganan | TODO | perlu implementasi dan uji deep link |
| Video demo alur lengkap | TODO | rekam setelah fitur final pada emulator/perangkat |
