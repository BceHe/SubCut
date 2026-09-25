# Architecture.md: SubCut (Smart Subscription Tracker & Automated Recurring Expense Manager)

## 1. Project Overview & Purpose

**SubCut** is a full-stack, local-first mobile and desktop-ready application designed to help users combat "Subscription Fatigue" and "Subscription Drift". The application provides passive financial protection by tracking recurring digital subscriptions, automatically detecting transactions via local device notification listeners and on-device OCR, and presenting clear expenditure summaries without requiring bank credential sharing or cloud-based server dependencies.

## 2. Tech Stack & Environment

### Application Stack

| Layer | Technology | Responsibility |
| --- | --- | --- |
| Client framework | Flutter | Cross-platform mobile UI for Android and iOS |
| Language | Dart | Application, domain, and test code |
| Architecture | Feature-first | Isolates auth, dashboard, subscriptions, automation, and settings |
| Navigation | Flutter named routes | Central route definitions in `lib/routes/app_routes.dart` |
| Local database | SQLite via `sqflite` | Structured offline storage for subscriptions and transactions |
| Database encryption | SQLCipher-compatible SQLite driver | Encrypts the local database at rest |
| Secure key storage | `flutter_secure_storage` | Stores the database encryption key in Android Keystore or iOS Keychain |
| OCR | Google ML Kit Text Recognition | On-device receipt and invoice text recognition |
| Camera and images | `image_picker` or Flutter camera APIs | Captures or selects receipt images for OCR |
| Notifications | `flutter_local_notifications` | Schedules H-3 and H-1 local reminders |
| Android automation | Native Android Notification Listener Service | Reads permitted transaction notifications locally |
| External links | `url_launcher` | Opens official subscription management pages |
| Testing | Flutter test and widget tests | Validates domain logic, widgets, and user flows |

### Environment

* Flutter stable SDK and Dart SDK.
* Android Studio, Android SDK, and an Android emulator or physical device for Android development.
* Xcode and macOS are required for iOS builds and iOS device testing.
* No backend server is required for the core application.
* Optional configuration belongs in `.env.example`; financial data must not be stored in environment variables.

### Dependency Direction

```text
features -> core -> Flutter/plugins
routes   -> features
```

Feature code may use shared services, database abstractions, utilities, and widgets from `core`. The `core` layer must not import feature presentation code.

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

### SQLite Schema

The first implementation uses SQLite because subscriptions and transaction records have relationships, filters, and date-based sorting requirements. All dates are stored as ISO-8601 UTC strings, and all monetary values are stored as integer IDR amounts to avoid floating-point rounding errors.

#### `subscriptions`

| Column | Type | Constraints | Description |
| --- | --- | --- | --- |
| `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` | Local subscription identifier |
| `name` | `TEXT` | `NOT NULL` | Subscription or merchant name |
| `category` | `TEXT` | `NOT NULL` | Entertainment, productivity, storage, and so on |
| `price` | `INTEGER` | `NOT NULL CHECK (price >= 0)` | Amount in IDR |
| `billing_cycle` | `TEXT` | `NOT NULL` | `monthly` or `yearly` |
| `next_due_date` | `TEXT` | `NOT NULL` | Next billing date in ISO-8601 format |
| `is_trial` | `INTEGER` | `NOT NULL DEFAULT 0` | Boolean stored as `0` or `1` |
| `trial_end_date` | `TEXT` | `NULL` | Trial expiration date when applicable |
| `merchant_key` | `TEXT` | `NULL` | Normalized merchant identifier for matching |
| `created_at` | `TEXT` | `NOT NULL` | Record creation timestamp |
| `updated_at` | `TEXT` | `NOT NULL` | Last modification timestamp |
| `is_active` | `INTEGER` | `NOT NULL DEFAULT 1` | Soft-delete and active subscription flag |

#### `transaction_records`

| Column | Type | Constraints | Description |
| --- | --- | --- | --- |
| `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` | Local transaction identifier |
| `subscription_id` | `INTEGER` | `NULL`, foreign key | Related subscription when matched |
| `amount` | `INTEGER` | `NOT NULL CHECK (amount >= 0)` | Transaction amount in IDR |
| `transaction_date` | `TEXT` | `NOT NULL` | Transaction timestamp in ISO-8601 format |
| `source` | `TEXT` | `NOT NULL` | `notification`, `ocr`, or `manual` |
| `merchant_name` | `TEXT` | `NULL` | Merchant extracted from notification or OCR |
| `raw_text` | `TEXT` | `NULL` | Locally retained source text for parser review |
| `confidence` | `REAL` | `NULL` | OCR/parser confidence from `0.0` to `1.0` |
| `created_at` | `TEXT` | `NOT NULL` | Record creation timestamp |

#### `notification_settings`

| Column | Type | Constraints | Description |
| --- | --- | --- | --- |
| `id` | `INTEGER` | `PRIMARY KEY` | Single local settings record |
| `remind_days_before` | `TEXT` | `NOT NULL` | JSON array such as `[3, 1]` |
| `notifications_enabled` | `INTEGER` | `NOT NULL DEFAULT 1` | Boolean stored as `0` or `1` |
| `updated_at` | `TEXT` | `NOT NULL` | Last settings modification timestamp |

#### Relationships and indexes

```text
subscriptions (1) ---- (many) transaction_records
```

* `transaction_records.subscription_id` references `subscriptions.id` with `ON DELETE SET NULL`.
* Index `subscriptions(next_due_date, is_active)` for dashboard due-date sorting.
* Index `transaction_records(subscription_id, transaction_date)` for transaction history.
* Index `subscriptions(merchant_key)` for notification and OCR matching.

Example migration:

```sql
CREATE TABLE subscriptions (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	category TEXT NOT NULL,
	price INTEGER NOT NULL CHECK (price >= 0),
	billing_cycle TEXT NOT NULL CHECK (billing_cycle IN ('monthly', 'yearly')),
	next_due_date TEXT NOT NULL,
	is_trial INTEGER NOT NULL DEFAULT 0,
	trial_end_date TEXT,
	merchant_key TEXT,
	created_at TEXT NOT NULL,
	updated_at TEXT NOT NULL,
	is_active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE transaction_records (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	subscription_id INTEGER,
	amount INTEGER NOT NULL CHECK (amount >= 0),
	transaction_date TEXT NOT NULL,
	source TEXT NOT NULL CHECK (source IN ('notification', 'ocr', 'manual')),
	merchant_name TEXT,
	raw_text TEXT,
	confidence REAL CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
	created_at TEXT NOT NULL,
	FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE SET NULL
);

CREATE INDEX idx_subscriptions_due_date
	ON subscriptions(next_due_date, is_active);

CREATE INDEX idx_transactions_subscription_date
	ON transaction_records(subscription_id, transaction_date);
```

### Database Rules

* Data langganan, transaksi, dan pengaturan disimpan secara lokal menggunakan SQLite terenkripsi.
* Operasi CRUD dilakukan secara lokal tanpa mengirim data finansial ke server eksternal.
* Pembaruan tanggal jatuh tempo (*NextDueDate*) disesuaikan secara otomatis setelah siklus tagihan berikutnya terdeteksi atau dikonfirmasi.
* Database key disimpan di Android Keystore atau iOS Keychain, bukan di source code atau `.env`.
* `raw_text` is retained only locally and may be cleared by the user from settings.

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