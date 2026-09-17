import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/driver_registration_viewmodel.dart';
import 'document_upload_button.dart';

class StepVehicleDocuments extends StatelessWidget {
  const StepVehicleDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Vehicle Documents",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
        const Text(
          "Identity Verification",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
