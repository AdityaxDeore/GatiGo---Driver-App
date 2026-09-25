import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/driver_registration_model.dart';
import '../../../../core/services/driver_api_service.dart';
import '../../../../core/storage/session_storage.dart';

class DriverRegistrationViewModel extends ChangeNotifier {
  int _currentStep = 0;
  final int totalSteps = 6;
  
  DriverRegistrationData _data = DriverRegistrationData();
  final ImagePicker _imagePicker = ImagePicker();
  final DriverApiService _apiService;
  DriverRegistrationViewModel({DriverApiService? apiService})
      : _apiService = apiService ?? DriverApiService();

  int get currentStep => _currentStep;
  DriverRegistrationData get data => _data;
  bool get isCurrentStepValid {
    if (_currentStep == 0) {
      final p = _data.personalDetails;
      return RegExp(r"^[A-Za-z .'-]{2,60}$").hasMatch(p.fullName.trim()) && RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(p.dob) &&
          p.address.trim().isNotEmpty && {'Male', 'Female', 'Other'}.contains(p.gender) &&
          RegExp(r'^[A-Z0-9]{6,20}$').hasMatch(p.licenseNumber.replaceAll(RegExp(r'[- ]'), '').toUpperCase());
    }
    if (_currentStep == 1) return _data.drivingLicenceFront.isUploaded && _data.drivingLicenceBack.isUploaded;
    if (_currentStep == 2) {
      final v = _data.vehicleDetails;
      return RegExp(r'^[A-Z]{2}[- ]?\d{1,2}[- ]?[A-Z]{1,3}[- ]?\d{4}$').hasMatch(v.registrationNumber.toUpperCase()) &&
          v.make.trim().isNotEmpty && v.model.trim().isNotEmpty && (v.type != 'Pink Auto' || _data.personalDetails.gender == 'Female');
    }
    if (_currentStep == 3) return _data.vehicleRC.isUploaded;
    if (_currentStep == 4) return _data.aadhaarFront.isUploaded && _data.aadhaarBack.isUploaded;
    return true;
  }
  bool nextStep() {
    if (isCurrentStepValid && _currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
      return true;
    }
    return false;
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

  Future<String?> takePhoto({bool isDocument = true}) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: isDocument ? 1280 : 512,
        maxHeight: isDocument ? 1280 : 512,
        imageQuality: isDocument ? 80 : 85,
      );
      return photo?.path;
    } catch (e) {
      debugPrint("Error taking photo: $e");
      return null;
    }
  }

  Future<String?> pickDocument({bool isDocument = true}) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: isDocument ? 1280 : 512,
        maxHeight: isDocument ? 1280 : 512,
        imageQuality: isDocument ? 80 : 85,
      );
      return photo?.path;
    } catch (e) {
      debugPrint("Error picking document: $e");
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

  Future<bool> submitRegistration(VoidCallback onSuccess) async {
    try {
      if (!isCurrentStepValid || !_allRequiredDocumentsUploaded()) return false;
      final name = _data.personalDetails.fullName;
      final phone = SessionStorage.getDriverPhone();
      final vehiclePlate = _data.vehicleDetails.registrationNumber.toUpperCase().replaceAll(RegExp(r'[- ]'), '');
      final vehicleModel = '${_data.vehicleDetails.make} ${_data.vehicleDetails.model}'.trim();
      final serviceType = _data.vehicleDetails.type.toLowerCase().contains('pink') ? 'pink_auto' : 'standard_auto';
      final documentsPayload = await _uploadRequiredDocuments();

      final personalDetailsPayload = {
        'fullName': name,
        'dob': _data.personalDetails.dob,
        'address': _data.personalDetails.address,
        'profilePhotoPath': _data.personalDetails.profilePhotoPath,
        'licenseNumber': _data.personalDetails.licenseNumber.toUpperCase().replaceAll(RegExp(r'[- ]'), ''),
        'gender': _data.personalDetails.gender,
      };

      final vehicleDetailsPayload = {
        'type': _data.vehicleDetails.type,
        'registrationNumber': vehiclePlate,
        'make': _data.vehicleDetails.make,
        'model': _data.vehicleDetails.model,
        'year': _data.vehicleDetails.year,
        'color': _data.vehicleDetails.color,
      };

      final result = await _apiService.registerDriver(
        fullName: name,
        phone: phone,
        licenseNumber: _data.personalDetails.licenseNumber.toUpperCase().replaceAll(RegExp(r'[- ]'), ''),
        vehiclePlate: vehiclePlate,
        vehicleMakeModel: vehicleModel.isNotEmpty ? vehicleModel : 'Bajaj RE Compact',
        serviceType: serviceType,
        gender: _data.personalDetails.gender.toLowerCase(),
        personalDetails: personalDetailsPayload,
        vehicleDetails: vehicleDetailsPayload,
        documents: documentsPayload,
      );
      if (result == null) return false;

      await SessionStorage.submitForVerification(
        name: name,
        phone: phone,
        vehicleNumber: vehiclePlate,
        autoType: serviceType,
      );
    } catch (e) {
      debugPrint("Registration submit notice: $e");
      return false;
    }
    onSuccess();
    return true;
  }

  bool _allRequiredDocumentsUploaded() => _data.drivingLicenceFront.isUploaded && _data.drivingLicenceBack.isUploaded &&
      _data.vehicleRC.isUploaded && _data.aadhaarFront.isUploaded && _data.aadhaarBack.isUploaded;

  Future<Map<String, String>> _uploadRequiredDocuments() async {
    final fields = <String, String>{
      'driving_licence_front': _data.drivingLicenceFront.filePath!,
      'driving_licence_back': _data.drivingLicenceBack.filePath!,
      'vehicleRC': _data.vehicleRC.filePath!,
      'aadhaar_front': _data.aadhaarFront.filePath!,
      'aadhaar_back': _data.aadhaarBack.filePath!,
    };
    final urls = <String, String>{};
    for (final entry in fields.entries) {
      final encoded = base64Encode(await File(entry.value).readAsBytes());
      final url = await _apiService.uploadDocument(docType: entry.key, imageBase64: encoded);
      if (url == null || url.isEmpty) throw StateError('Unable to upload ${entry.key}');
      urls[entry.key] = url;
    }
    return urls;
  }
}
