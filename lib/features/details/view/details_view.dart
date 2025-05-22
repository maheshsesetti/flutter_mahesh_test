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
      create: (_) => DetailsBloc(FetchDetailsUseCase(DetailsRepoImpl()))..add(LoadDetailsEvent()),
        child: Scaffold(
          body: SafeArea(
            child: BlocConsumer< DetailsBloc,DetailsState>(
              buildWhen: (previous, current) =>
                  current is! ErrorState, 
              listenWhen: (previous, current) =>
                  current is ErrorState, 
        
              builder: (context, state) {
                if(state is DetailsLoadingState) return CircularProgressIndicator();
                if(state is DetailsLoadedState) return RequestDetailScreen();
                if(state is ErrorState) return Text(state.message);
        
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
        )
      
    );
  }
}

class RequestDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top image and tabs
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,

                    child: FlutterLogo()),
                  // Image.asset(
                  //   'assets/building.jpg',
                  //   height: 200,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  // ),
                  Positioned(
                    top: 16,
                    left: 8,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TabBar(
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Details"),
                        Tab(text: "History"),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                     RequestDetailsTab(),
                     RequestHistoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
       
      ),
    );
  }
}

class RequestDetailsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Crest", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14),
                  SizedBox(width: 4),
                  Text("1 Dec 2023  | 13:45"),
                  SizedBox(width: 8),
                  Icon(Icons.circle, color: Colors.red, size: 12),
                  Text(" Rejected", style: TextStyle(color: Colors.red)),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),

          // Details Section
          detailRow("Floor", "A - P4"),
          detailRow("Unit", "A0402"),
          detailRow("Division", "Finishing Division"),
          detailRow("Sub Division", "Tile Division"),
          detailRow("Activity", "Dry Area Floor"),
          detailRow("Sub Activity", "Floor Tiling"),
          detailRow("Technician", "Akshay Jadhav"),
          detailRow("Remarks", "None"),

          SizedBox(height: 16),

          // Documents
          documentViewTile("CL Document"),
          documentViewTile("WIR Document"),

          SizedBox(height: 20),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[200],
              ),
              onPressed: () {
                // Handle rework submit
              },
              child: Text("Submit Rework", style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget documentViewTile(String docName) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(docName),
      trailing: TextButton(
        onPressed: () {
          // View document logic
        },
        child: Text("View"),
      ),
    );
  }
}


class RequestHistoryTab extends StatelessWidget {
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
          imageUrl: 'assets/user1.png',
        ),
        historyCard(
          name: "Vikas Gupta",
          role: "QCS",
          date: "2 Dec 2023",
          time: "14:35",
          comment: "Inspection Approved and Closed",
          imageUrl: 'assets/user2.png',
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
    required String imageUrl,
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
                CircleAvatar(backgroundImage: AssetImage(imageUrl)),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Approver - $role"),
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
            SizedBox(height: 8),
            Text("Comment"),
            Text(comment, style: TextStyle(color: Colors.grey[800])),

            SizedBox(height: 8),
            documentViewTile(),
            documentViewTile(),
          ],
        ),
      ),
    );
  }

  Widget documentViewTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text("View Image"),
      trailing: Icon(Icons.remove_red_eye),
      onTap: () {
        // View image logic
      },
    );
  }
}



