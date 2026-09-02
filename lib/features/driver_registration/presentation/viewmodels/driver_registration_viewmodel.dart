import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/driver_registration_model.dart';

class DriverRegistrationViewModel extends ChangeNotifier {
  int _currentStep = 0;
  final int totalSteps = 6;
  
  DriverRegistrationData _data = DriverRegistrationData();
  final ImagePicker _imagePicker = ImagePicker();

  int get currentStep => _currentStep;
  DriverRegistrationData get data => _data;

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void updatePersonalDetails(PersonalDetails details) {
    _data = _data.copyWith(personalDetails: details);
    notifyListeners();
  }

  void updateVehicleDetails(VehicleDetails details) {
    _data = _data.copyWith(vehicleDetails: details);
    notifyListeners();
  }

  Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
      return photo?.path;
    } catch (e) {
      debugPrint("Error taking photo: \$e");
      return null;
    }
  }

  Future<String?> pickDocument() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.gallery);
      return photo?.path;
    } catch (e) {
      debugPrint("Error picking document: \$e");
      return null;
    }
  }

  void updateDocument(String docKey, String filePath) {
    final docField = DocumentField(filePath: filePath, status: DocumentStatus.uploaded);
    
    switch (docKey) {
      case 'drivingLicenceFront':
        _data = _data.copyWith(drivingLicenceFront: docField);
        break;
      case 'drivingLicenceBack':
        _data = _data.copyWith(drivingLicenceBack: docField);
        break;
      case 'vehicleRC':
        _data = _data.copyWith(vehicleRC: docField);
        break;
      case 'vehicleInsurance':
        _data = _data.copyWith(vehicleInsurance: docField);
        break;
      case 'vehiclePermit':
        _data = _data.copyWith(vehiclePermit: docField);
        break;
      case 'fitnessCertificate':
        _data = _data.copyWith(fitnessCertificate: docField);
        break;
      case 'aadhaarFront':
        _data = _data.copyWith(aadhaarFront: docField);
        break;
      case 'aadhaarBack':
        _data = _data.copyWith(aadhaarBack: docField);
        break;
      case 'panCard':
        _data = _data.copyWith(panCard: docField);
        break;
    }
    notifyListeners();
  }

  Future<void> submitRegistration(VoidCallback onSuccess) async {
    // Mock submission to backend
    await Future.delayed(const Duration(seconds: 2));
    onSuccess();
  }
}
