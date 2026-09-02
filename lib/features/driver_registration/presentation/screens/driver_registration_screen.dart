import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/mds/widgets/mds_button.dart';
import '../viewmodels/driver_registration_viewmodel.dart';
import '../widgets/registration_steps.dart';

class DriverRegistrationScreen extends StatelessWidget {
  const DriverRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriverRegistrationViewModel(),
      child: const DriverRegistrationView(),
    );
  }
}

class DriverRegistrationView extends StatelessWidget {
  const DriverRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Registration", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (vm.currentStep + 1) / vm.totalSteps,
              backgroundColor: Colors.grey.shade200,
              color: PinkAppTheme.primaryPink,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentStep(vm.currentStep),
                ),
              ),
            ),
            // Bottom Navigation
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
                ],
              ),
              child: Row(
                children: [
                  if (vm.currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: vm.previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: PinkAppTheme.primaryPink,
                          side: const BorderSide(color: PinkAppTheme.primaryPink),
                        ),
                        child: const Text("Back"),
                      ),
                    ),
                  if (vm.currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: MdsButton(
                      text: vm.currentStep == vm.totalSteps - 1 ? "Submit Application" : "Next",
                      onPressed: () {
                        if (vm.currentStep == vm.totalSteps - 1) {
                          _submit(context, vm);
                        } else {
                          vm.nextStep();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return const StepPersonalDetails(key: ValueKey(0));
      case 1:
        return const StepDrivingLicence(key: ValueKey(1));
      case 2:
        return const StepVehicleDetails(key: ValueKey(2));
      case 3:
        return const StepVehicleDocuments(key: ValueKey(3));
      case 4:
        return const StepIdentity(key: ValueKey(4));
      case 5:
        return const StepReview(key: ValueKey(5));
      default:
        return const SizedBox.shrink();
    }
  }

  void _submit(BuildContext context, DriverRegistrationViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );
    
    vm.submitRegistration(() {
      Navigator.pop(context); // close dialog
      Navigator.pushReplacementNamed(context, '/verification-status');
    });
  }
}
