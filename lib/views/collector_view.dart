import 'package:collection_report/utils/session.dart';
import 'package:flutter/material.dart';

class CollectorView extends StatefulWidget {
  const CollectorView({Key? key}) : super(key: key);

  @override
  State<CollectorView> createState() => _CollectorViewState();
}

class _CollectorViewState extends State<CollectorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        centerTitle: true,
        title: Text(Session.period.asTitle()),
      ),
      body: FutureBuilder(
        future: Session.load(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final collectors = Session.collectors;

          return GestureDetector(
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
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Column(
                  children: const [
                    Divider(),
                  ],
                );
              },
              itemCount: collectors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text(collectors[index].name),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
