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
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Date of Birth (DD/MM/YYYY)",
            suffixIcon: Icon(Icons.calendar_today_outlined),
          ),
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: _parseDate(details.dob) ?? DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              final formattedDate = '${selectedDate.day.toString().padLeft(2, '0')}/'
                  '${selectedDate.month.toString().padLeft(2, '0')}/'
                  '${selectedDate.year}';
              vm.updatePersonalDetails(details.copyWith(dob: formattedDate));
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.address,
          decoration: const InputDecoration(labelText: "Residential Address"),
          onChanged: (val) =>
              vm.updatePersonalDetails(details.copyWith(address: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.licenseNumber,
          decoration: const InputDecoration(labelText: "Driving Licence Number"),
          textCapitalization: TextCapitalization.characters,
          onChanged: (val) => vm.updatePersonalDetails(details.copyWith(licenseNumber: val.toUpperCase())),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: details.gender.isEmpty ? null : details.gender,
          decoration: const InputDecoration(labelText: "Gender"),
          items: const ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
          onChanged: (gender) => vm.updatePersonalDetails(details.copyWith(gender: gender)),
        ),
      ],
    );
  }

  static DateTime? _parseDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;
    return DateTime.tryParse('${parts[2]}-${parts[1]}-${parts[0]}');
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
