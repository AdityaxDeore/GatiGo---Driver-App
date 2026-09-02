enum DocumentStatus { notUploaded, uploaded, underReview, verified, rejected, requiresReupload }

class DocumentField {
  final String? filePath;
  final DocumentStatus status;

  DocumentField({this.filePath, this.status = DocumentStatus.notUploaded});

  DocumentField copyWith({String? filePath, DocumentStatus? status}) {
    return DocumentField(
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
    );
  }

  bool get isUploaded => filePath != null && filePath!.isNotEmpty;
}

class PersonalDetails {
  final String fullName;
  final String dob;
  final String address;
  final String? profilePhotoPath;

  PersonalDetails({
    this.fullName = '',
    this.dob = '',
    this.address = '',
    this.profilePhotoPath,
  });

  PersonalDetails copyWith({String? fullName, String? dob, String? address, String? profilePhotoPath}) {
    return PersonalDetails(
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    );
  }
}

class VehicleDetails {
  final String registrationNumber;
  final String make;
  final String model;
  final String year;
  final String color;
  final String type;

  VehicleDetails({
    this.registrationNumber = '',
    this.make = '',
    this.model = '',
    this.year = '',
    this.color = '',
    this.type = '',
  });

  VehicleDetails copyWith({
    String? registrationNumber,
    String? make,
    String? model,
    String? year,
    String? color,
    String? type,
  }) {
    return VehicleDetails(
      registrationNumber: registrationNumber ?? this.registrationNumber,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      type: type ?? this.type,
    );
  }
}

class DriverRegistrationData {
  final PersonalDetails personalDetails;
  final DocumentField drivingLicenceFront;
  final DocumentField drivingLicenceBack;
  final VehicleDetails vehicleDetails;
  final DocumentField vehicleRC;
  final DocumentField vehicleInsurance;
  final DocumentField vehiclePermit;
  final DocumentField fitnessCertificate;
  final DocumentField aadhaarFront;
  final DocumentField aadhaarBack;
  final DocumentField panCard;

  DriverRegistrationData({
    PersonalDetails? personalDetails,
    DocumentField? drivingLicenceFront,
    DocumentField? drivingLicenceBack,
    VehicleDetails? vehicleDetails,
    DocumentField? vehicleRC,
    DocumentField? vehicleInsurance,
    DocumentField? vehiclePermit,
    DocumentField? fitnessCertificate,
    DocumentField? aadhaarFront,
    DocumentField? aadhaarBack,
    DocumentField? panCard,
  })  : personalDetails = personalDetails ?? PersonalDetails(),
        drivingLicenceFront = drivingLicenceFront ?? DocumentField(),
        drivingLicenceBack = drivingLicenceBack ?? DocumentField(),
        vehicleDetails = vehicleDetails ?? VehicleDetails(),
        vehicleRC = vehicleRC ?? DocumentField(),
        vehicleInsurance = vehicleInsurance ?? DocumentField(),
        vehiclePermit = vehiclePermit ?? DocumentField(),
        fitnessCertificate = fitnessCertificate ?? DocumentField(),
        aadhaarFront = aadhaarFront ?? DocumentField(),
        aadhaarBack = aadhaarBack ?? DocumentField(),
        panCard = panCard ?? DocumentField();

  DriverRegistrationData copyWith({
    PersonalDetails? personalDetails,
    DocumentField? drivingLicenceFront,
    DocumentField? drivingLicenceBack,
    VehicleDetails? vehicleDetails,
    DocumentField? vehicleRC,
    DocumentField? vehicleInsurance,
    DocumentField? vehiclePermit,
    DocumentField? fitnessCertificate,
    DocumentField? aadhaarFront,
    DocumentField? aadhaarBack,
    DocumentField? panCard,
  }) {
    return DriverRegistrationData(
      personalDetails: personalDetails ?? this.personalDetails,
      drivingLicenceFront: drivingLicenceFront ?? this.drivingLicenceFront,
      drivingLicenceBack: drivingLicenceBack ?? this.drivingLicenceBack,
      vehicleDetails: vehicleDetails ?? this.vehicleDetails,
      vehicleRC: vehicleRC ?? this.vehicleRC,
      vehicleInsurance: vehicleInsurance ?? this.vehicleInsurance,
      vehiclePermit: vehiclePermit ?? this.vehiclePermit,
      fitnessCertificate: fitnessCertificate ?? this.fitnessCertificate,
      aadhaarFront: aadhaarFront ?? this.aadhaarFront,
      aadhaarBack: aadhaarBack ?? this.aadhaarBack,
      panCard: panCard ?? this.panCard,
    );
  }
}
