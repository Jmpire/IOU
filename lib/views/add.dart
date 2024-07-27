import 'package:flutter/material.dart';
import 'package:projectx/sqflite/handler.dart';
import 'package:projectx/utils/datetime.dart';
import 'package:projectx/utils/styles.dart';
import 'package:projectx/values/app_colors.dart';

class Add extends StatefulWidget {
  static String title = 'null';
  const Add({super.key});
  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  // toggle switch
  bool isSwitched = false;

  void _toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
    });
  }

  // addStartTime
  void addStartTime(int key) {
    showDateTimePicker(context: context).then((value) {
      if (value != null) {
        if (key == 0) {
          
          startController.text = value.toString().substring(0, 19);
        } else {
        
          deadlineController.text = value.toString().substring(0, 19);
        }
      }

      setState(() {});
    });
  }

  // save info
  void addInfo(
      String title,
      String name,
      int contact,
      String email,
      String description,
      double amount,
      String startdate,
      String deadline,
      String notes) {
    insert(title, name, contact, email, description, amount, startdate,
        deadline, notes);
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            Add.title,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.background, surfaceTintColor: AppColors.appBackgroundColor),
      body: Container(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // name
                getTextfield(TextInputType.name, 'Name*', nameController, true),
                // contact details
                getTextfield(TextInputType.number, 'Contact Number',
                    contactController, false),
                // email
                getTextfield(TextInputType.emailAddress, 'E-mail',
                    emailController, false),
                // description
                getTextfield(TextInputType.multiline, 'Description*',
                    descriptionController, false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      ' ${descriptionController.text.length.toString()}/30',
                      style: hintText,
                    )
                  ],
                ),

                // amount
                getTextfield(
                    TextInputType.number, 'Amount*', amountController, false),
                // startdate
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          addStartTime(0);
                        },
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.grey,
                        )),
                    Expanded(
                        child: getTextfield(TextInputType.none, 'Start Date*',
                            startController, false))
                  ],
                ),
                SizedBox(
                    height: 70.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Would you like to set a due date?', style: TextStyle(color: Colors.grey),),
                        Switch(
                          value: isSwitched,
                          onChanged: _toggleSwitch,
                          activeTrackColor: Colors.orangeAccent,
                          activeColor: AppColors.orange,
                        ),
                      ],
                    )),
                isSwitched == true
                    ? Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    addStartTime(1);
                                  },
                                  icon: const Icon(
                                    Icons.calendar_month,
                                    color: Colors.grey,
                                  )),
                              Expanded(
                                  child: getTextfield(TextInputType.none,
                                      'Deadline*', deadlineController, false))
                            ],
                          ),
                          SizedBox(
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Reminders', style: TextStyle(color: AppColors.blackText),),
                                  addButton()
                                ],
                              )),
                          const Divider(color: Colors.grey, thickness: 0.1)
                        ],
                      )
                    : Container(),
                getTextfield(
                    TextInputType.multiline, 'Notes', notesController, false),
                saveButton()
              ],
            ),
          )),
    );
  }

  Widget getTextfield(TextInputType type, String text,
      TextEditingController controller, bool icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      
        child: TextField(
          style: TextStyle(color: AppColors.blackText),
            onTap: () {
              if (text == "Start Date*" || text == "Deadline*") {
                switch (text) {
                  case 'Start Date*':
                    addStartTime(0);
                    break;
                  default:
                    addStartTime(1);
                    break;
                }
              }
            },
            keyboardType: type,
            maxLines: text == 'Notes' ? 5 : 1,
            onChanged: (value) {
              setState(() {});
            },
            controller: controller,
            decoration: InputDecoration(
              
                constraints: const BoxConstraints(minHeight: 70.0),
                labelText: text,
                labelStyle: hintText,
                
                suffixIcon: icon == true
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.contact_page_outlined, color: Colors.grey,))
                    : const SizedBox(
                        width: 0.0,
                        height: 70,
                      ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1)))));
  }

  // save button
  Widget saveButton() {
    return Container(
        height: 70.0,
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.only(top: 40.0),
        color: AppColors.appBackgroundColor,
        child: ElevatedButton(
            style: const ButtonStyle().copyWith(
              backgroundColor: MaterialStateProperty.all(AppColors.pieDark),
              minimumSize: MaterialStateProperty.all<Size>(
                const Size(double.infinity, 45),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            onPressed: () {
              try {
                if (nameController.text != '' &&
                    descriptionController.text != '' &&
                    startController.text != '' &&
                    amountController.text != '') {
                  addInfo(
                      Add.title == 'Add UOMe' ? 'UOMe' : 'IOU',
                      nameController.text,
                       int.parse(contactController.text),
                      emailController.text,
                      descriptionController.text,
                      double.parse(amountController.text),
                      startController.text,
                      deadlineController.text != ''? deadlineController.text: 'No Deadline',
                      notesController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fill in all required fields"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
             //
              }
            },
            child: Text('Save', style: TextStyle(color: AppColors.blackText))));
  }
}

// add button
Widget addButton() {
  return ElevatedButton(
      style: const ButtonStyle().copyWith(
        backgroundColor: MaterialStateProperty.all(AppColors.pieDark),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(50, 45),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      onPressed: () {},
      child: Text('Add', style: TextStyle(color: AppColors.blackText)));
}
