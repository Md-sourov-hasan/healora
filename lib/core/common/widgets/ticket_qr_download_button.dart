import 'package:flutter/material.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TicketQrDownloadButton extends StatelessWidget {
  final QueueTicket ticket;
  final String hubName;
  final bool isBangla;
  final bool compact;

  const TicketQrDownloadButton({
    super.key,
    required this.ticket,
    required this.hubName,
    required this.isBangla,
    this.compact = false,
  });

  Future<void> _download(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final document = pw.Document();
      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a6,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'HEALORA HUB VISIT',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(hubName, textAlign: pw.TextAlign.center),
                pw.SizedBox(height: 18),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: 'HEALORA-TICKET:${ticket.tokenNumber}',
                  width: 150,
                  height: 150,
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  ticket.tokenNumber,
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  ticket.currentStationName,
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 4),
                pw.Text('Status: ${ticket.statusLabel}'),
                pw.SizedBox(height: 12),
                pw.Text(
                  'Show this QR ticket to hub staff. It contains no patient name or clinical data.',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
        ),
      );

      final safeToken = ticket.tokenNumber.toLowerCase().replaceAll(
        RegExp(r'[^a-z0-9-]'),
        '-',
      );
      await Printing.sharePdf(
        bytes: await document.save(),
        filename: 'healora-ticket-$safeToken.pdf',
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            isBangla
                ? 'টিকিট PDF তৈরি করা যায়নি। আবার চেষ্টা করুন।'
                : 'Could not create the ticket PDF. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton(
        tooltip: isBangla ? 'QR টিকিট ডাউনলোড' : 'Download QR ticket',
        onPressed: () => _download(context),
        icon: const Icon(Icons.qr_code_2_outlined),
        color: HealoraColors.teal,
      );
    }

    return OutlinedButton.icon(
      onPressed: () => _download(context),
      icon: const Icon(Icons.download_outlined, size: 18),
      label: Text(
        isBangla ? 'QR টিকিট ডাউনলোড' : 'Download QR ticket',
        style: HealoraTypography.bodySmall(isBangla: isBangla),
      ),
    );
  }
}
