
import 'package:firstproject001/layout/company_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/company_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CompanyMainLayout extends StatelessWidget {
  const CompanyMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CompanyLayoutCubit()..getUserInformation()..getAllDrivers()..durationMethod(),
        child: BlocConsumer<CompanyLayoutCubit,CompanyLayoutStates>(
            listener: (context,state)=>{},
          builder: (context,state) {
            CompanyLayoutCubit cubit = CompanyLayoutCubit.get(context);

            return ConditionalBuilder(
                condition:state is CompanyLayoutStatesInitial || state is GetCompanyInformationProcess || state is GetAllDriversProcess || state is CompanyDurationMethodProcess ,
                builder: (context) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: companyMainColor,
                  child: Container(
                    child:const Center(
                      child: SpinKitDoubleBounce(
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                fallback: (context) => Scaffold(
                  body: Stack(
                    children: [
                      cubit.companyLayoutScreens[cubit.bottomNavigationBarIndex],
                    ],
                  ),
                  bottomNavigationBar: Directionality(
                    textDirection: TextDirection.rtl,
                    child: BottomNavigationBar(
                      currentIndex: cubit.bottomNavigationBarIndex,
                      selectedItemColor: companyMainColor,
                      showSelectedLabels: true,
                      onTap: (index){
                        cubit.changeBottomNavigationBarIndex(index);
                      },
                      items: [
                        BottomNavigationBarItem(
                            icon: Image.asset('icons/home.png',width: 25,height: 25,),
                            label: "الرئيسية"
                        ),
                        BottomNavigationBarItem(
                            icon: Image.asset('icons/logistic.png',width: 25,height: 25,),
                            label: "السائقين"

                        ),
                        BottomNavigationBarItem(
                            icon: Image.asset('icons/order-history.png',width: 25,height: 25,),
                            label: "السجل"

                        ),
                        BottomNavigationBarItem(
                          icon: Image.asset('icons/settings.png',width: 25,height: 25,),
                          label: "الحساب",
                        ),

                      ],
                    ),
                  ),

                )
            );
          },

        ),
    );
  }
}
