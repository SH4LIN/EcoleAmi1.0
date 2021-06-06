import 'package:contactus/contactus.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/material.dart';

class Contactus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar("Contact Us"),
        bottomNavigationBar: ContactUsBottomAppBar(
          companyName: '\nJaysheel Modi \nShalin Shah \nKushangee Solanki\n',
          textColor: Colors.white,
          backgroundColor: Colors.teal.shade300,
          fontSize: 12,
          email: 'ecoleami.project@gmail.com',
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          child: new ContactUs(
            cardColor: Colors.white,
            textColor: Colors.teal.shade900,
            logo: AssetImage(
              'images/logo.png',
            ),
            companyName: 'Ècoleami',
            companyColor: Colors.black,
            tagLine: "Empowering you with tech",
            taglineColor: Colors.grey,
            instagram: 'jaysheel_.08',
            email: 'ecoleami.project@gmail.com',
            githubUserName: 'SH4LIN',
            phoneNumber: '+918320224014',
          ),
        ));
  }
}
