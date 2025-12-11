import 'package:asp_chat/services/font_theme/provider/font_provider.dart';
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
        RadioListTile<AppFont>(
          value: AppFont.defaults,
          groupValue: fontProvider.selectedFont,
          title: Text("Default", style: fontProvider.getTextStyle()),
          onChanged: (AppFont? value) {
            if (value != null) fontProvider.setFont(value);
          },
        ),
        RadioListTile<AppFont>(
          value: AppFont.agbalumo,
          groupValue: fontProvider.selectedFont,
          title: Text("Agbalumo", style: fontProvider.getTextStyle()),
          onChanged: (AppFont? value) {
            if (value != null) fontProvider.setFont(value);
          },
        ),
        RadioListTile<AppFont>(
          value: AppFont.poppins,
          groupValue: fontProvider.selectedFont,
          title: Text("Poppins", style: fontProvider.getTextStyle()),
          onChanged: (AppFont? value) {
            if (value != null) fontProvider.setFont(value);
          },
        ),

      ],
    );
  }
}
