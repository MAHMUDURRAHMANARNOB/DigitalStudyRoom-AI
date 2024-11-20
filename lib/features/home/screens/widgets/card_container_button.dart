import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../utils/constants/colors.dart';

class TCardContainerButton extends StatelessWidget {
  const TCardContainerButton({
    super.key,
    required this.child,
    // required this.color,
  });

  final Widget child;

  // final Color color;

  @override
  Widget build(BuildContext context) {
    /*return TCurvedEdgesWidget(
      child: Container(
        // height: 400,
        color: TColors.white,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: TCircularContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: TCircularContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );*/
    return Container(
      // height: 500,
      padding: const EdgeInsets.all(0),
      child: Stack(
        children: [
          child,
          /*Positioned(
            top: -370,
            right: -150,
            child: TCircularContainer(
              backgroundColor: TColors.white.withOpacity(0.2),
            ),
          ),*/
          Positioned(
            top: -300,
            right: -180,
            child: TCircularContainer(
              backgroundColor: TColors.white.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
