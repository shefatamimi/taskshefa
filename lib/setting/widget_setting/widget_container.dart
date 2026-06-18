import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_shefa/setting/service/provider_darkmode.dart';
import 'package:task_shefa/setting/service/provider_fontsize.dart';
import 'package:task_shefa/setting/service/provider_theme_color.dart';
class WidgetContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Icon? iconData;


  const WidgetContainer
      ({super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.iconData,
      });

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
              Icon(icon, size: 30,
                color: Colors.black87,
              ),



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
                        color: Colors.black87,


                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8),
                      child: Text(subtitle,
                        style: TextStyle(
                          fontSize: 10,

                          color: Colors.black87,
                        ),),
                    ),

                  ]


              ),
               Spacer(),
              if(title != 'Dark Mode')
                if (title != 'Theme Color')
                  if(title != 'Font Size')
              Icon(Icons.arrow_forward_ios, size: 20,
                color: Colors.black87,
              ),
              SizedBox(width: 10,),
              if(title == 'Dark Mode')
              Switch(
                value: context.watch<ThemeProvider>().isDarkMode,
                onChanged: (value) {
                  context.read<ThemeProvider>().toggleTheme();
                },
              ),
              if(title == 'Theme Color')
              Switch(
                value: context.watch<ProviderThemeColor>().color == Colors.green,
                onChanged: (value) {
                  context.read<ProviderThemeColor>().toggleColor();
                },
              ),
              if (title == 'Font Size')
               IconButton(onPressed: () {
                 context.read<FontSizeController>().increment();
               }, icon: Icon(Icons.add_box, size: 25,
                 color: Colors.black38,
               ))
              ,
              if (title == 'Font Size')
                IconButton(onPressed: () {
                  context.read<FontSizeController>().decrement();
                }, icon: Icon(Icons.indeterminate_check_box, size: 25,
                  color: Colors.black38,))
            ],
          ),
        ),
      ),
    );
  }
}
