
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


// CarouselSlider 
class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({
    super.key,
    required this.myItems,
    required this.withIndicator,
    this.height,
    this.duration,
    this.aspectRatio
  });

  final List<Widget>? myItems;
  final bool? withIndicator ;
  final double? height;
  final int? duration;
  final double? aspectRatio;

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {


  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Stack(
        children: [
          Container(
              child: CarouselSlider(
                options: CarouselOptions(
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 2500),
                    enlargeCenterPage: false,
                    height: 250,
                    onPageChanged: (index,reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    }),
                items: widget.myItems?.map((item) => item)
                    .toList(),
              )),

          Container(
            width: double.infinity,
            height: 250,
            color: Colors.black.withOpacity(0.5), // تغيير القيمة للتحكم في شدة التعتيم
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Visibility(
                visible: widget.withIndicator!,
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
                  count: widget.myItems!.length,
                  effect: const WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: mainColor ,
                    paintStyle: PaintingStyle.fill,


                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//CustomSwitch
class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    required this.payOnDeliverySetValue,
  });
  final Function payOnDeliverySetValue;
  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
          widget.payOnDeliverySetValue(_isOn);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 55.0,
        height: 20,
        decoration: BoxDecoration(
          color: _isOn ? mainColor.withOpacity(0.4) : Colors.grey,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: _isOn ? EdgeInsets.only(right: 8) : EdgeInsets.only(left: 5),
              child: Text(
                _isOn ? "نعم" : "لا",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                ),
              ),
            ),
            Align(
              alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 16.0,
                height: 16.0,
                margin: EdgeInsets.symmetric(horizontal: 3,vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//button 1
class CustomInputWithIcon extends StatelessWidget {
  const CustomInputWithIcon(
      {
        super.key,
        this.width = double.infinity,
        this.textFontSize = 16,
        this.controller,
        required this.validatorFunc,
        required this.icon,
        required this.hintText,
        required this.backgroundColor,
        required this.iconColor,
        required this.iconBackgroundColor,
        required this.borderColor,
        required this.keyboardType,

      }
      );
  final double width;
  final double textFontSize;
  final IconData icon;
  final String hintText;
  final Color backgroundColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color borderColor;
  final dynamic keyboardType;
  final dynamic controller;
  final FormFieldValidator<String> validatorFunc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textDirection: TextDirection.rtl,
          textAlignVertical: TextAlignVertical.center,
          style:  TextStyle(fontSize: textFontSize,),
          decoration: InputDecoration(

            filled: true,
            fillColor: backgroundColor,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: iconBackgroundColor,

                ),
                child:
                Icon(
              icon,
              color: iconColor,
            ),
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.3)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: borderColor ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.red),

            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:  BorderSide(color: borderColor,width: 2),
            ),
            focusedErrorBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.red,width: 2),
            ),
            contentPadding:const EdgeInsets.only(left: 0.0),
          ),
         validator: validatorFunc,

        ),
      ),
    );
  }
}
//button 2
class CustomInputWithIconTow extends StatefulWidget {
  const CustomInputWithIconTow(
      {
        super.key,
        this.width = double.infinity,
        this.maxLines = 1,
        this.minLines = 1,
        this.textFontSize = 16,
        this.padding = 10,
        required this.validFunc,
        required this.topLeftIcon,
        required this.icon,
        required this.hintText,
        required this.backgroundColor,
        required this.iconColor,
        required this.borderColor,
        required this.keyboardType,
        required this.controller,
      }
      );
  final bool topLeftIcon;
  final double width;
  final int maxLines;
  final int minLines;
  final double textFontSize;
  final IconData icon;
  final String hintText;
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final dynamic keyboardType;
  final double padding;
  final dynamic validFunc;
  final TextEditingController controller;

  @override
  State<CustomInputWithIconTow> createState() => _CustomInputWithIconTowState();
}

class _CustomInputWithIconTowState extends State<CustomInputWithIconTow> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: widget.width,
        child: Stack(
          children: [
            TextFormField(
              controller: widget.controller,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              textAlignVertical: TextAlignVertical.center,
              textDirection: TextDirection.rtl,
              style:  TextStyle(fontSize: widget.textFontSize,),
              decoration: InputDecoration(

                filled: true,
                fillColor: widget.backgroundColor,
                prefixIcon:  Visibility(visible: !widget.topLeftIcon,child: Icon(widget.icon,color:widget.iconColor,)),
                hintText: widget.hintText,
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.3)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: widget.borderColor ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red),

                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:  BorderSide(color: widget.borderColor,width: 2),
                ),
                focusedErrorBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red,width: 2),
                ),
                contentPadding:const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
              ),
              validator: widget.validFunc,


            ),
            Visibility(
              visible: widget.topLeftIcon,
                child: Positioned(
                  left: 8,
                  top: 8,
                  child: Icon(
                    widget.icon,

                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}

//Custom dropDown menu

class CustomDropDown extends StatefulWidget {
  const CustomDropDown(
      {
        super.key,
        required this.onTapFunc,
        this.borderColor = Colors.grey,
        this.width = double.infinity,
        required this.items,
        required this.initialValue,

      });
final List<Map> items;
final String initialValue;
final Function onTapFunc;
final Color borderColor ;
final double width;

@override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String selectOne = "";
  @override
  Widget build(BuildContext context) {

    return  PopupMenuButton(
        child: Container(
          width: widget.width,
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1,color: widget.borderColor)
          ),
          child: selectOne == "" ? Text(
            widget.initialValue,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey
            ),
          ) :Text(
            selectOne,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.grey
            ),
          )
        ),
        offset: Offset(1, 40.0),
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        itemBuilder: (context) {
          return <PopupMenuEntry<Widget>>[
            PopupMenuItem<Widget>(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Scrollbar(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 2),

                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final trans = widget.items[index]['valueName'];
                      return ListTile(

                        title: Text(
                          trans.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,

                          ),
                        ),

                        onTap: () {
                          setState(() {
                             selectOne = widget.items[index]['valueName'];
                             widget.onTapFunc(selectOne,widget.items[index]['valueId'] ?? widget.items[index]['valueId'],widget.items[index]['valuePhoneNumber'] ?? widget.items[index]['driverPhoneNumber'] );
                             Navigator.pop(context);
                          });
                        },
                      );
                    },
                  ),
                ),
                height: widget.items.length < 4 ? (70 * widget.items.length).toDouble() : 250,
                width: 500,
              ),
            )
          ];
        });
    ;
  }
}




// selectDate
Future<dynamic> selectDate(context,primaryColor)async {
  DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    builder:(context,child)=> child != null ? Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.dark(
            primary: primaryColor,
            onPrimary: Colors.black,
            onPrimaryContainer: Colors.green,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child
    )
        : const SizedBox(),
  );


  return picked;
}