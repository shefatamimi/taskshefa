import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:task_shefa/task/task_model/task_model.dart';

Future<void> generatePdf(List<TaskModel> tasks) async {
  final pdf = pw.Document();// انشاء ملف فارغ

  pdf.addPage(// اضاف
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Exported Tasks",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
                decoration: pw.TextDecoration.underline,
                decorationStyle: pw.TextDecorationStyle.double,
                decorationColor: PdfColors.blue,
              ),
            ),

            pw.SizedBox(height: 20),

            ...tasks.map((task) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Title: ${task.title}",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                 pw.SizedBox(height: 5),
                    pw.Text(
                      "Description: ${task.description}",
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "Due Date: ${task.dueDate.day}",
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "Priority: ${task.priority}",
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "Status: ${task.isCompleted ? "Completed" : "Incomplete"}",
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "Alert: ${task.alert}",
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.SizedBox(height: 5),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    ),
  );

  // 📁 مكان الحفظ
  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/tasks_export.pdf");

  // 💾 حفظ الملف
  await file.writeAsBytes(await pdf.save());

  print("PDF Saved at: ${file.path}");

  // 📂 فتح الملف
  final result = await OpenFile.open(file.path);

  print("Open result: ${result.message}");
}