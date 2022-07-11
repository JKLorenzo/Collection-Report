import 'package:collection_report/models/collector.dart';
import 'package:collection_report/utils/session.dart';
import 'package:collection_report/views/collection_view.dart';
import 'package:flutter/material.dart';

class CollectorView extends StatefulWidget {
  const CollectorView({Key? key}) : super(key: key);

  @override
  State<CollectorView> createState() => _CollectorViewState();
}

class _CollectorViewState extends State<CollectorView> {
  @override
  Widget build(BuildContext context) {
    num total = 0;
    List<Collector> collectors = [];

    return Scaffold(
      appBar: AppBar(
        actions: const [],
        centerTitle: true,
        title: Text(Session.period.asTitle()),
      ),
      body: FutureBuilder(
        future: Session.load(),
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
                              Session.back();
                            });
                          } else if (velocity < -sensitivity) {
                            setState(() {
                              Session.next();
                            });
                          }
                        },
                        child: ListView.builder(
                          itemCount: collectors.length,
                          itemBuilder: (context, index) {
                            final collector = collectors[index];
                            final collection = collector.monthly;

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CollectionView(
                                      collection: collection,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: collector.cardView(),
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
