/*
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() ==>_ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:SafeArea (
        child: Column(
        children:[
        //app bar
        Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            //name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              'Profile',
              style: TextStyle(
                fontWeight:FontWeight.bold,
                fontSize:18,
                ),
              ),
              SizedBox(height: 8),
            Text(
              'Manage your personal information',
              //style: TextStyle(fontSize:20),
              style: TextStyle(
                fontWeight:FontWeight.bold,
                fontSize:24,
                ),
              ),
              ],
            ),

            //profile photo
            Container(
              padding:EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
                ),
              child:Icon(
                Icons.person,
                color:Colors.white,
                ),
              ),
          ],
          ),
          ),

          SizedBox(height:25),
        //manage your personal information
        //card
       Padding(
         padding: const EdgeInsets.symmetric(horizontal:25.0),
       child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red[100],
          borderRadius: BorderRadius.circular(12),
          ),

          child: TextField(
            decoration:InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              hintText: "how can we help you?",

            )

            SizedBox(height: 25),

            Container(
              height:80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryCard(
                    categoryName: 'your goals',
                    iconImagePath: 'lib/icons/yourgoalpp.png',
                  ),
                  CategoryCard(
                    categoryName:'How Your Zones Are Calculated',
                  ),
                  CategoryCard(
                    categoryName:'Data & Privacy',
                  ),
                  /*
                  CategoryCard(
                    categoryName:'About Elaros',
                  ),*/
                  
                    ],
                    ),
                      
                  ),


                ],
              ),
            ),


          )
          child: Row(children: [

          Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:16,
                ),
              ),
              SizedBox(height: 8),
                Text(
                  'fill out the form below',
                  style: TextStyle(
                    fontSize: 14,
                   ),
                  
                  ),

                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('get started'),
                    ),
                )
             ],

             ),
          )
            //alex/condition
          ]),
        ),
       ),

        //form

        //information about
      ]
      )
    );
  }
}




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
*/