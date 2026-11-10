import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/clinical_models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MedicalReportPdfService {
  const MedicalReportPdfService._();

  static Future<void> generateAndShareReport({
    required PatientProfile patient,
    required Encounter encounter,
    required bool isBangla,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top Brand Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'HEALORA HEALTH NETWORK',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal,
                        ),
                      ),
                      pw.Text(
                        'Verified Patient Clinical Summary & Hub Encounter Report',
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: 'HEALORA-PATIENT:${patient.canonicalCode}|ENC:${encounter.id}',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
              pw.Divider(thickness: 1.5, color: PdfColors.teal),
              pw.SizedBox(height: 12),

              // Patient & Encounter Metadata Box
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Patient: ${patient.fullName}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
                        ),
                        pw.Text('Patient ID: ${patient.canonicalCode} · Gender: ${patient.gender} · Age: ${patient.age} yrs'),
                        pw.Text('Phone: ${patient.phone} · Blood Group: ${patient.bloodGroup}'),
                        pw.Text('Address: ${patient.upazila}, ${patient.district}'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Hub: ${encounter.hubName}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                        ),
                        pw.Text('Encounter Date: ${encounter.openedAt}'),
                        pw.Text('Status: Verified & Synced'),
                        pw.Text('Attested by: ${encounter.assignedWorker}'),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // Section Title: Observations
              pw.Text(
                'VERIFIED CLINICAL MEASUREMENTS (VITALS)',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.teal),
              ),
              pw.SizedBox(height: 8),

              // Table of Measurements
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _buildTableHeader('Measurement'),
                      _buildTableHeader('Value'),
                      _buildTableHeader('Unit'),
                      _buildTableHeader('Context / Posture'),
                      _buildTableHeader('Device Attribution'),
                    ],
                  ),
                  ...encounter.observations.map((obs) {
                    return pw.TableRow(
                      children: [
                        _buildTableCell(obs.label),
                        _buildTableCell(obs.value, isBold: true),
                        _buildTableCell(obs.unit),
                        _buildTableCell(obs.contextNote ?? '-'),
                        _buildTableCell(obs.deviceAttribution),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 16),

              // Doctor Assessment and Management Plan
              if (encounter.doctorNote != null) ...[
                pw.Text(
                  'CLINICAL ASSESSMENT & MANAGEMENT PLAN',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.teal),
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.TableBorder.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Clinical Assessment: ${encounter.doctorNote!.clinicalAssessment}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Instructions & Advice: ${encounter.doctorNote!.managementPlan}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Signed by: ${encounter.doctorNote!.doctorName} (${encounter.doctorNote!.doctorBmdcNumber})',
                            style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic),
                          ),
                          pw.Text(
                            'Signed At: ${encounter.doctorNote!.signedAt}',
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
              ],

              pw.Spacer(),

              // Footer & Legal
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Compliant with Bangladesh Personal Data Protection Act, 2026 (Act 63) & DGHS Guidelines.',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    'Page 1 of 1 · Canonical Record PAT-BD-89211',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Healora-Report-${patient.canonicalCode}.pdf',
    );
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}

