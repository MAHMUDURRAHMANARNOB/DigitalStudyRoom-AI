import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../provider/submitReactionProvider.dart';

class ReportButton extends StatefulWidget {
  final int userId;
  final int? ticketId;
  final SubmitReactionProvider submitReactionProvider;

  const ReportButton({
    Key? key,
    required this.userId,
    required this.ticketId,
    required this.submitReactionProvider,
  }) : super(key: key);

  @override
  _ReportButtonState createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  bool isLoading = false;
  bool isSubmitted = false;

  void _submitReaction() async {
    setState(() {
      isLoading = true;
    });

    bool success = await widget.submitReactionProvider
        .fetchSubmitReaction(widget.userId.toString(), widget.ticketId.toString(), "I", "C");

    setState(() {
      isLoading = false;
      if (success) {
        isSubmitted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: isSubmitted ?TColors.grey:TColors.primaryColor)
      ),
      onPressed: isLoading || isSubmitted ? null : _submitReaction,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2,color: TColors.primaryColor,),
            )
          else
            Text(
              isSubmitted ? 'Report Submitted' : 'Report Inappropriate',
              style: TextStyle(color: isSubmitted ?TColors.black:TColors.white),
            ),
        ],
      ),
    );
  }
}
