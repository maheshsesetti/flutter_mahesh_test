import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mahesh_test/features/details/bloc/details_bloc.dart';
import 'package:flutter_mahesh_test/features/details/bloc/details_state.dart';
import 'package:flutter_mahesh_test/features/details/repository/details_repo_impl.dart';
import 'package:flutter_mahesh_test/features/details/useCase/details_use_case.dart';

import '../bloc/details_event.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DetailsBloc(FetchDetailsUseCase(DetailsRepoImpl()))
            ..add(LoadDetailsEvent()),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<DetailsBloc, DetailsState>(
            buildWhen: (previous, current) => current is! ErrorState,
            listenWhen: (previous, current) => current is ErrorState,

            builder: (context, state) {
              if (state is DetailsLoadingState) {
                return const CircularProgressIndicator();
              }
              if (state is DetailsLoadedState) return RequestDetailScreen();
              if (state is ErrorState) return Text(state.message);

              return SizedBox();
            },
            listener: (context, state) {
              if (state is ErrorState) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ),
      ),
    );
  }
}



class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      buildWhen: (previous, current) => current is TabSwitchedState || current is DetailsLoadedState,
      builder: (context, state) {
        bool isDetailsSelected = true;
        if (state is DetailsLoadedState) {
          isDetailsSelected = state.isDetailsSelected;
        }
        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/seed/picsum/200/300',
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: 30,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DetailsButton(
                        label: "Details",
                        isSelected: isDetailsSelected,
                        onTap: () => context.read<DetailsBloc>().add(SwitchTabEvent(true)),
                      ),
                      SizedBox(width: 12),
                      DetailsButton(
                        label: 'History',
                        isSelected: !isDetailsSelected,
                        onTap: () => context.read<DetailsBloc>().add(SwitchTabEvent(false)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: isDetailsSelected ? RequestDetailsTab() : RequestHistoryTab(),
            ),
          ],
        );
      },
    );
  }
}

class DetailsButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String label;

  const DetailsButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    const double triangleHeight = 10.0;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              margin: const EdgeInsets.only(bottom: triangleHeight),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.black, width: 0.5),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                bottom: 0,
                child: CustomPaint(
                  size: const Size(20, triangleHeight),
                  painter: CustomStyleArrow(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RequestDetailsTab extends StatelessWidget {
  const RequestDetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Crest",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14),
                        SizedBox(width: 4),
                        Text("1 Dec 2023 "),
                      ],
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(Icons.av_timer_outlined, size: 14),
                        SizedBox(width: 4),
                        Text("13:45"),
                      ],
                    ),

                    SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.red, size: 12),
                        Text(" Rejected", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Request Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    detailRow("Floor", "A - P4"),
                    detailRow("Unit", "A0402"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    detailRow("Division", "Finishing Division"),
                    detailRow("Sub Division", "Tile Division"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    detailRow("Activity", "Dry Area Floor"),
                    detailRow("Sub Activity", "Floor Tiling"),
                  ],
                ),
                Divider(),
                detailRow("Technician", "Akshay Jadhav"),
                Divider(),
                detailRow("Remarks", "None"),

                SizedBox(height: 16),

                documentViewTile("CL Document"),
                documentViewTile("WIR Document"),

                SizedBox(height: 20),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Submit Rework",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

Widget documentViewTile(String docName) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(docName),
        Row(
          children: [
            TextButton(onPressed: () {}, child: Text("View")),
            Icon(Icons.remove_red_eye_outlined),
          ],
        ),
      ],
    ),
  );
}

class RequestHistoryTab extends StatelessWidget {
  const RequestHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        historyCard(
          name: "Ankita Bhat",
          role: "Engineer",
          date: "1 Dec 2023",
          time: "13:45",
          comment: "Request for Approval to @Vikas",

          isViewImage: false,
        ),
        historyCard(
          name: "Vikas Gupta",
          role: "QCS",
          date: "2 Dec 2023",
          time: "14:35",
          comment: "Inspection Approved and Closed",

          isViewImage: true,
        ),
      ],
    );
  }

  Widget historyCard({
    required String name,
    required String role,
    required String date,
    required String time,
    required String comment,

    required bool isViewImage,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 25,
                  child: Icon(Icons.person_sharp, size: 30),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Approver - $role",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14),
                SizedBox(width: 4),
                Text(date),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 14),
                SizedBox(width: 4),
                Text(time),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "Comment",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(comment, style: TextStyle(color: Colors.grey.shade500)),

            SizedBox(height: 8),
            isViewImage == false ? SizedBox() : documentViewTile("View Image"),
            isViewImage == false ? SizedBox() : documentViewTile("View Image"),
          ],
        ),
      ),
    );
  }
}

class CustomStyleArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    const double triangleHeight = 10;
    const double triangleWidth = 25;

    final double width = size.width;
    final double height = size.height;

    // Bubble area (excluding triangle height)
    final double bubbleHeight = height - triangleHeight;

    // Rounded rectangle
    final RRect bubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, bubbleHeight),
      const Radius.circular(15),
    );
    canvas.drawRRect(bubble, paint);

    // Triangle
    final Path trianglePath = Path()
      ..moveTo(width / 2 - triangleWidth / 2, bubbleHeight)
      ..lineTo(width / 2, bubbleHeight + triangleHeight)
      ..lineTo(width / 2 + triangleWidth / 2, bubbleHeight)
      ..close();
    canvas.drawPath(trianglePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
