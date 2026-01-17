import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:city_care/data/models/report_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveReport(ReportModel report) async {
    await _firestore.collection('reports').doc(report.id).set(report.toJson());
  }

  Future<List<ReportModel>> getReports() async {
    // Tambahkan .limit(20)
    final snapshot = await _firestore
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => ReportModel.fromJson(doc.data()))
        .toList();
  }
}
