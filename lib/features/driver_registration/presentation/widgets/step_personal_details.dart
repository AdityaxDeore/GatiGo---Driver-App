import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        const Text(
          "Personal Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextFormField(
          initialValue: details.fullName,
          decoration: const InputDecoration(labelText: "Full Name"),
          onChanged: (val) =>
              vm.updatePersonalDetails(details.copyWith(fullName: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.dob,
          decoration:
              const InputDecoration(labelText: "Date of Birth (DD/MM/YYYY)"),
          onChanged: (val) =>
              vm.updatePersonalDetails(details.copyWith(dob: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.address,
          decoration: const InputDecoration(labelText: "Residential Address"),
          onChanged: (val) =>
              vm.updatePersonalDetails(details.copyWith(address: val)),
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
        const Text(
          "Driving Licence",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
