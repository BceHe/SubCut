# ⚡ SubCut

> **Smart Subscription Tracker & Automated Recurring Expense Manager**

**SubCut** adalah aplikasi mobile berbasis *privacy-first* yang dirancang untuk membantu pengguna memantau, melacak, dan mengelola tagihan berulang (*recurring charges*) serta uji coba gratis (*free trial*) secara otomatis. Aplikasi ini ditujukan bagi siapa saja yang ingin menghindari "penyedotan" saldo akibat lupa membatalkan langganan otomatis (*auto-renewal*) pada layanan streaming, aplikasi SaaS, maupun tagihan digital bulanan lainnya.

---

## 🌟 Fitur Utama

* 🔔 **Automatic Billing Detection (Notification Listener)**
  * Membaca dan menganalisis notifikasi pembayaran dari perbankan atau dompet digital secara lokal untuk mendeteksi transaksi berulang secara otomatis.
* 📷 **OCR Receipt & Invoice Scanner**
  * Ekstraksi tanggal tagihan, nominal, dan nama merchant dari tangkapan layar (*screenshot*) bukti transfer atau kuitansi digital menggunakan Google ML Kit secara *on-device*.
* ⏳ **Smart Expiry & Trial Reminders**
  * Memberikan notifikasi peringatan H-3 dan H-1 sebelum masa *free trial* berakhir atau sebelum tagihan berulang ditarik dari rekening.
* 🗓️ **Visual Renewal Calendar & Burn Rate**
  * Menampilkan kalender jatuh tempo tagihan dan analisis total pengeluaran langganan (*monthly/yearly burn rate*) dalam satu dasbor yang intuitif.
* 🔗 **1-Tap Unsubscribe Shortcuts**
  * Menyediakan tautan navigasi langsung (*deep link*) ke halaman pembatalan langganan di Google Play, App Store, maupun situs resmi merchant.

---

## 🛠️ Tech Stack & Architecture

| Layer | Technology / Tool |
| :--- | :--- |
| **Framework** | Flutter / React Native |
| **Language** | Dart / TypeScript |
| **Local Storage** | SQLite / WatermelonDB (Mengutamakan privasi data finansial di perangkat) |
| **OCR Engine** | Google ML Kit On-Device Vision API |
| **Target Platform** | Android & iOS |

### System Data Flow
