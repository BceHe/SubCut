# Architecture.md: SubCut (Smart Subscription Tracker & Automated Recurring Expense Manager)

## 1. Project Overview & Purpose

**SubCut** is a full-stack, local-first mobile and desktop-ready application designed to help users combat "Subscription Fatigue" and "Subscription Drift". The application provides passive financial protection by tracking recurring digital subscriptions, automatically detecting transactions via local device notification listeners and on-device OCR, and presenting clear expenditure summaries without requiring bank credential sharing or cloud-based server dependencies.

│   ├── utils/                  # Format mata uang IDR & helper perhitungan tanggal
│   └── widgets/                # Komponen UI umum yang dipakai lintas fitur

## 2. Tech Stack & Environment
│   ├── auth/                   # Prototype akses lokal dan model pengguna

* **Framework:** Flutter (Dart) (`apps/mobile` or root Flutter structure)
* **Penyimpanan Lokal (Local Database):** SQLite / Hive (terenkripsi menggunakan SQLCipher)
* **OCR Engine:** Google ML Kit Text Recognition (On-Device)
* **Background Processing:** Android Notification Listener Service & Local Background Workers
* **Environment Configuration:** `.env.example` (jika diperlukan untuk integrasi opsional atau konfigurasi lokal)

---

## 3. Project Structure

```text
subcut/
├── android/
├── ios/
├── lib/
│   ├── core/
│   ├── features/
│   ├── app.dart
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md

```

---

## 4. Code & Naming Rules

* Do not add comments unless truly necessary.
* Use **PascalCase** for all classes, types, interfaces, enums, UI widgets, database models, and DTOs.
* Use **camelCase** for local variables and properties.
* Keep code lines below 150 characters where practical.
* Use a clean and simple feature-first folder structure.

---

## 5. Main Entities & Database Rules

### Entities

1. **Subscription**: `Id`, `Name`, `Category`, `Price`, `BillingCycle` (Monthly/Yearly), `NextDueDate`, `IsTrial`, `TrialEndDate`, `MerchantKey`, `CreatedAt`
2. **TransactionRecord**: `Id`, `SubscriptionId`, `Amount`, `TransactionDate`, `Source` (Notification/OCR/Manual), `CreatedAt`

### Database Rules

* Data langganan dan transaksi disimpan secara lokal di dalam perangkat menggunakan **SQLite / Hive** terenkripsi.
* Operasi CRUD dilakukan secara lokal tanpa mengirim data finansial ke server eksternal.
* Pembaruan tanggal jatuh tempo (*NextDueDate*) disesuaikan secara otomatis setelah siklus tagihan berikutnya terdeteksi atau dikonfirmasi.

---

## 6. Modul & Arsitektur Direktori (`lib/`)

Struktur kode menerapkan pendekatan *Feature-First* agar modular dan mudah dirawat:

```text
lib/
├── core/
│   ├── constants/              # Pola Regex untuk parsing teks bank/e-wallet, konstanta warna
│   ├── database/               # Konfigurasi lokal SQLite / Hive & enkripsi
│   ├── services/               # Background Notification Listener, Local Notifications, & ML Kit OCR
│   ├── utils/                  # Format mata uang IDR & helper perhitungan tanggal
│   └── widgets/                # Komponen UI umum yang dipakai lintas fitur
│
├── features/
│   ├── auth/                   # Prototype akses lokal dan model pengguna
│   ├── dashboard/              # Ringkasan Burn Rate & kartu langganan terdekat
│   ├── subscriptions/          # CRUD Manual & Detail Langganan
│   ├── automation/             # Notification Listener & OCR Receipt Scanner Engine
│   └── settings/               # Pengaturan pengingat lokal (H-3 / H-1) & preferensi
│
├── routes/                     # Definisi route dan navigasi antar screen
├── app.dart
└── main.dart

```

---

## 7. Fitur Utama & Alur Kerja Sistem

### Features

1. **Dashboard Ringkasan & Burn Rate**:
* Menampilkan total estimasi pengeluaran langganan bulanan dan tahunan.
* Kartu langganan aktif diurutkan berdasarkan tanggal jatuh tempo terdekat.


2. **Manajemen Data Langganan (CRUD Manual)**:
* Menambah, mengedit, dan menghapus entitas langganan secara manual.


3. **Pencatatan Otomatis via Notification Listener**:
* Membaca dan menganalisis teks notifikasi transaksi bank/e-wallet di latar belakang secara lokal.


4. **Peringatan & Notifikasi Lokal (Local Scheduled Alerts)**:
* Mengirim pengingat ke perangkat pada **H-3** dan **H-1** sebelum tanggal jatuh tempo atau masa uji coba berakhir.


5. **OCR Struk / Invoice Scanner (On-Device ML Kit)**:
* Memindai kuitansi digital secara lokal untuk mengekstrak nama merchant, nominal, dan tanggal secara otomatis.


6. **Simulasi Pembatalan (1-Tap Shortcut)**:
* Menyediakan tautan cepat/deep link ke halaman manajemen langganan resmi (Google Play / App Store / situs merchant).



### Ruang Lingkup yang Tidak Dikerjakan (*Out of Scope*)

* ❌ Integrasi Langsung Open Banking / API Perbankan Asli.
* ❌ Fitur Pembatalan Otomatis atas nama pengguna dari dalam aplikasi.
* ❌ Sistem Akun Multi-Device Cloud Sync (penyimpanan murni lokal).
* ❌ Pembayaran Tagihan Langsung (*Payment Gateway*).

---

## 8. Frontend & UI Requirements

* **Bahasa:** Menggunakan Bahasa Indonesia untuk seluruh label, tombol, pesan, dan validasi.
* **Desain & Komponen:** Antarmuka bersih, responsif, memanfaatkan tabel, kartu ringkasan, badge status, dan dialog konfirmasi.
* **Status / Indikator Waktu:**
* Menyoroti masa uji coba gratis (*Free Trial*) yang hampir habis.
* Peringatan jatuh tempo terdekat.



---

## 9. Deliverables & Setup Guidelines

* Kode sumber lengkap aplikasi Flutter.
* Skema database lokal dan inisialisasi penyimpanan terenkripsi.
* Konfigurasi *dependencies* pada `pubspec.yaml` (`flutter_local_notifications`, `google_mlkit_text_recognition`, sqflite/hive).
* `README.md` mencakup panduan instalasi, konfigurasi izin Android/iOS untuk *Notification Listener* dan *Camera/OCR*, serta cara menjalankan pengujian aplikasi.