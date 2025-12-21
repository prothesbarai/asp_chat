import 'package:asp_chat/features/font_theme/provider/font_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FontSelectorWidget extends StatelessWidget {
  const FontSelectorWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        RadioGroup<AppFont>(
          groupValue: fontProvider.selectedFont,
          onChanged: (value) {
            if (value != null) fontProvider.setFont(value);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AppFont>(value: AppFont.defaults,title: const Text("Default"), activeColor: Colors.blue,),
              RadioListTile<AppFont>(value: AppFont.agbalumo,title: const Text("Agbalumo"), activeColor: Colors.blue,),
              RadioListTile<AppFont>(value: AppFont.poppins,title: const Text("Poppins"), activeColor: Colors.blue,)
            ],
          ),
        ),
      ],
    );
  }
}
