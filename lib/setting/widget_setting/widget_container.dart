import 'package:flutter/material.dart';
class WidgetContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;


  const WidgetContainer
      ({super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }

      },
      child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ]
          ),
          child: Row(
            children: [
              SizedBox(width: 10,),
              Icon(icon, size: 30,),


              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8),
                      child: Text(title, style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,


                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8),
                      child: Text(subtitle,
                        style: TextStyle(
                          fontSize: 10,
                        ),),
                    ),

                  ]


              ),
               Spacer(),
              Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
