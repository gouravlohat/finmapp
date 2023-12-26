import 'dart:async';
import 'dart:convert';

import 'package:finmapp/model/loanJson.dart';
import 'package:finmapp/types/questionTypes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuestionProvider with ChangeNotifier {
  // Intialize Variables
  int selectedIndex = 0;
  int length = 0;
  LoanQuestionnaire? loanTemplate;
  List<Question>? questions = [];
  List<Detail> details = [];
  bool isDataLoaded = false;
  String typeOFLoan = "";

// Set length of question or pages
  setLength() {
    length = questions!.length;
    notifyListeners();
  }

// Load Loan Template
  FutureOr<LoanQuestionnaire> loadData() async {
    try {
      await rootBundle.loadString('data/data.json').then((value) => {
            loanTemplate = LoanQuestionnaire.fromJson(jsonDecode(value)),
            loanTemplate!.fields!.forEach((e) => questions!.add(e)),
            setLength(),
            isDataLoaded = true,
          });
      notifyListeners();
      return loanTemplate as LoanQuestionnaire;
    } catch (e) {
      isDataLoaded = false;
      Exception(e);
      notifyListeners();
      rethrow;
    }
  }

// Change Question or page
  void updateIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  // Update details
  void updateDetails(label, value, type, finder) {
    final existingDetailIndex =
        details.indexWhere((elem) => elem.label == label);

    final existingDetail = details.firstWhere((elem) => elem.label == label,
        orElse: () => Detail(label: label, value: value));

    if (existingDetailIndex != -1) {
      // If the label already exists in details
      if (type == singleSelect || type == singleChoiceSelector) {
        // If the type is singleSelect, replace the existing value
        details[existingDetailIndex].value = value;
      } else if (type == section) {
        // If the type is section, toggle the value
        if (details[existingDetailIndex].value.contains(value)) {
          // If the value exists, remove it
          details[existingDetailIndex].value.remove(value);
        } else {
          // If the value doesn't exist, add it

          dynamic matchedOption;
          if (finder != null && details[selectedIndex].value.length > 0) {
            matchedOption = (questions![selectedIndex]
                .schema!
                .fields!
                .firstWhere((element) => element.schema!.label == finder));
            if (matchedOption != null) {
              matchedOption = (matchedOption as Question)
                  .schema!
                  .options!
                  .firstWhere(
                    (element) =>
                        details[selectedIndex].value.contains(element.value),
                    orElse: () => Option(),
                  );
            }
          }

          if (questions![selectedIndex].schema!.fields!.length >
                      details[selectedIndex].value.length &&
                  matchedOption == null ||
              matchedOption?.value == null) {
            details[selectedIndex].value.add(value);
          } else {
            details[selectedIndex].value = [value];
          }
        }
      }
    } else {
      // If the label does not exist in details
      if (type == singleSelect || type == singleChoiceSelector) {
        // If the type is singleSelect, add a new Detail
        details.add(Detail(label: label, value: value));
      } else if (type == section) {
        // If the type is section, add a new Detail with a list for multiple values
        details.add(Detail(label: label, value: [value]));
      }
    }

    if (existingDetailIndex != -1 &&
        questions![0].schema != null &&
        questions![0].schema!.label != null &&
        label.toLowerCase() == questions![0].schema!.label!.toLowerCase()) {
      typeOFLoan = existingDetail.value.toString();
      details.clear();
      details.add(Detail(label: label, value: value));
      questions!.clear();

      for (int i = 0; i < loanTemplate!.fields!.length; i++) {
        Question? question = loanTemplate?.fields![i];
        final schema = question!.schema;
        if (schema != null && schema.hidden != false) {
          if (schema.hidden != null &&
              schema.hidden!.contains('typeOFLoan !==')) {
            typeOFLoan.toLowerCase().contains("balance transfer")
                ? questions!.add(question)
                : null;
          } else {
            schema.hidden = schema.hidden ?? false;
            questions!.add(question);
          }
        } else {
          questions!.add(question);
        }
      }
      setLength();
    }

    notifyListeners();
  }

  // Get provider States
  get getDetails => details;
  get getIndex => selectedIndex;
  get getTemplate => loanTemplate;
  get getType => typeOFLoan;
}
