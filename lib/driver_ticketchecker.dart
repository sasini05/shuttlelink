import 'package:flutter/material.dart';

// Mock model data representing what comes from Firebase Bookings
class SeatBookingInfo {
  final String seatId;
  final String studentName;
  final String route;
  final String ticketPrice;
  final String busNumber;
  final String bookingStatus; // 'Booked' (red), 'Confirmed' (blue)

  SeatBookingInfo({
    required this.seatId,
    required this.studentName,
    required this.route,
    required this.ticketPrice,
    required this.busNumber,
    required this.bookingStatus,
  });
}

class TicketCheckerScreen extends StatefulWidget {
  const TicketCheckerScreen({super.key});

  @override
  State<TicketCheckerScreen> createState() => _TicketCheckerScreenState();
}

class _TicketCheckerScreenState extends State<TicketCheckerScreen> {
  // Mock Active Ride Data (Fetched from Create Ride feature)
  final String _driverId = "Nishan123";
  String _rideDate = "Loading...";
  String _rideTime = "Loading...";
  String _busNumber = "Loading...";
  String _busSeatType = "TypeA"; // Fetched from Bus Registration ('TypeA' or 'TypeB')
  bool _isLoading = true;

  // Real-time Map tracking booked/confirmed seats (seatId -> BookingInfo)
  Map<String, SeatBookingInfo> _rideBookings = {};

  @override
  void initState() {
    super.initState();
    _fetchActiveRideData();
    _listenForRealtimeBookings();
  }

  // STEP 1: Fetch Ride Details (programmatically linking Create Ride to this screen)
  void _fetchActiveRideData() async {
    // Firebase: Listen to /Rides/{driverId}/ where status == 'Active'
    await Future.delayed(const Duration(milliseconds: 750)); // Syncing simulation

    // Mock data based on provided screenshots context
    setState(() {
      _rideDate = "20/03/2026";
      _rideTime = "08:00 AM";
      _busNumber = "MD-2345";
      _busSeatType = "TypeA"; // Assuming Nishan registered a TypeA bus earlier
      _isLoading = false;
    });
  }

  // STEP 2: Handle Real-time syncing. Changes color for driver and student.
  void _listenForRealtimeBookings() {
    // Firebase Database logic:
    // FirebaseDatabase.instance.ref('Bookings/rideId_FromFetchActive/').onValue.listen((event) {
    //   // Update _rideBookings Map based on new snapshots
    // });

    // Mock initial data based on screenshots
    setState(() {
      _rideBookings = {
        'C4': SeatBookingInfo(
          seatId: 'C4',
          studentName: "Erica",
          route: "NSBM-KANDY",
          ticketPrice: "Rs.450.00",
          busNumber: "MD-2345",
          bookingStatus: 'Booked', // RED seat
        ),
        'G4': SeatBookingInfo( // Image 8 G4 Red mock
          seatId: 'G4',
          studentName: "Example Passenger",
          route: "NSBM-GAMPAHA",
          ticketPrice: "Rs.450.00",
          busNumber: "MD-2345",
          bookingStatus: 'Booked', // RED seat
        ),
        'L6': SeatBookingInfo( // Image 7 L6 Red mock
          seatId: 'L6',
          studentName: "Back Row Example",
          route: "NSBM-COLOMBO",
          ticketPrice: "Rs.450.00",
          busNumber: "MD-2345",
          bookingStatus: 'Booked', // RED seat
        ),
      };
    });
  }

  // Programmatic generation of standardized Type A (2+Aisle+2) structure seen in image 7
  List<Widget> _buildTypeAStructure() {
    List<Widget> rows = [];
    final letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];

