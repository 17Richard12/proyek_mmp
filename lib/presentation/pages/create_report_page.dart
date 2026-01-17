import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:city_care/domain/entities/report.dart';
import 'package:city_care/presentation/bloc/form/form_bloc.dart';
import 'package:city_care/presentation/bloc/form/form_event.dart';
import 'package:city_care/presentation/bloc/form/form_state.dart' as f_state;
import 'package:city_care/presentation/bloc/report/report_bloc.dart';
import 'package:city_care/presentation/bloc/report/report_event.dart';
import 'package:uuid/uuid.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double? _latitude;
  double? _longitude;
  String? _aiSuggestion;
  bool _isDraft = false;
  bool _isLoadingSuggestion = false;
  Timer? _debounce;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  bool get _isFormValid {
    return _titleController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _latitude != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[700],
        title: const Text(
          "Buat Laporan Baru",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(context),
        ),
      ),
      body: BlocListener<FormBloc, f_state.FormState>(
        listener: (context, state) {
          if (state is f_state.SuggestionLoaded) {
            setState(() {
              _aiSuggestion = state.suggestion;
              _isLoadingSuggestion = false;
            });
          } else if (state is f_state.LocationLoaded) {
            setState(() {
              _latitude = state.latitude;
              _longitude = state.longitude;
            });
            _showSuccessSnackBar(context, "Lokasi berhasil didapatkan!");
          } else if (state is f_state.FormSuccess) {
            _showSuccessSnackBar(context, "Laporan berhasil disimpan!");
            context.read<ReportBloc>().add(LoadReports());
            context.pop();
          } else if (state is f_state.FormFailure) {
            _showErrorSnackBar(context, state.message);
          }
        },
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      _buildHeaderSection(),
                      const SizedBox(height: 24),

                      // Title Field
                      _buildSectionTitle("Judul Laporan", Icons.title, true),
                      const SizedBox(height: 8),
                      _buildTitleField(),
                      const SizedBox(height: 24),

                      // Description Field
                      _buildSectionTitle("Deskripsi", Icons.description, true),
                      const SizedBox(height: 8),
                      _buildDescriptionField(),
                      const SizedBox(height: 12),

                      // AI Suggestion Box
                      _buildAISuggestionBox(),
                      const SizedBox(height: 24),

                      // Location Section
                      _buildSectionTitle("Lokasi", Icons.location_on, true),
                      const SizedBox(height: 8),
                      _buildLocationCard(),
                      const SizedBox(height: 24),

                      // Draft Toggle
                      _buildDraftToggle(),
                      const SizedBox(height: 32),

                      // Submit Button
                      _buildSubmitButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    int completedSteps = 0;
    if (_titleController.text.isNotEmpty) completedSteps++;
    if (_descController.text.isNotEmpty) completedSteps++;
    if (_latitude != null) completedSteps++;

    double progress = completedSteps / 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress: $completedSteps/3",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.edit_document,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Laporkan Masalah",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Bantu tingkatkan kualitas kota kita",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isRequired) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            "*",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ],
      ],
    );
  }

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: "Contoh: Jalan berlubang di depan sekolah",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.edit, color: Colors.blue[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (value) => setState(() {}),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Judul tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _descController,
        decoration: InputDecoration(
          hintText: "Jelaskan masalah secara detail...",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Icon(Icons.notes, color: Colors.blue[700]),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          alignLabelWithHint: true,
        ),
        maxLines: 5,
        onChanged: (value) {
          setState(() {});

          if (_debounce?.isActive ?? false) _debounce!.cancel();

          _debounce = Timer(const Duration(milliseconds: 1000), () {
            if (value.length > 10) {
              setState(() {
                _isLoadingSuggestion = true;
              });
              context.read<FormBloc>().add(SuggestionRequested(value));
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Deskripsi tidak boleh kosong';
          }
          if (value.length < 10) {
            return 'Deskripsi minimal 10 karakter';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAISuggestionBox() {
    if (_isLoadingSuggestion) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "AI sedang menganalisis...",
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    if (_aiSuggestion != null && _aiSuggestion!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber[50]!, Colors.orange[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Saran dari AI",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _aiSuggestion!,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[800],
                height: 1.5,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      _latitude != null ? Colors.green[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _latitude != null ? Icons.location_on : Icons.location_off,
                  color:
                      _latitude != null ? Colors.green[700] : Colors.grey[400],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _latitude != null
                          ? "Lokasi Terpilih"
                          : "Lokasi Belum Dipilih",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _latitude != null
                          ? "${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}"
                          : "Tekan tombol untuk mendapatkan lokasi",
                      style: TextStyle(
                        color: _latitude != null
                            ? Colors.grey[700]
                            : Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<FormBloc, f_state.FormState>(
            builder: (context, state) {
              bool isLoading = state is f_state.FormLoading;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<FormBloc>().add(LocationRequested());
                        },
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(isLoading
                      ? "Mengambil Lokasi..."
                      : "Dapatkan Lokasi Saya"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDraftToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDraft ? Colors.orange[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDraft
              ? Colors.orange.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isDraft ? Colors.orange[100] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.drafts,
              color: _isDraft ? Colors.orange[700] : Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Simpan sebagai Draft",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Draft hanya tersimpan lokal di perangkat Anda",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isDraft,
            onChanged: (val) {
              setState(() {
                _isDraft = val;
              });
            },
            activeColor: Colors.orange[700],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<FormBloc, f_state.FormState>(
      builder: (context, state) {
        bool isLoading = state is f_state.FormLoading;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isFormValid && !isLoading
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid && !isLoading
                  ? Colors.blue[700]
                  : Colors.grey[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: _isFormValid && !isLoading ? _submitForm : null,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isDraft ? Icons.save : Icons.send, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isDraft ? "Simpan Draft" : "Kirim Laporan",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_latitude == null) {
      _showErrorSnackBar(context, "Mohon dapatkan lokasi terlebih dahulu");
      return;
    }

    final report = Report(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descController.text,
      latitude: _latitude!,
      longitude: _longitude!,
      status: 'pending',
      isDraft: _isDraft,
      aiSuggestion: _aiSuggestion,
      createdAt: DateTime.now(),
    );
    context.read<FormBloc>().add(SubmitReport(report));
  }

  void _showExitDialog(BuildContext context) {
    if (_titleController.text.isEmpty && _descController.text.isEmpty) {
      context.pop();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 12),
              Text("Konfirmasi Keluar"),
            ],
          ),
          content: const Text(
            "Anda memiliki perubahan yang belum disimpan. Yakin ingin keluar?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Keluar"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
