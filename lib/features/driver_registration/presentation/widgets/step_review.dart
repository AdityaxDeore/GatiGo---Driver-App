import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../viewmodels/driver_registration_viewmodel.dart';

class StepReview extends StatelessWidget {
  const StepReview({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    final data = vm.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Review Application",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildSection("Personal Details", [
          "Name: ${data.personalDetails.fullName}",
          "DOB: ${data.personalDetails.dob}",
        ]),
        _buildSection("Vehicle", [
          "Category: ${data.vehicleDetails.type.isNotEmpty ? data.vehicleDetails.type : 'Pink Auto'}",
          "Reg No: ${data.vehicleDetails.registrationNumber}",
          "Make/Model: ${data.vehicleDetails.make} ${data.vehicleDetails.model}",
        ]),
        const Text(
          "Documents Attached:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildDocStatus(
          "Driving Licence",
          data.drivingLicenceFront.isUploaded &&
              data.drivingLicenceBack.isUploaded,
        ),
        _buildDocStatus("Vehicle RC", data.vehicleRC.isUploaded),
        _buildDocStatus("Vehicle Insurance", data.vehicleInsurance.isUploaded),
        _buildDocStatus(
          "Aadhaar",
          data.aadhaarFront.isUploaded && data.aadhaarBack.isUploaded,
        ),
        _buildDocStatus("PAN", data.panCard.isUploaded),
      ],
    );
  }

  Widget _buildSection(String title, List<String> details) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: PinkAppTheme.primaryPink,
            ),
          ),
          const SizedBox(height: 8),
          ...details.map((d) => Text(d)),
        ],
      ),
    );
  }

  Widget _buildDocStatus(String title, bool isUploaded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(
            isUploaded ? Icons.check_circle : Icons.cancel,
            color: isUploaded ? PinkAppTheme.success : PinkAppTheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(color: isUploaded ? Colors.black : Colors.grey),
          ),
        ],
      ),
    );
  }
}
