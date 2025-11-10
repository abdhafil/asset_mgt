// import 'package:asset_management_app/screens/category/category_page.dart';
// import 'package:asset_management_app/screens/home/home_page.dart';
// import 'package:asset_management_app/screens/saved/saved_page.dart';
// import 'package:flutter/material.dart';

// class MianLayout extends StatefulWidget {
//   const MianLayout({super.key});

//   @override
//   State<MianLayout> createState() => _MianLayoutState();
// }

// class _MianLayoutState extends State<MianLayout> {
//   int _selectedIndex = 0;
//   final List<Widget> _pages = const [HomePage(), SavedPage(), CategoryPage()];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   centerTitle: true,
//       //   title: Image.asset('assets/images/image.png', height: 30),
//       // ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.blueAccent,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.save_rounded),
//             label: 'Saved',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category),
//             label: 'Category',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:asset_management_app/screens/category/category_page.dart';
import 'package:asset_management_app/screens/home/home_page.dart';
import 'package:asset_management_app/screens/saved/saved_page.dart';

class MianLayout extends StatefulWidget {
  const MianLayout({super.key});

  @override
  State<MianLayout> createState() => _MianLayoutState();
}

class _MianLayoutState extends State<MianLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [HomePage(), SavedPage(), CategoryPage()];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false, // important: don't push it up
              child: GlassBottomDock(
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const [
                  DockItem(icon: Icons.home_rounded, label: ''),
                  DockItem(icon: Icons.save_rounded, label: ''),
                  DockItem(icon: Icons.category_rounded, label: ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One item in the dock
class DockItem {
  final IconData icon;
  final String label;
  const DockItem({required this.icon, required this.label});
}

/// The glass, rounded, blurred bottom bar inspired by your screenshot
class GlassBottomDock extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<DockItem> items;

  const GlassBottomDock({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          // Frosted blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SizedBox(height: 78),
          ),

          // Glass background + border + soft glow
          Container(
            height: 78,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.20)),
              boxShadow: [
                // bottom soft shadow to make it float
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
              // subtle gradient, darker on the bottom like the mock
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.06),
                ],
              ),
            ),
            child: Row(
              children: List.generate(items.length, (i) {
                final isActive = i == selectedIndex;
                return Expanded(
                  child: _DockButton(
                    icon: items[i].icon,
                    label: items[i].label,
                    active: isActive,
                    onTap: () => onTap(i),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _DockButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Active pill behind the icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            width: active ? 90 : 44,
            height: active ? 42 : 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // gradient glow for active state (like the blue in the mock)
              gradient: active
                  ? const LinearGradient(
                      colors: [Color(0xFF00C2FF), Color(0xFF6A5CFF)],
                    )
                  : null,
              // dim glass chip for inactive
              color: active ? null : Colors.white.withOpacity(0.06),
            ),
          ),

          // Icon + optional label
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: Colors.white.withOpacity(active ? 1 : 0.75),
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              fontSize: active ? 12 : 11,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: active ? 24 : 22,
                  color: Colors.white.withOpacity(active ? 1 : 0.8),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: active ? 8 : 0,
                ),
                // Show label only when active (like the UI chips)
                AnimatedOpacity(
                  opacity: active ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Visibility(visible: active, child: Text(label)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
