// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  //region countryCodes
  List<String> countryCodesNumbers = [
    "+93"
        "+355"
        "+213"
        "+1-684"
        "+376"
        "+244"
        "+1-264"
        "+672"
        "+1-268"
        "+54"
        "+374"
        "+297"
        "+61"
        "+43"
        "+994"
        "+1-242"
        "+973"
        "+880"
        "+1-246"
        "+375"
        "+32"
        "+501"
        "+229"
        "+1-441"
        "+975"
        "+591"
        "+387"
        "+267"
        "+55"
        "+246"
        "+1-284"
        "+673"
        "+359"
        "+226"
        "+257"
        "+855"
        "+237"
        "+238"
        "+1-345"
        "+236"
        "+235"
        "+56"
        "+86"
        "+61"
        "+61"
        "+57"
        "+269"
        "+682"
        "+506"
        "+385"
        "+53"
        "+599"
        "+357"
        "+420"
        "+243"
        "+45"
        "+253"
        "+1-767"
        "+1-809, 1-829, 1-849"
        "+670"
        "+593"
        "+20"
        "+503"
        "+240"
        "+291"
        "+372"
        "+251"
        "+500"
        "+298"
        "+679"
        "+358"
        "+33"
        "+689"
        "+241"
        "+220"
        "+995"
        "+49"
        "+233"
        "+350"
        "+30"
        "+299"
        "+1-473"
        "+1-671"
        "+502"
        "+44-1481"
        "+224"
        "+245"
        "+592"
        "+509"
        "+504"
        "+852"
        "+36"
        "+354"
        "+91"
        "+62"
        "+98"
        "+964"
        "+353"
        "+44-1624"
        "+972"
        "+39"
        "+225"
        "+1-876"
        "+81"
        "+44-1534"
        "+962"
        "+7"
        "+254"
        "+686"
        "+383"
        "+965"
        "+996"
        "+856"
        "+371"
        "+961"
        "+266"
        "+231"
        "+218"
        "+423"
        "+370"
        "+352"
        "+853"
        "+389"
        "+261"
        "+265"
        "+60"
        "+960"
        "+223"
        "+356"
        "+692"
        "+222"
        "+230"
        "+262"
        "+52"
        "+691"
        "+373"
        "+377"
        "+976"
        "+382"
        "+1-664"
        "+212"
        "+258"
        "+95"
        "+264"
        "+674"
        "+977"
        "+31"
        "+599"
        "+687"
        "+64"
        "+505"
        "+227"
        "+234"
        "+683"
        "+850"
        "+1-670"
        "+47"
        "+968"
        "+92"
        "+680"
        "+970"
        "+507"
        "+675"
        "+595"
        "+51"
        "+63"
        "+64"
        "+48"
        "+351"
        "+1-787, 1-939"
        "+974"
        "+242"
        "+262"
        "+40"
        "+7"
        "+250"
        "+590"
        "+290"
        "+1-869"
        "+1-758"
        "+590"
        "+508"
        "+1-784"
        "+685"
        "+378"
        "+239"
        "+966"
        "+221"
        "+381"
        "+248"
        "+232"
        "+65"
        "+1-721"
        "+421"
        "+386"
        "+677"
        "+252"
        "+27"
        "+82"
        "+211"
        "+34"
        "+94"
        "+249"
        "+597"
        "+47"
        "+268"
        "+46"
        "+41"
        "+963"
        "+886"
        "+992"
        "+255"
        "+66"
        "+228"
        "+690"
        "+676"
        "+1-868"
        "+216"
        "+90"
        "+993"
        "+1-649"
        "+688"
        "+1-340"
        "+256"
        "+380"
        "+971"
        "+44"
        "+1"
        "+598"
        "+998"
        "+678"
        "+379"
        "+58"
        "+84"
        "+681"
        "+212"
        "+967"
        "+260"
        "+263"
  ];

  List<String> countryCodes = [
    "Afghanistan (+93)",
    "Albania (+355)",
    "Algeria (+213)",
    "American Samoa (+1-684)",
    "Andorra (+376)",
    "Angola (+244)",
    "Anguilla (+1-264)",
    "Antarctica (+672)",
    "Antigua and Barbuda (+1-268)",
    "Argentina (+54)",
    "Armenia (+374)",
    "Aruba (+297)",
    "Australia (+61)",
    "Austria (+43)",
    "Azerbaijan (+994)",
    "Bahamas (+1-242)",
    "Bahrain (+973)",
    "Bangladesh (+880)",
    "Barbados (+1-246)",
    "Belarus (+375)",
    "Belgium (+32)",
    "Belize (+501)",
    "Benin (+229)",
    "Bermuda (+1-441)",
    "Bhutan (+975)",
    "Bolivia (+591)",
    "Bosnia and Herzegovina (+387)",
    "Botswana (+267)",
    "Brazil (+55)",
    "British Indian Ocean Territory (+246)",
    "British Virgin Islands (+1-284)",
    "Brunei (+673)",
    "Bulgaria (+359)",
    "Burkina Faso (+226)",
    "Burundi (+257)",
    "Cambodia (+855)",
    "Cameroon (+237)",
    "Cape Verde (+238)",
    "Cayman Islands (+1-345)",
    "Central African Republic (+236)",
    "Chad (+235)",
    "Chile (+56)",
    "China (+86)",
    "Christmas Island (+61)",
    "Cocos Islands (+61)",
    "Colombia (+57)",
    "Comoros (+269)",
    "Cook Islands (+682)",
    "Costa Rica (+506)",
    "Croatia (+385)",
    "Cuba (+53)",
    "Curacao (+599)",
    "Cyprus (+357)",
    "Czech Republic (+420)",
    "Democratic Republic of the Congo (+243)",
    "Denmark (+45)",
    "Djibouti (+253)",
    "Dominica (+1-767)",
    "Dominican Republic (+1-809, 1-829, 1-849)",
    "East Timor (+670)",
    "Ecuador (+593)",
    "Egypt (+20)",
    "El Salvador (+503)",
    "Equatorial Guinea (+240)",
    "Eritrea (+291)",
    "Estonia (+372)",
    "Ethiopia (+251)",
    "Falkland Islands (+500)",
    "Faroe Islands (+298)",
    "Fiji (+679)",
    "Finland (+358)",
    "France (+33)",
    "French Polynesia (+689)",
    "Gabon (+241)",
    "Gambia (+220)",
    "Georgia (+995)",
    "Germany (+49)",
    "Ghana (+233)",
    "Gibraltar (+350)",
    "Greece (+30)",
    "Greenland (+299)",
    "Grenada (+1-473)",
    "Guam (+1-671)",
    "Guatemala (+502)",
    "Guernsey (+44-1481)",
    "Guinea (+224)",
    "Guinea-Bissau (+245)",
    "Guyana (+592)",
    "Haiti (+509)",
    "Honduras (+504)",
    "Hong Kong (+852)",
    "Hungary (+36)",
    "Iceland (+354)",
    "India (+91)",
    "Indonesia (+62)",
    "Iran (+98)",
    "Iraq (+964)",
    "Ireland (+353)",
    "Isle of Man (+44-1624)",
    "Israel (+972)",
    "Italy (+39)",
    "Ivory Coast (+225)",
    "Jamaica (+1-876)",
    "Japan (+81)",
    "Jersey (+44-1534)",
    "Jordan (+962)",
    "Kazakhstan (+7)",
    "Kenya (+254)",
    "Kiribati (+686)",
    "Kosovo (+383)",
    "Kuwait (+965)",
    "Kyrgyzstan (+996)",
    "Laos (+856)",
    "Latvia (+371)",
    "Lebanon (+961)",
    "Lesotho (+266)",
    "Liberia (+231)",
    "Libya (+218)",
    "Liechtenstein (+423)",
    "Lithuania (+370)",
    "Luxembourg (+352)",
    "Macau (+853)",
    "Macedonia (+389)",
    "Madagascar (+261)",
    "Malawi (+265)",
    "Malaysia (+60)",
    "Maldives (+960)",
    "Mali (+223)",
    "Malta (+356)",
    "Marshall Islands (+692)",
    "Mauritania (+222)",
    "Mauritius (+230)",
    "Mayotte (+262)",
    "Mexico (+52)",
    "Micronesia (+691)",
    "Moldova (+373)",
    "Monaco (+377)",
    "Mongolia (+976)",
    "Montenegro (+382)",
    "Montserrat (+1-664)",
    "Morocco (+212)",
    "Mozambique (+258)",
    "Myanmar (+95)",
    "Namibia (+264)",
    "Nauru (+674)",
    "Nepal (+977)",
    "Netherlands (+31)",
    "Netherlands Antilles (+599)",
    "New Caledonia (+687)",
    "New Zealand (+64)",
    "Nicaragua (+505)",
    "Niger (+227)",
    "Nigeria (+234)",
    "Niue (+683)",
    "North Korea (+850)",
    "Northern Mariana Islands (+1-670)",
    "Norway (+47)",
    "Oman (+968)",
    "Pakistan (+92)",
    "Palau (+680)",
    "Palestine (+970)",
    "Panama (+507)",
    "Papua New Guinea (+675)",
    "Paraguay (+595)",
    "Peru (+51)",
    "Philippines (+63)",
    "Pitcairn (+64)",
    "Poland (+48)",
    "Portugal (+351)",
    "Puerto Rico (+1-787, 1-939)",
    "Qatar (+974)",
    "Republic of the Congo (+242)",
    "Reunion (+262)",
    "Romania (+40)",
    "Russia (+7)",
    "Rwanda (+250)",
    "Saint Barthelemy (+590)",
    "Saint Helena (+290)",
    "Saint Kitts and Nevis (+1-869)",
    "Saint Lucia (+1-758)",
    "Saint Martin (+590)",
    "Saint Pierre and Miquelon (+508)",
    "Saint Vincent and the Grenadines (+1-784)",
    "Samoa (+685)",
    "San Marino (+378)",
    "Sao Tome and Principe (+239)",
    "Saudi Arabia (+966)",
    "Senegal (+221)",
    "Serbia (+381)",
    "Seychelles (+248)",
    "Sierra Leone (+232)",
    "Singapore (+65)",
    "Sint Maarten (+1-721)",
    "Slovakia (+421)",
    "Slovenia (+386)",
    "Solomon Islands (+677)",
    "Somalia (+252)",
    "South Africa (+27)",
    "South Korea (+82)",
    "South Sudan (+211)",
    "Spain (+34)",
    "Sri Lanka (+94)",
    "Sudan (+249)",
    "Suriname (+597)",
    "Svalbard and Jan Mayen (+47)",
    "Swaziland (+268)",
    "Sweden (+46)",
    "Switzerland (+41)",
    "Syria (+963)",
    "Taiwan (+886)",
    "Tajikistan (+992)",
    "Tanzania (+255)",
    "Thailand (+66)",
    "Togo (+228)",
    "Tokelau (+690)",
    "Tonga (+676)",
    "Trinidad and Tobago (+1-868)",
    "Tunisia (+216)",
    "Turkey (+90)",
    "Turkmenistan (+993)",
    "Turks and Caicos Islands (+1-649)",
    "Tuvalu (+688)",
    "U.S. Virgin Islands (+1-340)",
    "Uganda (+256)",
    "Ukraine (+380)",
    "United Arab Emirates (+971)",
    "United Kingdom (+44)",
    "United States or Canada (+1)",
    "Uruguay (+598)",
    "Uzbekistan (+998)",
    "Vanuatu (+678)",
    "Vatican (+379)",
    "Venezuela (+58)",
    "Vietnam (+84)",
    "Wallis and Futuna (+681)",
    "Western Sahara (+212)",
    "Yemen (+967)",
    "Zambia (+260)",
    "Zimbabwe (+263)"
  ];

  //endregion

  FirebaseAuth auth = FirebaseAuth.instance;
  String dropdownValue = "+1";
  TextEditingController smsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 300,
              ),
              Text(
                "Phone sign in",
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "SMS",
                  prefixText: "+",
                  prefixIcon: Icon(Icons.phone),
                ),
                controller: smsController,
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () async {
                    await auth.verifyPhoneNumber(
                      phoneNumber: '+91 9945994599',
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        await auth.signInWithCredential(credential);
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        if (e.code == 'invalid-phone-number') {
                          print('The provided phone number is not valid.');
                        }else if (e.code == 'quota-exceeded') {
                          print('The project has exceeded the quota for verification.');
                        } else if (e.code == 'cancelled') {
                          print('The user cancelled the verification.');
                        } else {
                          print('Error: ' + e.code);
                        }
                      },
                      codeSent: (String verificationId, int? resendToken) async {
                        String smsCode = smsController.text;
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                        await auth.signInWithCredential(credential);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  },
                  child: Text("Sign In")),
            ],
          )
          /*Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 275,
            ),
            Text('Enter your phone number', style: TextStyle(fontSize: 24)),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                DropdownButton<String>(
                  value: "+91",
                  icon: Icon(Icons.expand_more),
                  items: countryCodesNumbers
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Quicksand'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(fontSize: 18),
                    ),
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        ),*/
          ),
    );
  }
}
