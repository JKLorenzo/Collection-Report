import 'dart:math';

import 'package:collection_report/modals/collector_create_modal.dart';
import 'package:collection_report/modals/collector_info_modal.dart';
import 'package:collection_report/models/collector.dart';
import 'package:collection_report/utils/session.dart';
import 'package:flutter/material.dart';

class CollectorView extends StatefulWidget {
  const CollectorView({Key? key}) : super(key: key);

  @override
  State<CollectorView> createState() => _CollectorViewState();
}

class _CollectorViewState extends State<CollectorView> {
  Future<void> loadSession = Session.load();

  @override
  Widget build(BuildContext context) {
    num total = 0;
    List<Collector> collectors = [];

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => const CollectorCreateModal(),
              );

              if (result == true) {
                setState(() {
                  loadSession = Session.load();
                });
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
        centerTitle: true,
        title: Text(Session.period.asTitle()),
      ),
      body: FutureBuilder(
        future: loadSession,
        builder: (context, snapshot) {
          final isDone = snapshot.connectionState == ConnectionState.done;

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (isDone) {
            collectors = Session.collectors;

            final collections = collectors.map((e) => e.totalCollection());
            if (collections.isNotEmpty) {
              total = collections.reduce((value, element) => element + value);
            }
          }

          return Column(
            children: [
              Expanded(
                child: isDone
                    ? GestureDetector(
                        onHorizontalDragEnd: (details) {
                          const sensitivity = 8;
                          final velocity = details.primaryVelocity ?? 0;

                          if (velocity > sensitivity) {
                            setState(() {
                              loadSession = Session.back();
                            });
                          } else if (velocity < -sensitivity) {
                            setState(() {
                              loadSession = Session.next();
                            });
                          }
                        },
                        child: ReorderableListView.builder(
                          itemCount: collectors.length,
                          onReorder: (oldIndex, newIndex) {
                            if (newIndex > oldIndex) newIndex -= 1;
                            final start = min(oldIndex, newIndex);
                            final end = max(oldIndex, newIndex);

                            setState(() {
                              final task = collectors.removeAt(oldIndex);
                              collectors.insert(newIndex, task);
                            });

                            for (int i = start; i <= end; i++) {
                              collectors[i].updatePosition(i);
                            }
                          },
                          itemBuilder: (context, index) {
                            final collector = collectors[index];

                            return GestureDetector(
                              key: ValueKey(collector),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => CollectorInfoModal(
                                    collector: collector,
                                    onDelete: () {
                                      setState(() {
                                        collectors.removeAt(index);
                                      });

                                      final start =
                                          min(index, collectors.length);
                                      final end = max(index, collectors.length);

                                      for (int i = start; i < end; i++) {
                                        collectors[i].updatePosition(i);
                                      }
                                    },
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: collector.cardView(context),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                color: Colors.green,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Grand Total:'),
                    const SizedBox(width: 5),
                    Text(
                      '$total',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
