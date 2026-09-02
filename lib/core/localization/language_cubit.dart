import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState.initial());

  void changeLanguage(String code) {
    if (state.languageCode != code) {
      emit(state.copyWith(
        languageCode: code,
      ));
    }
  }

  String translate(String text) {
    if (state.languageCode == 'en' || text.trim().isEmpty) {
      return text;
    }

    // Check static pre-translated map only (offline)
    final staticMap = _staticTranslations[state.languageCode];
    if (staticMap != null && staticMap.containsKey(text)) {
      return staticMap[text]!;
    }

    return text;
  }

  static const Map<String, Map<String, String>> _staticTranslations = {
    'hi': {
      'Onboarding': 'ऑनबोर्डिंग',
      'Safe Rides, Dedicated Choices': 'सुरक्षित सवारी, समर्पित विकल्प',
      'Introducing Pink Auto: Rides driven exclusively by vetted female drivers for ultimate peace of mind and comfort.': 'पेश है पिंक ऑटो: परम मानसिक शांति और आराम के लिए विशेष रूप से जांची गई महिला चालकों द्वारा संचालित सवारी।',
      'Empowering Women Drivers': 'महिला चालकों को सशक्त बनाना',
      'Every ride you take supports female entrepreneurs, creating sustainable livelihoods and community strength.': 'आपकी हर सवारी महिला उद्यमियों का समर्थन करती है, जिससे स्थायी आजीविका और सामुदायिक ताकत का निर्माण होता है।',
      'Standard or Pink - You Choose': 'सामान्य या पिंक - आप चुनें',
      'Need a quick ride? Pick a standard auto or opt for a Pink Auto with just a single tap. Flexibility is yours.': 'जल्दी सवारी चाहिए? एक सामान्य ऑटो चुनें या सिर्फ एक टैप से पिंक ऑटो का विकल्प चुनें। लचीलापन आपका है।',
      'Skip': 'छोड़ें',
      'Next': 'आगे',
      'Get Started': 'शुरू करें',
      'Account': 'खाता',
      'Personal Info': 'व्यक्तिगत जानकारी',
      'Name, email, DOB, preference': 'नाम, ईमेल, जन्मतिथि, प्राथमिकता',
      'Safety Center': 'सुरक्षा केंद्र',
      'trusted contacts configured': 'विश्वस्त संपर्क कॉन्फिगर किए गए',
      'Saved Places': 'सहेजे गए स्थान',
      'App Language': 'ऐप की भाषा',
      'English': 'अंग्रेज़ी',
      'Hindi': 'हिंदी',
      'Marathi': 'मराठी',
      'Help and Support': 'सहायता और समर्थन',
      'FAQs, contact us, feedback': 'अक्सर पूछे जाने वाले प्रश्न, हमसे संपर्क करें, प्रतिक्रिया',
      'Log Out': 'लॉग आउट',
      'Safety Anchor': 'सुरक्षा कवच',
      'SOS': 'एसओएस',
      'Choose Language': 'भाषा चुनें',
      'Select your preferred app language': 'अपनी पसंदीदा ऐप भाषा चुनें',
      'Enter Mobile Number': 'मोबाइल नंबर दर्ज करें',
      'We will send you a 6-digit OTP to verify your account': 'हम आपके खाते को सत्यापित करने के लिए 6 अंकों का ओटीपी भेजेंगे',
      'Send OTP': 'ओटीपी भेजें',
      'Verify Phone': 'फ़ोन सत्यापित करें',
      'Enter the 6-digit code sent to': 'भेजा गया 6 अंकों का कोड दर्ज करें',
      'Resend Code': 'कोड पुनः भेजें',
      'Verify & Proceed': 'सत्यापित करें और आगे बढ़ें',
      'Standard Auto': 'सामान्य ऑटो',
      'Pink Auto': 'पिंक ऑटो',
      'Fast and reliable everyday rides': 'तेज और विश्वसनीय दैनिक सवारी',
      'Driven by women, for women': 'महिलाओं द्वारा संचालित, महिलाओं के लिए',
      'Where to?': 'कहाँ जाना है?',
      'Popular Services': 'लोकप्रिय सेवाएं',
      'Book Ride': 'राइड बुक करें',
      'Enter your mobile number': 'अपना मोबाइल नंबर दर्ज करें',
      'We will send you a 4-digit verification code to confirm your profile.': 'हम आपकी प्रोफ़ाइल की पुष्टि करने के लिए 4 अंकों का सत्यापन कोड भेजेंगे।',
      'Enter confirmation code': 'पुष्टिकरण कोड दर्ज करें',
      'Send Verification Code': 'सत्यापन कोड भेजें',
      'Didn\'t receive the code? ': 'कोड नहीं मिला? ',
      'Resend OTP': 'ओटीपी पुनः भेजें',
    },
    'mr': {
      'Onboarding': 'ऑनबोर्डिंग',
      'Safe Rides, Dedicated Choices': 'सुरक्षित प्रवास, समर्पित पर्याय',
      'Introducing Pink Auto: Rides driven exclusively by vetted female drivers for ultimate peace of mind and comfort.': 'सादर करत आहोत पिंक ऑटो: मनाच्या शांतीसाठी आणि सुविधेसाठी विशेषतः पडताळणी केलेल्या महिला चालकांद्वारे चालवल्या जाणाऱ्या फेऱ्या.',
      'Empowering Women Drivers': 'महिला चालकांना सक्षम बनवणे',
      'Every ride you take supports female entrepreneurs, creating sustainable livelihoods and community strength.': 'तुम्ही घेतलेली प्रत्येक राइड महिला उद्योजकांना पाठबळ देते, शाश्वत उपजीविका आणि सामूहिक शक्ती निर्माण करते.',
      'Standard or Pink - You Choose': 'सामान्य की पिंक - तुमचे नियंत्रण',
      'Need a quick ride? Pick a standard auto or opt for a Pink Auto with just a single tap. Flexibility is yours.': 'जलद राइड हवी आहे? एक सामान्य ऑटो निवडा किंवा फक्त एका टॅपने पिंक ऑटोचा पर्याय निवडा. लवचिकता तुमची आहे.',
      'Skip': 'वगळा',
      'Next': 'पुढे',
      'Get Started': 'सुरू करा',
      'Account': 'खाते',
      'Personal Info': 'वैयक्तिक माहिती',
      'Name, email, DOB, preference': 'नाव, ईमेल, जन्म तारीख, प्राधान्य',
      'Safety Center': 'सुरक्षा केंद्र',
      'trusted contacts configured': 'विश्वासू संपर्क कॉन्फिगर केले आहेत',
      'Saved Places': 'जतन केलेली ठिकाणे',
      'App Language': 'अ‍ॅपची भाषा',
      'English': 'इंग्रजी',
      'Hindi': 'हिंदी',
      'Marathi': 'मराठी',
      'Help and Support': 'मदत आणि सहकार्य',
      'FAQs, contact us, feedback': 'वारंवार विचारले जाणारे प्रश्न, संपर्क, अभिप्राय',
      'Log Out': 'लॉग आउट',
      'Safety Anchor': 'सुरक्षा कवच',
      'SOS': 'एसओएस',
      'Choose Language': 'भाषा निवडा',
      'Select your preferred app language': 'तुमची पसंतीची अ‍ॅप भाषा निवडा',
      'Enter Mobile Number': 'मोबाईल नंबर प्रविष्ट करा',
      'We will send you a 6-digit OTP to verify your account': 'आम्ही registreation verify करण्यासाठी ६ अंकी ओटीपी पाठवू',
      'Send OTP': 'ओटीपी पाठवा',
      'Verify Phone': 'फोन सत्यापित करा',
      'Enter the 6-digit code sent to': 'पाठवलेला ६ अंकी कोड प्रविष्ट करा',
      'Resend Code': 'कोड पुन्हा पाठवा',
      'Verify & Proceed': 'सत्यापित करा आणि पुढे जा',
      'Standard Auto': 'सामान्य ऑटो',
      'Pink Auto': 'पिंक ऑटो',
      'Fast and reliable everyday rides': 'जलद आणि विश्वासार्ह दैनिक सवारी',
      'Driven by women, for women': 'महिलांद्वारे संचालित, महिलांसाठी',
      'Where to?': 'कुठे जायचे आहे?',
      'Popular Services': 'लोकप्रिय सेवा',
      'Book Ride': 'राइड बुक करा',
      'Enter your mobile number': 'तुमचा मोबाईल नंबर प्रविष्ट करा',
      'We will send you a 4-digit verification code to confirm your profile.': 'आम्ही तुमच्या प्रोफाइलची पुष्टी करण्यासाठी ४ अंकी सत्यापन कोड पाठवू.',
      'Enter confirmation code': 'पुष्टीकरण कोड प्रविष्ट करा',
      'Send Verification Code': 'सत्यापन कोड पाठवा',
      'Didn\'t receive the code? ': 'कोड मिळाला नाही? ',
      'Resend OTP': 'ओटीपी पुन्हा पाठवा',
    }
  };
}
