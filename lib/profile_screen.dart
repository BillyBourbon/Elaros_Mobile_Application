import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const profilescreen ({super.key});
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      background colour: const color (0xFFF2F2F2),
      body: SingleChildScrollView(
        child: column(
          children: [

            container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom:40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
              begin: Alignment.topcenter,
              end: Alignment.bottomcenter,
                )
                )
                child: const column(
                  children: [
                    Text(
                      "profile",
                      style: TextStyle(
                        color: colors.white,
                        fontsize: 28,
                        fontWeight: fontWeight.bold,
                      )
                    )
                    SizedBox (height:8),
                    Text(
                      "manage your personal information",
                      style: TextStyle
                      color: Colors.white70,
                      fontsize: 16,
                    )
                    
                    )
                  ]
                )
              )
                  Const SizedBox(height:20)

                  //profile card 

                  padding (
                    const EdgeInsets.all(20),
                    decoration: Boxdecoration (
                      colors: colors.white;
                      borderRadius: BorderRadius.circular(20),
                      Boxshadow: [
                        boxshadow(
                          color: colors.black.withOpacity(0.1),
                          BlurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ]
                    )

                    child: Column(
                      children: [

                        row(
                          children:[

                            container( 
                              width:70,
                              height:70,
                              decoration: const BoxDecoration(
                                color: color (0xFFD32F2F),
                                shape: BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size:35,
                              ),
                            ),
                                 const SizedBox(width:20),

                                 const column(

                                  crossAxisAlignment: crossAxisAlignment.start,
                                 )
                          ]
                        )
                      ]
                    )
                  )

            )
          ]
        )
      )
  }
}