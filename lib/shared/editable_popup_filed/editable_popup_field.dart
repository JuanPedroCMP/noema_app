// import 'package:flutter/material.dart';
// import 'package:noema/core/design/theme/theme_tokens.dart';

// class EditablePopUpField extends StatefulWidget {
//   const EditablePopUpField({
//     super.key,
//     required this.inputLabel,
//     required this.onChanged,
//     required this.onConfirm,
//     required this.onCancel,
//     this.displayLabel,
//     required this.display,
//     required this.popUp,
//     required this.popUpOptions

//   });

//   final String inputLabel;
//   final ValueChanged<String> onChanged;
//   final Function() onConfirm;
//   final Function() onCancel;
//   final Widget? displayLabel;
//   final Widget display;
//   final Widget popUp;
//    final Widget popUpOptions;

//   @override
//   State<EditablePopUpField> createState() => _EditablePopUpFieldState();
// }

// class _EditablePopUpFieldState extends State<EditablePopUpField> {
//   bool isEditing = false;

//   @override
//   Widget build(BuildContext context) {
//     return !isEditing
//         ? Row(
//             spacing: context.spacing.sm,
//             children: [
//               ?widget.displayLabel,
//               widget.display,
//               OutlinedButton(
//                 onPressed: () => showDialog(context: context, builder: (BuildContext context) => Dialog(
//                   child: popUp,
//                 )),
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit),
//                     Text("Editar", style: context.textTheme.labelMedium),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         : Row(
//             spacing: context.spacing.sm,
//             children: [
//               Expanded(
//                 child: TextField(
//                   onChanged: widget.onChanged,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: widget.inputLabel,
//                   ),
//                 ),
//               ),
//               OutlinedButton(
//                 onPressed: () {
//                   widget.onConfirm();
//                   setState(() {
//                     isEditing = false;
//                   });
//                 },

//                 child: Row(
//                   children: [
//                     Icon(Icons.save_rounded),
//                     Text("Salvar", style: context.textTheme.labelMedium),
//                   ],
//                 ),
//               ),
//               OutlinedButton(
//                 onPressed: () {
//                   widget.onCancel();
//                   setState(() {
//                     isEditing = false;
//                   });
//                 },

//                 child: Row(
//                   children: [
//                     Icon(Icons.cancel),
//                     Text("Cancelar", style: context.textTheme.labelMedium),
//                   ],
//                 ),
//               ),
//             ],
//           );
//   }
// }
