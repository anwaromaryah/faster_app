import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/client_modules/client_order_information/presentaion/client_recipient_info.dart';
import 'package:firstproject001/shared/component/components.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientCompanyInfo extends StatefulWidget {
  const ClientCompanyInfo(
      {
        super.key,
        required this.companyInfo
      }
      );
final Map? companyInfo ;

  @override
  State<ClientCompanyInfo> createState() => _ClientCompanyInfoState();
}

class _ClientCompanyInfoState extends State<ClientCompanyInfo> {

  bool favoriteCompany = false;

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
        listener: (context,state)=>{},
      builder: (context,state){
          ClientLayoutCubit cubit = ClientLayoutCubit.get(context);
          return Scaffold(
            body: Stack(
              children: [
                CarouselSliderWidget(
                  myItems: [
                    //first image
                    Image(image: widget.companyInfo!["carouselImages"]["firstImage"].isEmpty ? AssetImage("images/carousel.jpg") : NetworkImage("${widget.companyInfo!["carouselImages"]["firstImage"]}"),
                      fit: BoxFit.cover,height: 600,width: double.infinity,),
                    //second image
                    Image(image: widget.companyInfo!["carouselImages"]["secondImage"].isEmpty ? AssetImage("images/carousel.jpg") : NetworkImage("${widget.companyInfo!["carouselImages"]["secondImage"]}"),
                      fit: BoxFit.cover,height: 600,width: double.infinity,),
                    //third image
                    Image(image: widget.companyInfo!["carouselImages"]["thirdImage"].isEmpty ? AssetImage("images/carousel.jpg") : NetworkImage("${widget.companyInfo!["carouselImages"]["thirdImage"]}"),
                      fit: BoxFit.cover,height: 600,width: double.infinity,),
                  ],
                  withIndicator: true,
                  height: 350,
                ),
                Column(
                  children: [
                    const SizedBox(height: 220),
                    Expanded(
                      child:  Container(
                        padding: const EdgeInsets.only(top: 18,bottom: 10,right: 18,left: 18),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:  BorderRadius.only(
                            topLeft:  Radius.circular(24),
                            topRight:  Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "معلومات عن الشركة",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),

                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    cubit.setFavoriteCompany(companyId: widget.companyInfo!["companyId"]);

                                  },
                                    child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor:cubit.clientInfo["favoriteCompanies"].contains(widget.companyInfo!["companyId"]) ? Colors.redAccent : Colors.black.withOpacity(0.04),
                                        child: Image.asset(
                                          cubit.clientInfo["favoriteCompanies"].contains(widget.companyInfo!["companyId"]) ? "icons/white-heart  copy.png" : "icons/black-heart .png",
                                          width: 20,height: 20,))
                                ),
                                Spacer(flex:widget.companyInfo!['companyName'].length <18 ? 9 : 1 ,),
                                Flexible(
                                  flex: 8,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      widget.companyInfo != null ? widget.companyInfo!['companyName'] : "",
                                      maxLines: 1,
                                      style:const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor: mainColor,
                                  child: ConditionalBuilder(
                                      condition: widget.companyInfo!.isEmpty || widget.companyInfo!['profilePic'].isEmpty ,
                                      builder: (context)=> CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey.withOpacity(0.2),
                                        backgroundImage: AssetImage("images/default_business_picture.png"),
                                      ),
                                      fallback: (context)=> CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey.withOpacity(0.2),
                                        backgroundImage: NetworkImage("${widget.companyInfo!["profilePic"]}"),
                                      )
                                  ),
                                ),

                              ],
                            ),

                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                  widget.companyInfo != null ? widget.companyInfo!['address'] : "",
                                    maxLines: 1,
                                    style:const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4,),
                                Image.asset("icons/market-location.png",width: 20,height: 20,)
                              ],
                            ),

                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  widget.companyInfo != null ? widget.companyInfo!['companyPhoneNumber'] : "",
                                  style:const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(width: 4,),
                                Image.asset("icons/phone.png",width: 20,height: 20,)
                              ],
                            ),

                            const SizedBox(height: 10,),
                            Flexible(
                              child: Text(
                                widget.companyInfo != null ? widget.companyInfo!['description'] : "",
                                maxLines: 4,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style:const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ),

                            const SizedBox(height: 15,),
                            const Text(
                              "السائقين",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 10,),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: ConditionalBuilder(
                                    condition: cubit.drivers.isNotEmpty,
                                    builder: (context) => ListView.separated(
                                        padding: EdgeInsets.all(0),
                                        itemBuilder: (context,index)=> Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    cubit.drivers.isNotEmpty ? cubit.drivers[index]['driverName'] : "",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14
                                                    ),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    cubit.drivers.isNotEmpty ? cubit.drivers[index]['driverPhoneNumber'] : "",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              CircleAvatar(
                                                radius: 27,
                                                backgroundColor: mainColor,
                                                child: ConditionalBuilder(
                                                    condition: cubit.drivers[index]["profilePic"].isEmpty,
                                                    builder: (context)=>CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: Colors.grey.withOpacity(0.2),
                                                      child: Center(
                                                        child: Image.asset("icons/driver.png",width: 22,height: 22,),
                                                      ),
                                                    ),
                                                    fallback: (context)=>CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: Colors.grey.withOpacity(0.2),
                                                      backgroundImage: NetworkImage("${cubit.drivers[index]["profilePic"]}"),
                                                    )
                                                ),
                                              ),

                                            ],

                                          ),
                                        ),
                                        separatorBuilder: (context,index)=>const SizedBox(height: 5,),
                                        itemCount: cubit.drivers.isNotEmpty ? cubit.drivers.length : 0
                                    ),
                                    fallback: (context) => Center(
                                      child: Text(
                                        "لا يوجد سائقين في الوقت الحالي",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16
                                        ),
                                      ),
                                    )
                                ),

                              ),
                            ),
                            const SizedBox(height: 15,),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (newContext) => BlocProvider.value(
                                          value: BlocProvider.of<ClientLayoutCubit>(context),
                                          child: ClientRecipientInfo(companyInfo: widget.companyInfo,)
                                      ),
                                    )
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                                minimumSize:  Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child:  Text('اختيار'),
                            )


                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: 45,
                    left: 14,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: mainColor,
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 20,)),
                    )
                )
              ],
            ),

          );
      }

    );
  }
}
