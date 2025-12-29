import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../utils/constant/app_colors.dart';
import '../../../../../utils/constant/app_string.dart';

class RepeatedTextGenerator extends StatefulWidget {
  const RepeatedTextGenerator({super.key});

  @override
  State<RepeatedTextGenerator> createState() => _RepeatedTextGeneratorState();
}

class _RepeatedTextGeneratorState extends State<RepeatedTextGenerator> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _output = '';
  String _repeatType = 'Regular';
  bool isChecked = true;
  String? _selectedValue;


  /// >>> Generated Text Function Here =========================================
  void _generatedText() {
    String text = _textController.text;
    int limit = int.tryParse(_limitController.text) ?? 1;
    String separator = '';
    if(_repeatType == "Space"){
      separator = ' ';
    }else if(_repeatType == "New Line"){
      separator = '\n';
    }else{
      separator = '';
    }
    setState(() {_output = List.filled(limit, text).join(separator);});
  }
  /// <<< Generated Text Function Here =========================================


  /// >>> Reset Text Function Here =============================================
  void _resetText(){
    _formKey.currentState?.reset();
    _textController.clear();
    _limitController.clear();
    setState(() {
      _output = '';
      _repeatType = 'Regular';
      _selectedValue = null;
    });
  }
  /// <<< Reset Text Function Here =============================================


  @override
  void dispose() {
    _textController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repeated Text Generator')),
      body: SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                // >>> Gradient Background =====================================
                Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: AppColors.textRepeatBgGradient.map((color) => color.withValues(alpha: 0.5)).toList(),),),),
                // <<< Gradient Background =====================================
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [

                            // >>> TEXT FIELD ==================================
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: "Text",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  prefixIcon: Padding(padding: const EdgeInsets.only(left: 15.0), child: Icon(Icons.text_fields, color: Colors.white, size: 20,),),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  counterStyle: TextStyle(color: Colors.white),
                                ),
                                minLines: 1,
                                maxLines: 4,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                                controller: _textController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value){
                                  if(value == null || value.trim().isEmpty){
                                    return "Field is Empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            // <<< TEXT FIELD ==================================

                            // >>> Number & Emoji FIELD ========================
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          hintText: "Repetition Limit",
                                          filled: false,
                                          hintStyle: TextStyle(color: Colors.white70),
                                          prefixIcon: Padding(padding: const EdgeInsets.only(left: 15.0), child: Icon(Icons.numbers, color: Colors.white, size: 20,),),
                                          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                          counterStyle: TextStyle(color: Colors.white)
                                      ),
                                      maxLength: 4,
                                      buildCounter: (context, {required currentLength, required isFocused, maxLength,}) => null,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.white,
                                      controller: _limitController,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return "Empty";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                        initialValue: _selectedValue,
                                        dropdownColor: Theme.of(context).colorScheme.surface,
                                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                        style: const TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            hintText: "Emoji",
                                            hintStyle: const TextStyle(color: Colors.white),
                                            prefixIcon: const Padding(padding: EdgeInsets.only(left: 15.0), child: Icon(Icons.emoji_emotions_outlined, color: Colors.white, size: 20,),),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(35),),
                                            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(35),),
                                            border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(35),),
                                            fillColor: Colors.transparent
                                        ),
                                        items: AppString.dropdownEmojiList.map((item) {
                                          return DropdownMenuItem<String>(value: item, child: Text(item, style: TextStyle(color: Theme.of(context).colorScheme.onSurface,),),);
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {_selectedValue = value;});
                                        },
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Empty";
                                          }
                                          return null;
                                        },
                                      ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            // <<< Number & Emoji FIELD ========================


                            // >>> Radio Button ================================
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  RadioGroup<String>(
                                    groupValue: _repeatType,
                                    onChanged: (value) {setState(() {_repeatType = value!;});},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: ['Regular', 'Space', 'New Line'].map((type) {
                                        return Row(children: [Radio<String>(value: type), Text(type, style: TextStyle(color: Colors.white),),],);
                                      }).toList(),
                                    ),
                                  ),

                                ]
                            ),
                            const SizedBox(height: 16),
                            // <<< Radio Button ================================


                            // >>> Check Box ===================================
                            Row(
                              children: [

                              ],
                            ),
                            // <<< Check Box ===================================


                            // >>> Reset & Generated Two Button ================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: (){FocusScope.of(context).unfocus();if(_formKey.currentState!.validate()){_resetText();}},
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonBgColor, foregroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5)),
                                  child: const Text('Reset'),
                                ),
                                ElevatedButton(
                                  onPressed: (){FocusScope.of(context).unfocus();if(_formKey.currentState!.validate()){_generatedText();}},
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonBgColor, foregroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5)),
                                  child: const Text('Generate'),
                                ),
                              ],
                            ),
                            // <<< Reset & Generated Two Button ================

                          ],
                        ),
                      ),
                    ),


                    if(_output.isNotEmpty)...[
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8),),
                            child: Text(_output,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 18),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _output));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')),);
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy To Clipboard'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async{
                              if(_output.isNotEmpty) await SharePlus.instance.share(ShareParams(text: _output));
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                          ),
                        ],
                      ),
                    ],

                  ],
                ),
              ],
            )
        )
      ),
    );
  }


}
