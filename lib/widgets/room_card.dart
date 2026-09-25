import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../views/admin/roomdetail_page.dart'; 

class RoomCard extends StatefulWidget {
  final RoomModel room;
  final VoidCallback? onStatusChanged;

  const RoomCard({super.key, required this.room, this.onStatusChanged});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A222D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailPage(room: widget.room),
            ),
          ).then((_) {
            // Re-build saat kembali dari halaman detail
            setState(() {});
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambarnya
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/kamarkemuning.jpg.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.king_bed, color: Colors.white54, size: 40),
                      ),
                    ),
                  ),
                  
                  // BADGE / TOMBOL STATUS DI ATAS GAMBAR GRID
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        // Toggle/ubah status langsung saat tombol diklik
                        setState(() {
                          widget.room.isAvailable = !widget.room.isAvailable;
                          if (widget.room.isAvailable) {
                            widget.room.penghuni = null;
                          }
                        });
                        if (widget.onStatusChanged != null) {
                          widget.onStatusChanged!();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.room.isAvailable ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black45, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.room.isAvailable ? Icons.check_circle : Icons.do_not_disturb_on,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.room.isAvailable ? 'Tersedia' : 'Terisi',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Info Kamar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp ${widget.room.price}/bln',
                    style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.room.isAvailable 
                        ? 'Kosong' 
                        : 'Penghuni: ${widget.room.penghuni ?? "Ada"}',
                    style: TextStyle(
                      color: widget.room.isAvailable ? Colors.white38 : Colors.white70,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}