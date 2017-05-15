/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:   2017/03/20
*
*This file is the base page for Landspace and  Portrait screen display
*
*/
library base;
import 'package:flutter/material.dart';
import 'dart:math' as math;
/*
 * this is landspace screen display in flutter app size layout
 * only need add exdends a other class to show other size
 */
class LandspaceLayout extends MultiChildLayoutDelegate {
  LandspaceLayout();
  static final String background = 'background';
  static final String centerElements = 'centerElements';

  // Horizontally: the feature product image appears on the left and
  // occupies 50% of the available width; the feature product's
  // description apepars on the right and occupies 50% of the available
  // width + unitSize. The left and right widgets overlap and the right
  // widget is stacked on top.
  @override
  void performLayout(Size size) {
      layoutChild(background,
          new BoxConstraints.tightFor(width: size.height, height: size.height));
      positionChild(background, new Offset((math.max(size.width, size.height) -
          math.min(size.width, size.height)) / 2, 0.0));
      layoutChild(centerElements,
          new BoxConstraints.expand(width: size.height, height: size.height));
      positionChild(centerElements, new Offset(
          (math.max(size.width, size.height) -
              math.min(size.width, size.height)) / 2, 0.0));
}
  @override
  bool shouldRelayout(LandspaceLayout oldDelegate) => false;
}


/*
 * this is portrait screen display in flutter app size layout
 * only need add exdends a other class to show other size
 */
class PortraitLayout extends MultiChildLayoutDelegate {
  PortraitLayout();

  static final String background = 'background';
  static final String centerElements = 'centerElements';

  // Horizontally: the feature product image appears on the left and
  // occupies 50% of the available width; the feature product's
  // description apepars on the right and occupies 50% of the available
  // width + unitSize. The left and right widgets overlap and the right
  // widget is stacked on top.
  @override
  void performLayout(Size size) {
      layoutChild(background,
          new BoxConstraints.tightFor(width: size.width, height: size.width));
      positionChild(
          background, new Offset(0.0, (math.max(size.width, size.height) -
          math.min(size.width, size.height)) / 2));
      layoutChild(centerElements,
          new BoxConstraints.expand(width: size.width, height: size.width));
      positionChild(centerElements, new Offset(
          0.0, (math.max(size.width, size.height) -
          math.min(size.width, size.height)) / 2));
}
  @override
  bool shouldRelayout(PortraitLayout oldDelegate) => false;
}
