import 'dart:io';

import 'package:delern_flutter/flutter/localization.dart';
import 'package:delern_flutter/flutter/styles.dart' as app_styles;
import 'package:delern_flutter/flutter/text_input.dart';
import 'package:delern_flutter/views/card_create_update/pick_image_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef TextChangedCallback = void Function(String text);
typedef OnImageSelectedCallback = void Function(File file);

class CardSideInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextChangedCallback onTextChanged;
  final OnImageSelectedCallback onImageSelected;
  final FocusNode focusNode;
  final bool autofocus;
  final String hint;
  final Widget imageList;

  const CardSideInputWidget({
    @required Key key,
    @required this.controller,
    @required this.onTextChanged,
    @required this.hint,
    this.imageList,
    this.onImageSelected,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    hint,
                    style: app_styles.primaryText
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: app_styles.kImageMenuButtonSize,
                      semanticLabel: context.l.accessibilityAddImageLabel,
                    ),
                    onPressed: () {
                      hideTextInput();
                      showBottomSheet<void>(
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              PickImageMenuWidget(
                                onImageSelected: (file) {
                                  onImageSelected(file);
                                  // Close BottomSheet
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: app_styles.kBottomSheetColor,
                        elevation: app_styles.kBottomSheetElevation,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                                app_styles.kBottomSheetBorderRadius),
                            topLeft: Radius.circular(
                                app_styles.kBottomSheetBorderRadius),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              TextField(
                autofocus: autofocus,
                focusNode: focusNode,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: controller,
                onChanged: onTextChanged,
                style: app_styles.primaryText,
              ),
              if (imageList != null) imageList,
            ],
          ),
        ),
      );
}
