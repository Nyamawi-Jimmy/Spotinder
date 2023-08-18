import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Dimensions/dimensions.dart';
import '../main.dart';
import '../widget/auth_model.dart';
import '../widget/button.dart';
import '../widget/dio_prov.dart';
import '../widget/gender.dart';


class Boarding extends StatefulWidget {
  const Boarding({Key? key}) : super(key: key);

  @override
  State<Boarding> createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  Gender? selectedGender;
  CalendarFormat _format=CalendarFormat.month;
  DateTime currentDate=DateTime.now();
  String? selectedDate;

  datePicker(context)async{
    DateTime? userSelectedDate=await
    showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1800),
        lastDate: DateTime.now()
    );
    if (userSelectedDate==null){
      return;
    }else{
      setState(() {
        currentDate=userSelectedDate;
        selectedDate='${currentDate.day}/${currentDate.month}/${currentDate.year}';
        print('date    $selectedDate');
      });
    }
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isLoading = false;
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    Dimensions().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Dimensions.spacesmall,
              Text(
                "Complete Setting Up Your Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "First Name",
                  labelText: "First Name",
                  labelStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.person_2),
                  prefixIconColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusColor: Colors.white,
                ),
              ),
              Dimensions.spacesmall,
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Last Name",
                  labelText: "Last Name",
                  labelStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure == true
                        ? const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black38,
                    )
                        : const Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusColor: Colors.white,
                ),
              ),
              SizedBox(height: 50,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Select Date of Birth : ${currentDate.day}/${currentDate.month}/${currentDate.year}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                  Dimensions.spacesmall,
                  ElevatedButton(onPressed: (){
                    datePicker(context);
                  }, child:  Text(
                    "Select Date",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),)
                ],
              ),
              SizedBox(height: 30,),
              Text(
                "Select Gender",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GenderButton(
                    text: 'Male',
                    gender: Gender.male,
                    selectedGender: selectedGender,
                    onPressed: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                  ),
                  SizedBox(width: 20),
                  GenderButton(
                    text: 'Female',
                    gender: Gender.female,
                    selectedGender: selectedGender,
                    onPressed: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                  ),
                  SizedBox(width: 20),
                  GenderButton(
                    text: 'Other',
                    gender: Gender.other,
                    selectedGender: selectedGender,
                    onPressed: () {
                      setState(() {
                        selectedGender = Gender.other;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Selected Gender: ${selectedGender?.toString().split('.').last ?? 'None'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30,),
              Center(
                child: Consumer<AuthModel>(
                  builder: (context, auth, child){
                    return Button(
                        onPressed: () async {
                          //MyApp.navigatorkey.currentState!.pushNamed('dashboard');
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          final tokenValue=prefs.getString('access_token')??'';

                          if(tokenValue.isNotEmpty && tokenValue !=''){
                            print("my token value is $tokenValue");
                            //Get userdata

                            final response = await DioProvider().getAlbum(tokenValue);
                            print("my response is $response");
                            if(response!=null){
                              setState(() {
                                Map <String,dynamic> appointment={};
                                final user =  json.decode(response);
                                print(user);
                                //check todays appointment if there is any return for today
                                auth.loginSuccess();
                                MyApp.navigatorkey.currentState!.pushNamed('/dashboard');
                              });
                            }
                          }
                        },
                        title: "Submit",
                        width: 180,
                        disable: false);
                  },

                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}