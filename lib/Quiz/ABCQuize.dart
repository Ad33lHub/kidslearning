
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/core/db/badges_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/quiz_completion_service.dart';
import 'package:kids/utils/model.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
class ABCQuiz extends StatefulWidget{
  const ABCQuiz({super.key});

  @override
  State<ABCQuiz> createState() => _ABCQuizState();
}
List<Numbermodel> kidslist =KidsList1();
class _ABCQuizState extends State<ABCQuiz> {
bool isPressed = false;
bool isselected = false;
// int i;
Color istrue = const Color(0xFFF19335);
Color isWrong = const Color(0xFFFF0000);
Color isselect = Colors.white;
int score = 0;
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(0xFFFEF7F0),
        title: const Center(child: Text('Alphabet',style: TextStyle(fontFamily: "arlrdbd",color: Colors.black),)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (page){
                    isPressed = false;

                  },
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                         Image.asset(kidslist[index].image),
                          const Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                           ),
                         Expanded(
                           child: GridView.count(
                             padding: const EdgeInsets.all(50),
                             mainAxisSpacing: 20,
                             crossAxisSpacing: 20,
                             physics: const NeverScrollableScrollPhysics(),
                             crossAxisCount: 2,
                             primary: false,
                              children: [
                                for(int i = 0;i<questions [index].answer.length;i++)
                                   MaterialButton(
                                     shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20.0),side: BorderSide(color: isselect)),
                                           elevation: 10.0,
                                          height: 10,
                                          minWidth: double.infinity,
                                          color: isPressed?questions[index].answer.entries.toList()[i].value?istrue:isWrong:Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical:18.0),
                                          onPressed: isPressed?(){}
                                              :(){
                                            if(questions[index].answer.entries.toList()[i].value){
                                            setState(() {
                                                isPressed = true;
                                                }
                                              );
                                              score +=  1;
                                              print(score);
                                              MotionToast.success(
                                                  borderRadius: 5,
                                                  animationDuration: const Duration(seconds: 2),
                                                  description: const Text("Your Answer is Right",style: TextStyle(fontSize: 20),)).show(context);
                                            }else{
                                              setState(() {
                                                isPressed = true;
                                                }
                                              );
                                              MotionToast.error(
                                                  borderRadius: 5,
                                                  animationDuration: const Duration(seconds: 2),
                                                  description: const Text("Your Answer is Wrong",style: TextStyle(fontSize: 20),)).show(context);
                                            }
                                          },
                                          child: Text(
                                             questions[index].answer.keys.toList()[i],
                                               style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "arlrdbd",
                                                  fontSize: 20.0
                                                ),
                                              ),
                                          ),
                                      ],
                                   ),
                             ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                heightFactor: 3,
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: isPressed ? index + 1== questions.length
                                        ?(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultSrceen(score, category: 'alphabet', total: questions.length)));
                                    }
                                        :(){
                                      controller.nextPage(duration: const Duration(microseconds: 500), curve: Curves.linear);
                                    }:null,
                                    child: Text(
                                      index + 1 == questions.length? "See Result":"Next Question",
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                          color: Colors.black,
                                          fontFamily: "arlrdbd",
                                      ),
                                    ),

                                  ),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),

    );
  }
}
class ResultSrceen extends StatefulWidget {
  final int score;
  final String category;
  final int total;
  const ResultSrceen(
    this.score, {
    super.key,
    this.category = 'alphabet',
    this.total = 0,
  });

  @override
  State<ResultSrceen> createState() => _ResultSrceenState();
}

class _ResultSrceenState extends State<ResultSrceen> {
  QuizCompletionResult? _result;
  bool _saving = true;

  @override
  void initState() {
    super.initState();
    _persistScore();
  }

  Future<void> _persistScore() async {
    final childId = context.read<AppState>().currentChild?.id;
    final total = widget.total > 0 ? widget.total : questions.length;
    final result = await QuizCompletionService.instance.record(
      childId: childId,
      category: widget.category,
      score: widget.score,
      total: total,
    );
    if (mounted) {
      setState(() {
        _result = result;
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Quiz Result',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: _saving || result == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Congratulation 🎉',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'arlrdbd',
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your Score is',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'arlrdbd',
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${result.score} / ${result.total}',
                    style: const TextStyle(
                      color: Color(0xFFF19335),
                      fontFamily: 'arlrdbd',
                      fontSize: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _starsRow(result.starsAwarded),
                  const SizedBox(height: 16),
                  _rewardChips(result),
                  if (result.newBadges.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _newBadges(result.newBadges),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF19335),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontFamily: 'arlrdbd',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _starsRow(int stars) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final filled = i < stars;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              filled ? Icons.star : Icons.star_border,
              color: const Color(0xFFF2CC2B),
              size: 56,
            ),
          );
        }),
      );

  Widget _rewardChips(QuizCompletionResult r) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _chip('⭐ +${r.starsAwarded}', const Color(0xFFFEF9E4)),
          const SizedBox(width: 12),
          _chip('🪙 +${r.coinsAwarded}', const Color(0xFFFFF9F4)),
        ],
      );

  Widget _chip(String text, Color bg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
        ),
      );

  Widget _newBadges(List<String> keys) => Column(
        children: [
          const Text(
            'New Badges!',
            style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: keys.map((k) {
              final meta = BadgeCatalog.meta[k];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBE8FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${meta?['emoji'] ?? '🏅'}  ${meta?['label'] ?? k}',
                  style: const TextStyle(fontFamily: 'arlrdbd'),
                ),
              );
            }).toList(),
          ),
        ],
      );
}