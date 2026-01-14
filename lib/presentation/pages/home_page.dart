import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:city_care/presentation/bloc/report/report_bloc.dart';
import 'package:city_care/presentation/bloc/report/report_event.dart';
import 'package:city_care/presentation/bloc/report/report_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(LoadReports());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CityCare Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportLoaded) {
            if (state.reports.isEmpty && state.drafts.isEmpty) {
              return const Center(child: Text("No reports yet. Create one!"));
            }
            return RefreshIndicator(
              onRefresh: () async {
                 context.read<ReportBloc>().add(LoadReports());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.drafts.isNotEmpty) ...[
                       const Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text("Drafts (Local)", style: TextStyle(fontWeight: FontWeight.bold)),
                       ),
                       ...state.drafts.map((report) => ListTile(
                         leading: const Icon(Icons.drafts),
                         title: Text(report.title),
                         subtitle: Text(report.description),
                         onTap: () => context.push('/detail', extra: report),
                       )),
                       const Divider(),
                    ],
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Public Reports (Cloud)", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.reports.length,
                      itemBuilder: (context, index) {
                        final report = state.reports[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.report_problem, color: Colors.red),
                            title: Text(report.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(report.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                if (report.aiSuggestion != null)
                                  Text("AI Suggestion: ${report.aiSuggestion}", style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
                              ],
                            ),
                            trailing: Text(report.status),
                            onTap: () => context.push('/detail', extra: report),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ReportError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Welcome'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
