1. Dashboard
1.1 Informasi Konteks Akademik

Tampilkan Tahun Akademik aktif dan Semester aktif secara prominently di bagian atas dashboard (misalnya dalam bentuk info card atau badge).
Sertakan indikator "Semester Berjalan" yang menunjukkan sisa waktu atau status semester aktif (misalnya: "Semester Genap 2024/2025 — sedang berjalan"). Data ini diambil langsung dari tabel semester di database.
Jika belum ada semester aktif yang terdefinisi, tampilkan pesan peringatan yang jelas agar admin segera mengaturnya.


2. Form Input
2.1 Validasi
    Semua field yang bersifat krusial/wajib harus menggunakan validasi required.
    Form tidak boleh bisa di-submit apabila ada field wajib yang masih kosong — tampilkan pesan error yang informatif di dekat field yang bermasalah.
    Field Tahun Akademik dan Semester wajib disertakan di setiap form transaksi/penugasan dan harus tervalidasi.

2.2 Kategorisasi Tipe Pekerjaan
    Berikan perbedaan visual yang jelas antara tipe penugasan Internal dan Eksternal, misalnya menggunakan:

    Badge/label berwarna berbeda (contoh: biru untuk Internal, oranye untuk Eksternal).
    Ikon yang berbeda.


    Perbedaan ini harus konsisten di form input, list data, maupun detail view.


3. List Data & Penomoran
    3.1 Penomoran

    Semua tampilan list/tabel wajib memiliki kolom nomor urut yang jelas (No. 1, 2, 3, dst.).

    3.2 Data Master

    Ditampilkan dalam bentuk list/tabel standar dengan penomoran.
    Tidak memerlukan fitur filter — cukup tampilkan semua data.

    3.3 Data Transaksi & Penugasan
    Wajib memiliki Filter Tahun Akademik untuk memisahkan data aktif dari data histori.
    Wajib memiliki Filter Semester — pilihan semester diambil dinamis dari tabel semester di database (bukan di-hardcode).
    Wajib memiliki fitur Search untuk pencarian berdasarkan nama, kode, atau atribut relevan lainnya.
    Tambahkan kolom Semester pada tabel penugasan, sehingga setiap record penugasan jelas tercatat di semester mana ia dibuat.


4. Sistem Histori & Akumulasi Kompensasi
    Sistem harus mampu menampilkan histori kompensasi dari semester-semester sebelumnya, bukan hanya semester aktif.
    Histori dapat diakses melalui kombinasi Filter Tahun Akademik + Filter Semester.
    Kolom semester pada tabel penugasan menjadi kunci utama untuk melacak dan mengelompokkan data histori.
    Data histori dan data aktif menggunakan tampilan/tabel yang sama, dibedakan hanya melalui filter — tidak perlu halaman terpisah.


5. Catatan Teknis & Implementasi
    AspekKetentuanSumber data semesterSelalu ambil dari tabel semester di database, jangan di-hardcodeSemester aktif 
    Ditentukan berdasarkan flag/status aktif di tabel semesterFilter defaultSaat halaman pertama dibuka, filter otomatis mengarah ke Tahun Akademik & Semester yang sedang aktifKonsistensi UIBadge tipe pekerjaan (Internal/Eksternal) konsisten di semua tampilanPesan kosongJika tidak ada data untuk filter yang dipilih, tampilkan pesan "Tidak ada data untuk periode ini"