    for (var letter in letters) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSeatButton("$letter" "1"),
              _buildSeatButton("$letter" "2"),
              const SizedBox(width: 30), // Middle Aisle gap
              _buildSeatButton("$letter" "3"),
              _buildSeatButton("$letter" "4"),
            ],
          ),
        ),
      );
    }
    // Row L (Back row often special, Image 7 shows L1-L6 style weird backend grid)
    rows.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSeatButton("L1"),
            _buildSeatButton("L2"),
            _buildSeatButton("L3"),
            _buildSeatButton("L4"),
            _buildSeatButton("L5"),
            _buildSeatButton("L6"), // Matching specific L6 Red mock in Image 7
          ],
        ),
      ),
    );
    return rows;
  }

  // Programmatic generation of standardized Type B structure style (3+Aisle+2) to demonstrate functionality over image 8
  List<Widget> _buildTypeBStructure() {
    List<Widget> rows = [];
    final letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];

    for (var letter in letters) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSeatButton("$letter" "1"),
              _buildSeatButton("$letter" "2"),
              _buildSeatButton("$letter" "3"),
              const SizedBox(width: 30), // Middle Aisle gap
              _buildSeatButton("$letter" "4"),
              _buildSeatButton("$letter" "5"),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  Widget _buildSeatButton(String seatId) {
    Color seatColor = Colors.teal[800]!; // Available (Hex #0A4339 style)
    final booking = _rideBookings[seatId];

    if (booking != null) {
      if (booking.bookingStatus == 'Booked') {
        seatColor = Colors.red[900]!; // Booked (Hex #B71C1C style)
      } else if (booking.bookingStatus == 'Confirmed') {
        seatColor = Colors.blue[800]!; // Confirmed (Hex #1E88E5 style)
      }
    }

    return GestureDetector(
      onTap: booking != null && booking.bookingStatus == 'Booked' ? () => _showBookingDetailsModal(booking) : null,
      child: Container(
        margin: const EdgeInsets.all(3.0),
        width: 45,
        height: 35,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white24, width: 0.5),
        ),
        alignment: Alignment.center,
        child: Text(
          seatId,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // STEP 3: details modal implementation matching third provided image
  void _showBookingDetailsModal(SeatBookingInfo booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: const Color(0xFFC0C0C0), // matching Grey background from image
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Prominent Seat Display
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.teal[900], // Dark background in circle
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      booking.seatId,
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Details Grid matching layout
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(100.0), // Name column widths
                      1: FlexColumnWidth(),       // Content columns
                    },
                    children: [
                      TableRow(children: [
                        Text(booking.studentName, style: const TextStyle(color: Colors.black)),
                        Text(booking.busNumber, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                      ]),
                      const TableRow(children: [SizedBox(height: 10), SizedBox(height: 10)]), // Spacer row
                      TableRow(children: [
                        Text(booking.route, style: const TextStyle(color: Colors.black)),
                        Text(booking.ticketPrice, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Buttons matching design
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleConfirmBooking(booking.seatId),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF42C79A)), // Confirmed color style
                        child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(), // Just close cancel
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF42C79A)),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // STEP 4: Confirm booking - Seat turns blue for both driver and student end in real-time.
  void _handleConfirmBooking(String seatId) async {
    // Firebase implementation: Update specific booking status to 'Confirmed'
    // FirebaseDatabase.instance.ref('Bookings/rideId/seatId/status').set('Confirmed');

    // MOCK SYNC simulation - Turning specific seat ID BLUE locally.
    setState(() {
      if (_rideBookings.containsKey(seatId)) {
        final existing = _rideBookings[seatId]!;
        _rideBookings[seatId] = SeatBookingInfo(
          seatId: existing.seatId,
          studentName: existing.studentName,
          route: existing.route,
          ticketPrice: existing.ticketPrice,
          busNumber: existing.busNumber,
          bookingStatus: 'Confirmed', // State change to BLUE
        );
      }
    });

    Navigator.of(context).pop(); // Close modal
  }

  // STEP 5: End trip functionality - Seats refresh to green for a new ride created later.
  void _handleEndTrip() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("End Trip?"),
          content: const Text("This will finalize this ride. Seats will reset for the next ride you create."),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  // Firebase implementation: Find Active Ride ID and update status to 'Ended'
                  // FirebaseDatabase.instance.ref('Rides/driverId/activeRide/status').set('Ended');

                  // Return to dashboard
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Confirm")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1111), // matching Dark background from body images
      body: Column(
        children: [
          // Header section (Header background matches Nishan Dashboard theme Hex #0D4B3E context)
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D4B3E), Colors.black26], // matching Dashboard Gradient context
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text('Ticket Checker', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 25),
                // Ride Date/Time details row matching request (Fetched Data)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bus: $_busNumber', style: const TextStyle(color: Colors.white70)),
                    Text('$_rideDate | $_rideTime', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          // Dynamic Seat Structure Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  // Programmatically Choose Layout based on registration data
                  children: _busSeatType == "TypeA" ? _buildTypeAStructure() : _buildTypeBStructure(),
                ),
              ),
            ),
          ),

          // End Trip Button matching third screenshot design style (Cyan color Hex #42C79A style)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: _handleEndTrip,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF42C79A), shape: const StadiumBorder()),
                child: const Text('End Trip', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // matching button text style context
              ),
            ),
          ),
        ],
      ),
    );
  }
}