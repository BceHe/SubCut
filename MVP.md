# MVP SubCut

Dokumen ini adalah scope final demonstrasi. Scope mencakup acceptance criteria di
bawah dan fitur inti tambahan yang tercantum di README: OCR invoice, simulasi
notification listener/parser, serta shortcut pembatalan.

Lima user story MVP yang diimplementasikan:

1. **Dashboard pengeluaran** — pengguna melihat burn rate bulanan dan estimasi tahunan dari seluruh langganan aktif. Acceptance criteria: biaya tahunan dikonversi ke bulanan, langganan nonaktif tidak dihitung, dan daftar diurutkan berdasarkan jatuh tempo.
2. **Tambah langganan** — pengguna dapat menyimpan nama, kategori, biaya, siklus, dan tanggal jatuh tempo. Acceptance criteria: nama/kategori wajib diisi, biaya harus angka non-negatif, dan data tersimpan melalui repository lokal.
3. **Edit langganan** — pengguna dapat memperbarui data yang sudah tersimpan. Acceptance criteria: ID tetap sama, nilai terbaru dipersist, dan dashboard memuat ulang setelah kembali.
4. **Hapus langganan** — pengguna dapat menghapus dari dashboard melalui detail. Acceptance criteria: ada konfirmasi dan data menjadi tidak aktif (soft delete), sehingga tidak muncul di daftar aktif maupun burn rate.
5. **Pengingat jatuh tempo** — aplikasi menjadwalkan pengingat H-3 dan H-1 pukul 09.00. Acceptance criteria: hanya jadwal yang belum lewat yang dikirim ke service notifikasi dan kegagalan notifikasi tidak menggagalkan penyimpanan.

## Fitur inti tambahan

6. **OCR invoice** — pengguna dapat memilih atau memfoto invoice, lalu aplikasi mengekstrak teks dan mengisi kandidat nama merchant, nominal, serta tanggal.
7. **Notification listener/parser (simulasi)** — pengguna dapat memasukkan teks notifikasi transaksi; parser mendeteksi merchant dan nominal untuk dikonfirmasi sebelum disimpan sebagai langganan.
8. **Shortcut pembatalan** — detail langganan menyediakan tautan pembatalan ke halaman merchant atau kanal distribusi yang relevan.

Di luar MVP: integrasi bank, pembatalan otomatis, sinkronisasi cloud, dan pembayaran langsung.
