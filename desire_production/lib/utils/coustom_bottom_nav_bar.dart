import 'package:desire_production/pages/admin/products/product_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants.dart';
import 'enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const   CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
    @required this.numOfItem
  }) : super(key: key);

  final MenuState selectedMenu;
  final int numOfItem;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => ProductHomePage()));
                }
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {

                          //Navigator.push(context, MaterialPageRoute(builder: (builder) => CartPage()));
                        },
                child: Stack(
                  children: [
                    SvgPicture.asset("assets/icons/Cart Icon.svg", color: MenuState.cart == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,),
                    if (numOfItem != 0)
                      Positioned(
                        top: -1,
                        right: 0,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF4848),
                            shape: BoxShape.circle,
                            border: Border.all(width: 1.5, color: Colors.white),
                          ),
                          child: Center(
                            child: Text(
                              "$numOfItem",
                              style: TextStyle(
                                fontSize: 5,
                                height: 1,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Log out.svg",
                  color: MenuState.logout == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  //Alerts.showLogOut(context, "LOGOUT", "Are you sure?");
                }
              ),
            ],
          )),
    );
  }
}
