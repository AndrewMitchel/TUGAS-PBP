import 'package:flutter/material.dart';

import '../widgets/background.dart';
import '../widgets/menu_card.dart';

class HomePage extends StatelessWidget {

  // =========================
  // USERNAME DARI LOGIN
  // =========================

  final String username;

  const HomePage({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Background(

        child: SafeArea(

          child: SingleChildScrollView(

            padding:
                const EdgeInsets.all(25),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // =========================
                // HEADER
                // =========================

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Hello,',

                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.6),
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        // USERNAME DARI LOGIN
                        Text(
                          'Hello $username',

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(
                          'Welcome back!',

                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),

                    // PROFILE ICON

                    Container(

                      width: 50,
                      height: 50,

                      decoration:
                          BoxDecoration(

                        color: Colors.white
                            .withOpacity(0.12),

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // =========================
                // TOTAL DATA
                // =========================

                Container(

                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(20),

                  decoration:
                      BoxDecoration(

                    gradient:
                        const LinearGradient(

                      colors: [

                        Color(0xFF1749C9),

                        Color(0xFF155EFF),
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Row(

                    children: [

                      Container(

                        width: 55,
                        height: 55,

                        decoration:
                            BoxDecoration(

                          color: Colors.white
                              .withOpacity(0.15),

                          shape:
                              BoxShape.circle,
                        ),

                        child:
                            const Icon(
                          Icons.layers,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 18,
                      ),

                      const Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            'Total Data',
                            style: TextStyle(
                              color:
                                  Colors.white70,
                            ),
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Text(
                            '0',

                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          Text(
                            'items',

                            style:
                                TextStyle(
                              color:
                                  Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // =========================
                // MENU
                // =========================

                const Text(
                  'Menu',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                GridView.count(

                  crossAxisCount: 2,

                  shrinkWrap: true,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  crossAxisSpacing: 15,

                  mainAxisSpacing: 15,

                  children: const [

                    MenuCard(
                      icon:
                          Icons.folder_outlined,
                      title: 'Data',
                      subtitle:
                          'Lihat semua data',
                    ),

                    MenuCard(
                      icon:
                          Icons.bar_chart,
                      title: 'Laporan',
                      subtitle:
                          'Lihat laporan',
                    ),

                    MenuCard(
                      icon:
                          Icons.settings_outlined,
                      title: 'Pengaturan',
                      subtitle:
                          'Atur aplikasi',
                    ),

                    MenuCard(
                      icon:
                          Icons.person_outline,
                      title: 'Profil',
                      subtitle:
                          'Lihat profil',
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================

      bottomNavigationBar:
          BottomNavigationBar(

        backgroundColor:
            const Color(0xFF0C194D),

        selectedItemColor:
            const Color(0xFF3D7BFF),

        unselectedItemColor:
            Colors.white54,

        currentIndex: 0,

        items: const [

          BottomNavigationBarItem(
            icon:
                Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}