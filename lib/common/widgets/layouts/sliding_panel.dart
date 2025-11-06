import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../custom_shapes/container/rounded_container.dart';

class TSlidingPanel extends StatefulWidget {
  final Widget body;
  final Widget panel;
  final double minPanelHeight;
  final double maxPanelHeight;
  final Widget? floatingWidget;
  final double initialHeight; // New initial height parameter

  const TSlidingPanel({
    super.key,
    required this.body,
    required this.panel,
    this.initialHeight = 230.0, // Default initial height
    this.minPanelHeight = 38.0,
    this.maxPanelHeight = 500.0,
    this.floatingWidget,
  });

  @override
  TSlidingPanelState createState() => TSlidingPanelState();
}

class TSlidingPanelState extends State<TSlidingPanel> {
  late double _floatingWidgetBottomPosition;
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    super.initState();
    // Set initial position slightly above the closed panel height
    _floatingWidgetBottomPosition = widget.minPanelHeight + 20;

    WidgetsBinding.instance.addPostFrameCallback((_) => setInitialPanelHeight());
  }

  @override
  Widget build(BuildContext context) {
    double panelOpenHeight = widget.maxPanelHeight;
    double panelClosedHeight = widget.minPanelHeight;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Main body content
        SlidingUpPanel(
          controller: _panelController,
          maxHeight: panelOpenHeight,
          minHeight: panelClosedHeight,
          color: THelperFunctions.isDarkMode(context) ? TColors.backgroundDark : Colors.white,
          snapPoint: 0.5,
          defaultPanelState: PanelState.CLOSED,
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          body: widget.body,
          panel: widget.panel,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
          onPanelSlide: (double pos) {
            setState(() {
              // Calculate the bottom position of the floating widget
              _floatingWidgetBottomPosition = panelClosedHeight + pos * (panelOpenHeight - panelClosedHeight) + 20; // Adds some space above panel
            });
          },
        ),

        // Floating widget with dynamic bottom position
        if (widget.floatingWidget != null)
          Positioned(
            bottom: _floatingWidgetBottomPosition,
            child: widget.floatingWidget!,
          ),

        Positioned(
          top: MediaQuery.of(context).viewPadding.top + TSizes.defaultSpace,
          left: TSizes.defaultSpace,
          child: TRoundedContainer(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.all(TSizes.sm),
            backgroundColor: TColors.backgroundLight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: TColors.black),
            ),
          ),
        ),
      ],
    );
  }

  // Function to programmatically set initial height
  void setInitialPanelHeight() {
    _panelController.animatePanelToPosition(
      widget.initialHeight / widget.maxPanelHeight,
      duration: const Duration(milliseconds: 300),
    );
  }
}
