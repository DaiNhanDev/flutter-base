import 'package:flutter/material.dart';

import '../../constants/app_context.dart';
import '../app_icon/app_icon.dart';
import '../text/x_text.dart';
import 'input_validator_rule.dart';

class ValidatorInput extends StatefulWidget {
  final String title;
  final String placeholder;
  final String initialValue;
  final TextInputType keyboardType;
  final void Function(String? value)? onFieldSubmitted;
  final void Function(String? value)? onValid;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final EdgeInsets? padding;
  final List<InputValidatorRule> validatorRules;
  final TextEditingController? textController;
  final bool showEmptySpaceForErrorMessage;
  final bool autocorrect;
  final bool enabled;

  const ValidatorInput({
    super.key,
    this.title = '',
    this.placeholder = '',
    this.initialValue = '',
    this.titleStyle,
    this.hintStyle,
    this.textStyle,
    this.errorTextStyle,
    this.enabledBorder,
    this.focusedBorder,
    this.padding,
    this.keyboardType = TextInputType.text,
    this.validatorRules = const [],
    this.onValid,
    this.onFieldSubmitted,
    this.textController,
    this.showEmptySpaceForErrorMessage = true,
    this.autocorrect = true,
    this.enabled = true,
  });

  @override
  State<ValidatorInput> createState() => _ValidatorInputState();
}

class _ValidatorInputState extends State<ValidatorInput> {
  late TextEditingController _controller;
  var _errorMessage = '';
  var _touched = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    _controller = widget.textController ??
        TextEditingController(text: widget.initialValue);
    _focusNode.addListener(_onChangeFocus);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_onChangeFocus)
      ..dispose();

    super.dispose();
  }

  void _onChangeFocus() {
    if (!_focusNode.hasFocus) {
      _touched = true;
      _onChanged(_controller.text);
    }

    setState(() {});
  }

  void _onClear() {
    _controller.clear();

    _onChanged('');
  }

  void _onChanged(String value, {bool submit = false}) {
    _errorMessage = widget.validatorRules.validate(value);

    setState(() {});

    final validData = _errorMessage.isEmpty ? value : null;
    if (widget.onValid != null) {
      widget.onValid!(validData);
    }

    if (submit) {
      if (widget.onFieldSubmitted != null) {
        widget.onFieldSubmitted!(validData);
      }
    }
  }

  Widget _buildErrorMessage() {
    if (!widget.showEmptySpaceForErrorMessage && _errorMessage.isEmpty) {
      return const SizedBox();
    }

    return widget.errorTextStyle != null
        ? XText.labelSmall(
            _touched ? _errorMessage : '',
            style: widget.errorTextStyle!,
          )
        : XText.labelSmall(
            _touched ? _errorMessage : '',
          ).customWith(
            context,
            color: context.errorColor,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XText.headlineSmall(
          widget.title,
          style: widget.titleStyle,
        ),
        SizedBox(
          height: widget.enabledBorder != null ? 8 : 0,
        ),
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: widget.hintStyle,
            enabledBorder: widget.enabledBorder,
            focusedBorder: widget.focusedBorder,
            contentPadding: widget.padding ?? const EdgeInsets.only(bottom: 6),
            isCollapsed: true,
            suffix: _focusNode.hasFocus && _controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: _onClear,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: AppIcon.closeCircle(),
                    ),
                  )
                : const SizedBox(height: 20),
          ),
          style: widget.textStyle ?? context.labelMedium,
          keyboardType: widget.keyboardType,
          onChanged: _onChanged,
          onFieldSubmitted: (value) => _onChanged(value, submit: true),
          autocorrect: widget.autocorrect,
          enabled: widget.enabled,
        ),
        _buildErrorMessage(),
      ],
    );
  }
}
