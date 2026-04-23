import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/models/transaction.dart';
import 'package:expense_tracker/data/models/calculation.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> generateReport(List<Transaction> transactions) async {
    final doc = pw.Document();
    final balance = BalanceSummary.fromTransactions(transactions);
    //adds padding to cells
    pw.Widget cell(String text) =>
        pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(text));

    doc.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text('Expense Report', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [

                pw.TableRow(
                  children: [
                    cell('Income'),
                    cell('Expense'),
                    cell('Balance'),
                  ],
                ),

                pw.TableRow(
                  children: [
                    cell(balance.income.toStringAsFixed(2)),
                    cell(balance.expense.toStringAsFixed(2)),
                    cell(balance.total.toStringAsFixed(2)),
                  ],
                ),
                
                // header
                pw.TableRow(
                  children: [
                    cell('Title'),
                    cell('Amount'),
                    cell('Date'),
                  ],
                ),
                // data
                ...transactions.map(
                  (t) => pw.TableRow(
                    children: [
                      cell(t.title),
                      cell('\$${t.amount}'),
                      cell(DateFormat('dd/MM/yyyy').format(t.date)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
}
