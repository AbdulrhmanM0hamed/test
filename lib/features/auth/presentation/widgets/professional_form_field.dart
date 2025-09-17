// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:test/core/utils/constant/font_manger.dart';
// import 'package:test/core/utils/constant/styles_manger.dart';
// import 'package:test/core/utils/theme/app_colors.dart';

// class ProfessionalFormField extends StatefulWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final IconData? prefixIcon;
//   final IconData? suffixIcon;
//   final bool obscureText;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   final VoidCallback? onSuffixTap;
//   final List<TextInputFormatter>? inputFormatters;
//   final int? maxLength;
//   final bool enabled;

//   const ProfessionalFormField({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.hint,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//     this.onSuffixTap,
//     this.inputFormatters,
//     this.maxLength,
//     this.enabled = true,
//   });

//   @override
//   State<ProfessionalFormField> createState() => _ProfessionalFormFieldState();
// }

// class _ProfessionalFormFieldState extends State<ProfessionalFormField>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   bool _isFocused = false;
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _focusNode.addListener(() {
//       setState(() {
//         _isFocused = _focusNode.hasFocus;
//       });
//       if (_isFocused) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return Text(
//               widget.label,
//               style: getMediumStyle(
//                 fontFamily: FontConstant.cairo,
//                 fontSize: FontSize.size14,
//                 color: _isFocused
//                     ? AppColors.primary
//                     : AppColors.textPrimary,
//               ),
//             );
//           },
//         ),
//         const SizedBox(height: 8),
//         AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: _isFocused
//                       ? AppColors.primary
//                       : AppColors.border,
//                   width: _isFocused ? 2 : 1,
//                 ),
//                 color: widget.enabled ? Colors.white : Colors.grey[50],
//                 boxShadow: _isFocused
//                     ? [
//                         BoxShadow(
//                           color: AppColors.primary.withValues(alpha: 0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ]
//                     : null,
//               ),
//               child: TextFormField(
//                 controller: widget.controller,
//                 focusNode: _focusNode,
//                 obscureText: widget.obscureText,
//                 keyboardType: widget.keyboardType,
//                 validator: widget.validator,
//                 inputFormatters: widget.inputFormatters,
//                 maxLength: widget.maxLength,
//                 enabled: widget.enabled,
//                 style: getRegularStyle(
//                   fontFamily: FontConstant.cairo,
//                   fontSize: FontSize.size16,
//                   color: AppColors.textPrimary,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: widget.hint,
//                   hintStyle: getRegularStyle(
//                     fontFamily: FontConstant.cairo,
//                     fontSize: FontSize.size16,
//                     color: AppColors.textSecondary,
//                   ),
//                   prefixIcon: widget.prefixIcon != null
//                       ? Icon(
//                           widget.prefixIcon,
//                           color: _isFocused
//                               ? AppColors.primary
//                               : AppColors.textSecondary,
//                         )
//                       : null,
//                   suffixIcon: widget.suffixIcon != null
//                       ? GestureDetector(
//                           onTap: widget.onSuffixTap,
//                           child: Icon(
//                             widget.suffixIcon,
//                             color: _isFocused
//                                 ? AppColors.primary
//                                 : AppColors.textSecondary,
//                           ),
//                         )
//                       : null,
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 16,
//                   ),
//                   counterText: '',
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
