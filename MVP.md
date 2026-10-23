# MVP SubCut

Lima user story MVP yang diimplementasikan:

1. **Dashboard pengeluaran** — pengguna melihat burn rate bulanan dan estimasi tahunan dari seluruh langganan aktif. Acceptance criteria: biaya tahunan dikonversi ke bulanan, langganan nonaktif tidak dihitung, dan daftar diurutkan berdasarkan jatuh tempo.
2. **Tambah langganan** — pengguna dapat menyimpan nama, kategori, biaya, siklus, dan tanggal jatuh tempo. Acceptance criteria: nama/kategori wajib diisi, biaya harus angka non-negatif, dan data tersimpan melalui repository lokal.
3. **Edit langganan** — pengguna dapat memperbarui data yang sudah tersimpan. Acceptance criteria: ID tetap sama, nilai terbaru dipersist, dan dashboard memuat ulang setelah kembali.
4. **Hapus langganan** — pengguna dapat menghapus dari dashboard melalui detail. Acceptance criteria: ada konfirmasi dan data menjadi tidak aktif (soft delete), sehingga tidak muncul di daftar aktif maupun burn rate.
5. **Pengingat jatuh tempo** — aplikasi menjadwalkan pengingat H-3 dan H-1 pukul 09.00. Acceptance criteria: hanya jadwal yang belum lewat yang dikirim ke service notifikasi dan kegagalan notifikasi tidak menggagalkan penyimpanan.

Di luar MVP: integrasi bank, pembatalan otomatis, sinkronisasi cloud, dan pembayaran langsung.
