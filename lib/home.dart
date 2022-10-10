import 'dart:convert';
import 'package:example_khanbank/colors.dart';
import 'package:example_khanbank/example.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  int payingloan = 0;
  List<Qpay> qpaylist = [];
  List<String> qpaystring = [];
  late List data;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 245, 248, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Жишээ",
          style: TextStyle(
              fontFamily: "Ubuntu",
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: primarycolor),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: secondarycolor,
          ),
        ),
        elevation: 0.0,
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onSurface: Colors.white,
                elevation: 0.0,
                padding: EdgeInsets.fromLTRB(15,15, 15, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                primary: Colors.white,
                shadowColor: Colors.white
              ),
              onPressed: () async {
                var url = Uri.parse("khanbank://q?qPay_QRcode=0002010102121531279404962794049600221010074292627180014A00000084300015204739953034965402905802MN5906TAPPAY6011Ulaanbaatar62500107120qpay0510testvulcan0721SzKOh65Nqkf1BQYN6_j4p78159130283055914667902228002016304EB8D");
               if(await canLaunchUrl(url)){
                 await launchUrl(url);
               }else{
                 throw "Could not launch $url";
               }
                },
              child: Row(
                children: [
                  SizedBox(width: 15,),
                  Expanded(child: Text(
                    'Example', style: TextStyle(
                    fontFamily: "Ubuntu",
                    color: primarycolor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontStyle: FontStyle.normal,

                  ),
                  )),
                  Icon(
                    Icons.arrow_forward_sharp,
                    color: secondarycolor,
                  ),
                ],
              ),),
          ],
        ),
      ),

    );
  }

  Future<List<Qpay>> internet() async {
    setState(() {
      qpaylist.clear();
    });
    http.post(
      Uri.parse("http://192.168.1.110:3000/qpay/invoice"),
      headers: {
        'Content-Type': 'application/json',
        //'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRfaWQiOiJjZTNlMzZiNC0wMDJiLTQxMDYtYmVmMy1hODQyZDRjYThlM2QiLCJzZXNzaW9uX2lkIjoiZWJMU29hLVhxQlE3cUNidWNDc2tKSUMwR0lldWxFVFMiLCJpYXQiOjE2NjQ5NTk5NzQsImV4cCI6MzMzMDAwNjM0OH0.Mz5RdVj2ZP9mIdFekE3DmWD3XmOYdJRhnEstt9brdwI'
      },
      body: jsonEncode({
        //'amount': payingloan / 0.99,
        'amount': 100 / 0.99,
      }),
    ).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("error");
      }
      var listData = json.decode(response.body);
      var data = listData['urls'];
      if(data != null) {
        for(Map respdata in data ) {
         // Qpay qpay= Qpay(respdata['description'], respdata['logo'], respdata['link'],);
          Qpay qpay = Qpay(description: respdata['description'], logo: respdata['logo'], link: respdata['link']);
          qpaylist.add(qpay);
          qpaystring.addAll([
            respdata['description'],
            respdata['logo'],
            respdata['link']
          ]);
        }
        //print(qpaylist);
        setState(() {

        });
      }
    });
    return qpaylist;
  }
}
