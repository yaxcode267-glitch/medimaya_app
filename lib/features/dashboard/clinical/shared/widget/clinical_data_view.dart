import 'package:flutter/material.dart';

import '../model/clinical_section.dart';

class ClinicalDataView extends StatefulWidget {
  const ClinicalDataView({
    super.key,
    required this.sections,
    required this.builder,
  });
  final List<ClinicalSection> sections;
  final WidgetBuilder builder;
  @override
  State<ClinicalDataView> createState() => _ClinicalDataViewState();
}

class _ClinicalDataViewState extends State<ClinicalDataView> {
  late Future<void> _loading;
  @override
  void initState() {
    super.initState();
    _loading = Future.wait(widget.sections.map((section) => section.load()));
  }

  @override
  void didUpdateWidget(ClinicalDataView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sections.length != widget.sections.length ||
        !oldWidget.sections.every(widget.sections.contains)) {
      _loading = Future.wait(widget.sections.map((section) => section.load()));
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _loading,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No se pudo cargar la información de Clínica.'),
              TextButton(
                onPressed: () => setState(() {
                  _loading = Future.wait(
                    widget.sections.map((section) => section.reload()),
                  );
                }),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );
      }
      return widget.builder(context);
    },
  );
}
