import 'package:finmapp/model/loanJson.dart';
import 'package:finmapp/provider/QuestionProvider.dart';
import 'package:finmapp/types/questionTypes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    Provider.of<QuestionProvider>(context, listen: false).loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Scaffold(body: Consumer<QuestionProvider>(
          builder: (_, provider, __) {
            LoanQuestionnaire? loanTemplate;
            if (!provider.isDataLoaded) {
              loanTemplate = provider.getTemplate;
            }

            return provider.isDataLoaded
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                loanTemplate?.title ?? "About Loans",
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        provider.selectedIndex < provider.length
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    for (var i = 0; i < provider.length; i++)
                                      Container(
                                        decoration: BoxDecoration(
                                            color: provider.selectedIndex > i
                                                ? Colors.green
                                                : Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: (size.width / provider.length) -
                                            (provider.length * 3),
                                        height: 5,
                                        margin: const EdgeInsets.all(2),
                                      ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: provider.selectedIndex < provider.length
                              ? PageView.builder(
                                  controller: _pageController,
                                  itemCount: provider.length,
                                  onPageChanged: (value) => {
                                    value <= provider.details.length
                                        ? provider.updateIndex(value)
                                        : _pageController.jumpTo(value + 0.0),
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Question? question;
                                    question = provider.questions![index];
                                    return ListView(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, bottom: 1),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, bottom: 16),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      question.schema!.label ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 22,
                                                          // overflow:
                                                          //     TextOverflow.ellipsis,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ...buildContainer(
                                                provider,
                                                question.schema
                                                    as QuestionSchema,
                                                question.type as String),
                                          ],
                                        ),
                                      ),
                                    ]);
                                  },
                                )
                              : ListView(
                                  children: List.generate(
                                      provider.details.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  provider.details[index].label
                                                      .toString(),
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                '•',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30),
                                              ),
                                              provider.details[index].value
                                                          .runtimeType ==
                                                      String
                                                  ? Text(provider
                                                      .details[index].value)
                                                  : Row(
                                                      children: List.generate(
                                                          provider
                                                              .details[index]
                                                              .value
                                                              .length,
                                                          (ind) => Column(
                                                                children: [
                                                                  Text(provider
                                                                          .details[
                                                                              index]
                                                                          .value[ind] +
                                                                      " | "),
                                                                ],
                                                              )),
                                                    )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                        ),
                        provider.selectedIndex < provider.length
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: GestureDetector(
                                          onTap: () {},
                                          child: TextButton(
                                            onPressed: () {
                                              if (_pageController.hasClients &&
                                                  provider.selectedIndex != 0) {
                                                _pageController.animateToPage(
                                                    provider.selectedIndex - 1,
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    curve: Curves.decelerate);
                                              }
                                            },
                                            child: Text(
                                              "< Back",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20,
                                                  color:
                                                      provider.selectedIndex !=
                                                              0
                                                          ? Colors.black
                                                          : Colors.grey),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_pageController.hasClients &&
                                              provider.selectedIndex <
                                                  provider.length &&
                                              provider.details.length >
                                                  provider.selectedIndex) {
                                            _pageController.animateToPage(
                                                provider.selectedIndex + 1,
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                curve: Curves.easeInOut);
                                            provider.updateIndex(
                                                provider.selectedIndex + 1);
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: provider.selectedIndex <
                                                          provider.length &&
                                                      provider.details.length >
                                                          provider.selectedIndex
                                                  ? const Color.fromARGB(
                                                      255, 221, 132, 17)
                                                  : Colors.grey),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: () {
                                  provider.updateIndex(0);
                                },
                                child: const Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    children: [Icon(Icons.home), Text("Home")],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                : const CircularProgressIndicator();
          },
        )),
      ),
    );
  }

  final TextEditingController _incomTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Widget> buildContainer(
      QuestionProvider provider, QuestionSchema question, String type) {
    List<Detail> details = provider.getDetails;

    switch (type) {
      case section:
        int currIndex = question.fields!.length;
        if (!question.fields!.first.type!.contains(numeric)) {
          if (details.length < provider.selectedIndex + 1) {
            currIndex = 1;
          } else if (details[provider.selectedIndex]
              .value
              .contains("Haryana")) {
            currIndex = question.fields!.length;
          } else {
            currIndex = 1;
          }
        }
        return List.generate(
            currIndex,
            (index) => getOptions(
                  provider,
                  question,
                  index,
                  type,
                ));

      case singleSelect || singleChoiceSelector:
        return List.generate(
          question.options!.length,
          (index) => GestureDetector(
            onTap: () {
              provider.updateDetails(
                  question.label, question.options![index].value, type, null);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: details.length > provider.selectedIndex &&
                            details.isNotEmpty
                        ? details[provider.selectedIndex].value ==
                                question.options![index].value
                            ? Colors.orange
                            : Colors.black
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: details.length > provider.selectedIndex &&
                              details.isNotEmpty
                          ? details[provider.selectedIndex].value ==
                                  question.options![index].value
                              ? true
                              : false
                          : false,
                      onChanged: (value) {
                        provider.updateDetails(question.label,
                            question.options![index].value, type, null);
                      },
                      activeColor: Colors.orange,
                    ),
                    Text(
                      "${question.options![index].value}",
                      style: TextStyle(
                          color: details.length > provider.selectedIndex &&
                                  details.isNotEmpty
                              ? details[provider.selectedIndex].value ==
                                      question.options![index].value
                                  ? Colors.orange
                                  : Colors.black
                              : Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      default:
        return [];
    }
  }

  Widget getOptions(provider, QuestionSchema question, index, type) {
    List<Detail> details = provider.details;
    QuestionSchema currQues = question.fields![index].schema as QuestionSchema;

    String formatNumberWithCommas(String input) {
      final RegExp regExp = RegExp(r'(\d{2,3})(?=(\d{3})+(?!\d))');
      return input.replaceAllMapped(regExp, (Match match) => '${match[1]},');
    }

    switch (question.fields![index].type) {
      case numeric:
        if (details
                    .firstWhere(
                      (elem) => elem.label == question.label,
                      orElse: () => Detail(label: null, value: null),
                    )
                    .label !=
                null &&
            _incomTextController.text.isNotEmpty) {
          Detail det = provider.details!
              .firstWhere((elem) => elem.label == question.label);
          List val = det.value;
          _incomTextController.text = val.isNotEmpty ? val[0] : "00000";
        }
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _incomTextController,
              focusNode: _focusNode,
              onTapOutside: (event) => _focusNode.unfocus(),
              onEditingComplete: () => {
                if (_incomTextController.text.isNotEmpty &&
                    details.length < provider.selectedIndex + 1)
                  {
                    provider.updateDetails(
                        question.label, _incomTextController.text, type, null),
                  },
                _focusNode.unfocus(),
              },
              onChanged: (value) =>
                  {_incomTextController.text = formatNumberWithCommas(value)},
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(10),
                hintText: type,
                label: Text(
                  question.label.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black)),
              ),
            ),
          ),
        ]);
      case label:
        return GestureDetector(
          onTap: () {
            if (_incomTextController.text.isNotEmpty &&
                details.length > provider.selectedIndex) {
              provider.updateDetails(
                  question.label, currQues.label, type, null);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: details.length > provider.selectedIndex &&
                          details.isNotEmpty
                      ? details[provider.selectedIndex]
                              .value
                              .contains(currQues.label)
                          ? Colors.orange
                          : Colors.black
                      : Colors.black,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: details.length > provider.selectedIndex &&
                            details.isNotEmpty
                        ? details[provider.selectedIndex]
                                .value
                                .contains(currQues.label)
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      if (details.indexWhere(
                              (elem) => elem.label == question.label) !=
                          -1) {
                        provider.updateDetails(
                            question.label, currQues.label, type, null);
                      }
                    },
                    activeColor: Colors.orange,
                  ),
                  Text(
                    "${currQues.label}",
                    style: TextStyle(
                        color: details.length > provider.selectedIndex &&
                                details.isNotEmpty
                            ? details[provider.selectedIndex]
                                    .value
                                    .contains(currQues.label)
                                ? Colors.orange
                                : Colors.black
                            : Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      case singleSelect:
        return Column(children: [
          Text(
            currQues.label ?? "",
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w600),
          ),
          Column(
            children: List.generate(currQues.options!.length, (index) {
              dynamic currValue = currQues.options![index].value;
              return GestureDetector(
                onTap: () {
                  provider.updateDetails(
                      question.label, currValue, type, currQues.label);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: details.length > provider.selectedIndex &&
                                details.isNotEmpty
                            ? details[provider.selectedIndex]
                                    .value
                                    .contains(currValue)
                                ? Colors.orange
                                : Colors.black
                            : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: details.length > provider.selectedIndex &&
                                  details.isNotEmpty
                              ? details[provider.selectedIndex]
                                      .value
                                      .contains(currValue)
                                  ? true
                                  : false
                              : false,
                          onChanged: (value) {
                            provider.updateDetails(question.label, currValue,
                                type, currQues.label);
                          },
                          activeColor: Colors.orange,
                        ),
                        Text(
                          currValue,
                          style: TextStyle(
                              color: details.length > provider.selectedIndex &&
                                      details.isNotEmpty
                                  ? details[provider.selectedIndex]
                                          .value
                                          .contains(currValue)
                                      ? Colors.orange
                                      : Colors.black
                                  : Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          )
        ]);
      default:
        return const Text('data');
    }
  }
}
