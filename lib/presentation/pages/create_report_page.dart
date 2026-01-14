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
  double? _latitude;
  double? _longitude;
  String? _aiSuggestion;
  bool _isDraft = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Report")),
      body: BlocListener<FormBloc, f_state.FormState>(
        listener: (context, state) {
          if (state is f_state.SuggestionLoaded) {
            setState(() {
              _aiSuggestion = state.suggestion;
            });
          } else if (state is f_state.LocationLoaded) {
            setState(() {
              _latitude = state.latitude;
              _longitude = state.longitude;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location Acquired")));
          } else if (state is f_state.FormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Report Saved!")));
            context.read<ReportBloc>().add(LoadReports());
            context.pop();
          } else if (state is f_state.FormFailure) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                onChanged: (value) {
                  if (value.length > 10) {
                     // Debounce could be added here
                     context.read<FormBloc>().add(SuggestionRequested(value));
                  }
                },
              ),
              const SizedBox(height: 10),
              if (_aiSuggestion != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.blue.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(child: Text("AI Suggestion: $_aiSuggestion")),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(_latitude != null
                      ? "Loc: $_latitude, $_longitude"
                      : "Location not set"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<FormBloc>().add(LocationRequested());
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text("Get Location"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text("Save as Draft (Local Only)"),
                value: _isDraft,
                onChanged: (val) {
                  setState(() {
                    _isDraft = val;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty || _descController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
                    return;
                  }
                  if (_latitude == null) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please get location")));
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
                },
                child: const Text("Submit Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
