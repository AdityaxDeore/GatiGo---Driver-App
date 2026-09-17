import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../viewmodels/driver_registration_viewmodel.dart';

class StepVehicleDetails extends StatelessWidget {
  const StepVehicleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverRegistrationViewModel>();
    final details = vm.data.vehicleDetails;
    final selectedType = details.type.isNotEmpty ? details.type : 'Pink Auto';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Vehicle Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          "Specify whether you drive a designated Pink Auto or a Normal Auto.",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 20),
        const Text(
          "Auto Rickshaw Category",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: PinkAppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAutoTypeCard(
                title: "Pink Auto",
                subtitle: "Women Priority Fleet",
                icon: Icons.electric_rickshaw,
                color: PinkAppTheme.primaryPink,
                isSelected: selectedType == 'Pink Auto',
                onTap: () {
                  vm.updateVehicleDetails(details.copyWith(type: 'Pink Auto'));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAutoTypeCard(
                title: "Normal Auto",
                subtitle: "Standard Fleet",
                icon: Icons.local_taxi,
                color: Colors.amber.shade800,
                isSelected: selectedType == 'Normal Auto',
                onTap: () {
                  vm.updateVehicleDetails(details.copyWith(type: 'Normal Auto'));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          initialValue: details.registrationNumber,
          decoration: const InputDecoration(
            labelText: "Registration Number (e.g. KA01AB1234)",
          ),
          onChanged: (val) =>
              vm.updateVehicleDetails(details.copyWith(registrationNumber: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.make,
          decoration: const InputDecoration(
            labelText: "Vehicle Make (e.g. Bajaj, Piaggio)",
          ),
          onChanged: (val) =>
              vm.updateVehicleDetails(details.copyWith(make: val)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: details.model,
          decoration: const InputDecoration(
            labelText: "Vehicle Model (e.g. Compact RE)",
          ),
          onChanged: (val) =>
              vm.updateVehicleDetails(details.copyWith(model: val)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: details.year,
                decoration: const InputDecoration(labelText: "Year (e.g. 2022)"),
                keyboardType: TextInputType.number,
                onChanged: (val) =>
                    vm.updateVehicleDetails(details.copyWith(year: val)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: details.color,
                decoration: const InputDecoration(
                  labelText: "Color (e.g. Pink, Yellow/Green)",
                ),
                onChanged: (val) =>
                    vm.updateVehicleDetails(details.copyWith(color: val)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAutoTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 26),
                if (isSelected)
                  Icon(Icons.check_circle, color: color, size: 18)
                else
                  Icon(Icons.circle_outlined,
                      color: Colors.grey.shade400, size: 18),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : PinkAppTheme.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
