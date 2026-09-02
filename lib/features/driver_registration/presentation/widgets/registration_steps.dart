import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../viewmodels/driver_registration_viewmodel.dart';
import 'document_upload_button.dart';

class StepPersonalDetails extends StatelessWidget {
  const StepPersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    final details = vm.data.personalDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Personal Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        TextFormField(
          initialValue: details.fullName,
          decoration: const InputDecoration(labelText: "Full Name"),
          onChanged: (val) => vm.updatePersonalDetails(details.copyWith(fullName: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.dob,
          decoration: const InputDecoration(labelText: "Date of Birth (DD/MM/YYYY)"),
          onChanged: (val) => vm.updatePersonalDetails(details.copyWith(dob: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.address,
          decoration: const InputDecoration(labelText: "Residential Address"),
          onChanged: (val) => vm.updatePersonalDetails(details.copyWith(address: val)),
        ),
      ],
    );
  }
}

class StepDrivingLicence extends StatelessWidget {
  const StepDrivingLicence({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Driving Licence", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        DocumentUploadButton(
          title: "Driving Licence (Front)",
          document: vm.data.drivingLicenceFront,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('drivingLicenceFront', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('drivingLicenceFront', path);
          },
        ),
        DocumentUploadButton(
          title: "Driving Licence (Back)",
          document: vm.data.drivingLicenceBack,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('drivingLicenceBack', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('drivingLicenceBack', path);
          },
        ),
      ],
    );
  }
}

class StepVehicleDetails extends StatelessWidget {
  const StepVehicleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    final details = vm.data.vehicleDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Vehicle Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        TextFormField(
          initialValue: details.registrationNumber,
          decoration: const InputDecoration(labelText: "Registration Number (e.g. MH01AB1234)"),
          onChanged: (val) => vm.updateVehicleDetails(details.copyWith(registrationNumber: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.make,
          decoration: const InputDecoration(labelText: "Vehicle Make"),
          onChanged: (val) => vm.updateVehicleDetails(details.copyWith(make: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.model,
          decoration: const InputDecoration(labelText: "Vehicle Model"),
          onChanged: (val) => vm.updateVehicleDetails(details.copyWith(model: val)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: details.year,
                decoration: const InputDecoration(labelText: "Year"),
                keyboardType: TextInputType.number,
                onChanged: (val) => vm.updateVehicleDetails(details.copyWith(year: val)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: details.color,
                decoration: const InputDecoration(labelText: "Color"),
                onChanged: (val) => vm.updateVehicleDetails(details.copyWith(color: val)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StepVehicleDocuments extends StatelessWidget {
  const StepVehicleDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Vehicle Documents", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        DocumentUploadButton(
          title: "Registration Certificate (RC)",
          document: vm.data.vehicleRC,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('vehicleRC', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('vehicleRC', path);
          },
        ),
        DocumentUploadButton(
          title: "Vehicle Insurance",
          document: vm.data.vehicleInsurance,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('vehicleInsurance', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('vehicleInsurance', path);
          },
        ),
        DocumentUploadButton(
          title: "Commercial Permit",
          document: vm.data.vehiclePermit,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('vehiclePermit', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('vehiclePermit', path);
          },
        ),
        DocumentUploadButton(
          title: "Fitness Certificate",
          document: vm.data.fitnessCertificate,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('fitnessCertificate', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('fitnessCertificate', path);
          },
        ),
      ],
    );
  }
}

class StepIdentity extends StatelessWidget {
  const StepIdentity({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Identity Verification", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        DocumentUploadButton(
          title: "Aadhaar Card (Front)",
          document: vm.data.aadhaarFront,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('aadhaarFront', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('aadhaarFront', path);
          },
        ),
        DocumentUploadButton(
          title: "Aadhaar Card (Back)",
          document: vm.data.aadhaarBack,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('aadhaarBack', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('aadhaarBack', path);
          },
        ),
        DocumentUploadButton(
          title: "PAN Card",
          document: vm.data.panCard,
          onTakePhoto: () async {
            final path = await vm.takePhoto();
            if (path != null) vm.updateDocument('panCard', path);
          },
          onUploadDocument: () async {
            final path = await vm.pickDocument();
            if (path != null) vm.updateDocument('panCard', path);
          },
        ),
      ],
    );
  }
}

class StepReview extends StatelessWidget {
  const StepReview({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    final data = vm.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Review Application", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildSection("Personal Details", [
          "Name: \${data.personalDetails.fullName}",
          "DOB: \${data.personalDetails.dob}",
        ]),
        _buildSection("Vehicle", [
          "Reg No: \${data.vehicleDetails.registrationNumber}",
          "Make/Model: \${data.vehicleDetails.make} \${data.vehicleDetails.model}",
        ]),
        const Text("Documents Attached:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildDocStatus("Driving Licence", data.drivingLicenceFront.isUploaded && data.drivingLicenceBack.isUploaded),
        _buildDocStatus("Vehicle RC", data.vehicleRC.isUploaded),
        _buildDocStatus("Vehicle Insurance", data.vehicleInsurance.isUploaded),
        _buildDocStatus("Aadhaar", data.aadhaarFront.isUploaded && data.aadhaarBack.isUploaded),
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: PinkAppTheme.primaryPink)),
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
          Icon(isUploaded ? Icons.check_circle : Icons.cancel, 
               color: isUploaded ? PinkAppTheme.success : PinkAppTheme.error, size: 20),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: isUploaded ? Colors.black : Colors.grey)),
        ],
      ),
    );
  }
}
