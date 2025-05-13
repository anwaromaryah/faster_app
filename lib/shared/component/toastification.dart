import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void customeToastification(context,{
  required title,
  required desc,
  required icon,
  required backgroundColor
}){
  toastification.show(
    context: context, // optional if you use ToastificationWrapper
    type: ToastificationType.success,
    style: ToastificationStyle.flat,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text('${title}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
    description: RichText(text:  TextSpan(text: '${desc}',style: TextStyle(fontSize: 12))),
    alignment: Alignment.bottomRight,
    direction: TextDirection.rtl,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    icon: icon,
    showIcon: true, // show or hide the icon
    primaryColor: backgroundColor,
    backgroundColor: backgroundColor,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}
