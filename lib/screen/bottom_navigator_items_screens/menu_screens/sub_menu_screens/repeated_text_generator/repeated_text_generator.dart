import 'package:flutter/material.dart';
import '../../../../../utils/constant/app_colors.dart';

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


  /// >>> Generated Text Function Here =========================================
  void _generatedText() {
    String text = _textController.text;
    int limit = int.tryParse(_limitController.text) ?? 1;
    String separator = '';
    setState(() {_output = List.filled(limit, text).join(separator);});
  }
  /// <<< Generated Text Function Here =========================================


  /// >>> Reset Text Function Here =============================================
  void _resetText(){
    _textController.clear();
    _limitController.clear();
    setState(() {
      _output = '';
      _repeatType = 'Regular';
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
                // >>> Gradient Background =========================================
                Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: AppColors.textRepeatBgGradient.map((color) => color.withValues(alpha: 0.5)).toList(),),),),
                // <<< Gradient Background =========================================
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [

                          // >>> TEXT FIELD ====================================
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
                          // <<< TEXT FIELD ====================================

                          // >>> Number FIELD ==================================
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
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
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                              controller: _limitController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Field is Empty";
                                }
                                final number = int.tryParse(value);
                                if (number == null) return "Only numbers allowed";
                                if (number < 1 || number > 9999) return "Enter number 1-9999";
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          // <<< Number FIELD ==================================

                          // >>> Radio Button ==================================
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
                          // <<< Radio Button ==================================

                          // >>> Reset & Generated Two Button ==================
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
                          // <<< Reset & Generated Two Button ==================

                        ],
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
                            onPressed: () {},
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy To Clipboard'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
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
