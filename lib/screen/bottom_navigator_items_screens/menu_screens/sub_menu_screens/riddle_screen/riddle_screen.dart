import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../utils/constant/app_colors.dart';

class RiddleScreen extends StatefulWidget {
  const RiddleScreen({super.key});

  @override
  State<RiddleScreen> createState() => _RiddleScreenState();
}

class _RiddleScreenState extends State<RiddleScreen> {

  final List<DocumentSnapshot> _riddles = [];
  final int _limit = 10;
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();
  bool showAnswer = false;


  @override
  void initState() {
    super.initState();
    fetchRiddles();
    _scrollController.addListener(() {if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore){fetchRiddles();}},);
  }


  /// >>>> Fetch Riddle Data Here By Pagination ================================
  Future<void> fetchRiddles() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    Query query = FirebaseFirestore.instance.collection("riddles").where('createdAt', isNull: false).orderBy('createdAt', descending: true).limit(_limit);
    if(_lastDocument != null){query = query.startAfterDocument(_lastDocument!);}
    QuerySnapshot snapshot = await query.get();
    if(snapshot.docs.isNotEmpty){
      _lastDocument = snapshot.docs.last;
      _riddles.addAll(snapshot.docs);
    }
    if(snapshot.docs.length < _limit){_hasMore = false;}
    setState(() => _isLoading = false);
  }
  /// <<<< Fetch Riddle Data Here By Pagination ================================



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(children: [Icon(Icons.psychology,), Text("Riddle", style: const TextStyle(fontWeight: FontWeight.bold,),),],), centerTitle: true,),
      body: SafeArea(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: _riddles.length + 1,
            itemBuilder: (context, index) {
              if(index < _riddles.length){
                final data = _riddles[index].data() as Map<String, dynamic>;
                return designRiddleCard(question: data['question'], answer: data['answer'], index: index + 1,);
              }else{
                return _isLoading ? Padding(padding: EdgeInsets.all(16), child: Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,)),) : const SizedBox();
              }
            },
          )
      ),
    );
  }


  /// >>> RiddleCard Design Start Here =========================================
  Widget designRiddleCard({required String question, required String answer, required int index,}) {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: showAnswer ? [Colors.greenAccent.shade400, Colors.teal.shade700] : [Colors.deepPurple.shade600, Colors.indigo.shade800],),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 14, offset: const Offset(0, 6),),],
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(6),),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2),borderRadius: BorderRadius.circular(50)),
                        child: const Icon(Icons.psychology, color: Colors.white, size: 20,),
                      ),
                      const SizedBox(width: 10),
                      Text("ধাঁধা #$index", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600,),),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(question, style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.white, fontWeight: FontWeight.w500,),),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {setLocalState(() {showAnswer = !showAnswer;});},
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showAnswer ?
                      Container(
                        key: const ValueKey("answer"),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18),borderRadius: BorderRadius.circular(6),),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb, color: Colors.yellowAccent,size: 15,),
                            const SizedBox(width: 8),
                            Expanded(child: Text(answer, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600,),),),
                          ],
                        ),
                      ) :
                      Row(
                        key: const ValueKey("btn"),
                        children: const [
                          Icon(Icons.visibility, color: Colors.white70, size: 18),
                          SizedBox(width: 6),
                          Text("উত্তর দেখুন", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600,),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  /// <<< RiddleCard Design Start Here =========================================


}
