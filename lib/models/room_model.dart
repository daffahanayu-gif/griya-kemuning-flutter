class PaymentHistory {
  final String bulan;
  final String nama;
  final String nominal;
  final String status;
  final String tglTransfer;

  PaymentHistory({
    required this.bulan,
    required this.nama,
    required this.nominal,
    required this.status,
    required this.tglTransfer,
  });
}

class RoomModel {
  // --- VARIABEL PRIVAT (TAMBAH _) ---
  final String id; // ID tetap final (tidak bisa diubah)
  String _name;
  String _price;
  bool _isAvailable;
  String? _penghuni;
  String? _noHp;
  List<String> _catatanServis;
  List<PaymentHistory> _historyPembayaran;

  // --- CONSTRUCTOR (PARAM BIASA, MASUKKAN KE VARIABEL PRIVAT) ---
  RoomModel({
    required this.id,
    required String name,
    required String price,
    bool isAvailable = true, // default value dipindahkan ke sini
    String? penghuni,
    String? noHp,
    List<String>? catatanServis,
    List<PaymentHistory>? historyPembayaran,
  })  : _name = name,
        _price = price,
        _isAvailable = isAvailable,
        _penghuni = penghuni,
        _noHp = noHp,
        _catatanServis = catatanServis ?? [],
        _historyPembayaran = historyPembayaran ?? [];

  // ===========================================
  //               GETTER (UNTUK BACA DATA)
  // ===========================================
  String get name => _name;
  String get price => _price;
  bool get isAvailable => _isAvailable;
  String? get penghuni => _penghuni;
  String? get noHp => _noHp;
  List<String> get catatanServis => _catatanServis;
  List<PaymentHistory> get historyPembayaran => _historyPembayaran;

  // ===========================================
  //               SETTER (UNTUK UBAH DATA)
  // ===========================================
  set name(String value) => _name = value;
  set price(String value) => _price = value;
  set isAvailable(bool value) => _isAvailable = value;
  set penghuni(String? value) => _penghuni = value;
  set noHp(String? value) => _noHp = value;
  set catatanServis(List<String> value) => _catatanServis = value;
  set historyPembayaran(List<PaymentHistory> value) => _historyPembayaran = value;
}