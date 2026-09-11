#  SubCut

> **Smart Subscription Tracker & Automated Recurring Expense Manager**

---

##  Deskripsi Masalah

Perkembangan layanan digital berbasis langganan (*subscription-based models*) seperti platform *streaming*, aplikasi *SaaS*, *cloud storage*, hingga keanggotaan *gym* menyebabkan fenomena **"Subscription Fatigue"** dan **"Subscription Drift"**. 

Banyak pengguna tidak menyadari akumulasi biaya kecil yang ditarik secara berkala dari rekening atau dompet digital mereka. Masalah utama yang dihadapi meliputi:
* Lupa membatalkan masa uji coba gratis (*free trial*) sebelum otomatis berubah menjadi langganan berbayar.
* Kesulitan melacak tanggal jatuh tempo dari berbagai layanan yang terpisah-pisah.
* Ketidakjelasan total akumulasi pengeluaran bulanan/tahunan untuk seluruh layanan berbayar.

---

##  Profil Target Pengguna

* **Demografi:** Mahasiswa, pekerja profesional, dan pengguna aktif ekosistem digital usia 18–35 tahun.
* **Karakteristik:** 
  * Menggunakan lebih dari 2 layanan berlangganan digital secara aktif.
  * Sering bertransaksi menggunakan dompet digital (GoPay, OVO, ShopeePay) atau perbankan digital.
  * Menginginkan fleksibilitas dalam mengelola keuangan pribadi tanpa harus membagikan kredensial login bank ke aplikasi pihak ketiga.

---

##  Manfaat Aplikasi

1. **Mencegah Kerugian Finansial Pasif:** Membantu pengguna membatalkan uji coba gratis atau layanan yang tidak dipakai sebelum saldo terpotong otomatis.
2. **Visibilitas Pengeluaran:** Memberikan gambaran transparan mengenai total pengeluaran langganan bulanan maupun tahunan.
3. **Efisiensi Waktu & Privasi:** Melacak tagihan secara otomatis melalui notifikasi perangkat dan OCR lokal (*on-device*) tanpa mengompromikan keamanan data perbankan.

---

##  Daftar Fitur Inti (Target 12 Pertemuan)

Fitur-fitur ini dirancang secara realistis untuk diselesaikan dalam durasi proyek 12 pertemuan:

1. **Dashboard Ringkasan & Burn Rate**
   * Menampilkan total estimasi pengeluaran langganan bulanan dan tahunan.
   * Daftar kartu langganan aktif yang diurutkan berdasarkan tanggal jatuh tempo terdekat.
2. **Manajemen Data Langganan (CRUD Manual)**
   * Menambah, mengedit, dan menghapus entitas langganan (nama, biaya, siklus tagihan, kategori, dan tanggal jatuh tempo).
3. **Simulasi/Pencatatan Otomatis via Notification Listener**
   * Membaca dan menganalisis teks notifikasi transaksi bank/E-Wallet untuk mendeteksi transaksi berulang secara otomatis.
4. **Peringatan & Notifikasi Lokal (Local Scheduled Alerts)**
   * Mengirim notifikasi pengingat ke perangkat pada H-3 dan H-1 sebelum tanggal jatuh tempo atau masa uji coba berakhir.
5. **OCR Struk / Invoice Scanner (On-Device ML Kit)**
   * Mengunggah atau memfoto kuitansi digital untuk mengekstrak nama merchant, nominal, dan tanggal secara otomatis.
6. **Simulasi Pembatalan (1-Tap Shortcut)**
   * Tombol pintas (*deep link*) yang mengarahkan pengguna ke halaman pembatalan langganan di Google Play / App Store / situs resmi merchant.

---

##  Fitur yang Tidak Dikerjakan (Out of Scope)

Untuk memastikan proyek selesai tepat waktu dalam 12 pertemuan, fitur-fitur berikut **tidak dimasukkan** ke dalam ruang lingkup pengerjaan:

* ❌ **Integrasi Langsung Open Banking / API Perbankan Asli:** Tidak menggunakan koneksi API bank riil (seperti Plaid/Layanan Agregator Bank) demi menghindari kompleksitas regulasi dan biaya API.
* ❌ **Fitur Pembatalan Otomatis dari Dalam Aplikasi:** Aplikasi tidak bisa membatalkan langganan secara langsung atas nama pengguna; aplikasi hanya menyediakan pintas/tautan navigasi.
* ❌ **Sistem Akun Multi-Device Cloud Sync:** Data tersimpan secara lokal di perangkat (*local storage*); tidak menggunakan autentikasi server backend berbasis cloud.
* ❌ **Pembayaran Tagihan Langsung di Aplikasi:** Aplikasi tidak berfungsi sebagai *payment gateway* untuk membayar tagihan langganan.

---

##  Kriteria Aplikasi Dinyatakan Berhasil

Aplikasi dinyatakan berhasil memenuhi standar proyek jika:

1. **Akurasi OCR & Parser:** Fitur scan OCR dan *notification parser* mampu mengekstrak nama merchant dan nominal biaya dengan tingkat keberhasilan minimal 85% pada pengujian sampel.
2. **Pencatatan Database Lokal:** Data langganan yang ditambahkan (baik manual maupun otomatis) tersimpan dengan aman di database lokal (SQLite) tanpa hilang saat aplikasi ditutup.
3. **Ketepatan Notifikasi Pengingat:** Sistem berhasil memicu notifikasi lokal sesuai jadwal (H-3 dan H-1) pada Android Simulator maupun perangkat fisik.
4. **Perhitungan Otomatis:** Akumulasi *monthly burn rate* di dashboard menghitung total biaya dari seluruh langganan aktif secara akurat.
5. **Kestabilan Aplikasi:** Aplikasi berjalan lancar tanpa mengalami *crash* saat menjalankan skenario utama (*User Acceptance Testing*).

---

##  Tech Stack & Environment

* **Framework:** Flutter (Dart)
* **Penyimpanan Lokal:** SQLite / Hive
* **OCR Engine:** Google ML Kit Text Recognition
* **Testing & Emulator:** Android Studio (Android SDK)
