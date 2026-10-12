import 'dart:async';
import 'package:cgv_movie/page/home/member_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/movie.dart';
import '../../provider/movie_provider.dart';
import 'select_movie_page.dart';
import 'select_theater_page.dart';
import '../../widgets/hover_movie_card.dart';

import '../profile/account_info_page.dart';
import '../profile/change_password_page.dart';
import '../profile/member_card_page.dart';
import '../profile/point_page.dart';
import '../profile/voucher_page.dart';
import '../profile/history_page.dart';
import '../profile/profile_page.dart'; 
import '../payment/payment_pin_page.dart';
import '../store/egift_page.dart';
import '../store/cgv_store_page.dart';
import '../store/icecon_page.dart';
import '../ticket/ticket_history_page.dart';
import '../login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  // ---- CẤU HÌNH BANNER QUẢNG CÁO TỰ ĐỘNG CHẠY ----
  late PageController _bannerController;
  int _currentBannerPage = 0;
  Timer? _bannerTimer;

  // Mã màu đỏ cam đặc trưng CGV chuẩn đẹp
  static const Color primaryRed = Color(0xFFE52521);
  
  // Danh sách hình ảnh banner quảng cáo
  final List<String> _bannerImages = [
    'quang1.webp',
    'quang2.jpg',
    'quang3.jpg',
    'quang4.jpg',
    'quang-cao-nestle.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); 
    _pageController = PageController(viewportFraction: 0.72, initialPage: 0); 
    
    _bannerController = PageController(initialPage: 0);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPlay();
      _startBannerAutoPlay();
    });
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      
      final movies = Provider.of<MovieProvider>(context, listen: false).movies;
      if (movies.isEmpty) return; 

      if (_currentPage >= movies.length - 1) {
        _currentPage = 0;
      } else {
        _currentPage++;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startBannerAutoPlay() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      
      if (_currentBannerPage >= _bannerImages.length - 1) {
        _currentBannerPage = 0;
      } else {
        _currentBannerPage++;
      }

      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel(); 
    _bannerTimer?.cancel();
    _tabController.dispose();
    _pageController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryRed), 
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey), 
      onTap: onTap, 
    );
  }

  void _openPageAfterCloseDrawer(BuildContext context, Widget page) async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    if (context.mounted) {
      Scaffold.of(context).openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = context.watch<MovieProvider>().movies;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      
      // ================= MENU TRẮNG BÊN TRÁI (DRAWER) =================
      drawer: Drawer(
        child: Container(
          color: Colors.white, 
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                color: primaryRed,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // 🟢 ĐÃ SỬA: Bấm nút Mũi tên để mở trang Thành Viên thay vì bị đóng xẹp Drawer
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            _openPageAfterCloseDrawer(context, const MemberHomePage());
                          }, 
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Thành viên CGV',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), 
                      ],
                    ),
                    const SizedBox(height: 15),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.brown[700],
                          backgroundImage: user?.photoURL != null 
                              ? NetworkImage(user!.photoURL!) 
                              : null,
                          child: user?.photoURL == null 
                              ? const Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        ),
                        const CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.white70,
                          child: Icon(Icons.camera_alt, size: 15, color: Colors.black54),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    Text(
                      user?.displayName ?? 
                      user?.email?.split('@')[0].toUpperCase() ?? 
                      'THÀNH VIÊN CGV',
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    
                    if (user?.email != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user!.email!,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // 1. Thông tin Tài khoản
                    _buildDrawerItem(
                      Icons.badge_outlined,
                      'Thông tin Tài khoản',
                      () => _openPageAfterCloseDrawer(context, const MemberHomePage()), 
                    ),
                    
                    // 2. Đổi mật khẩu
                    _buildDrawerItem(
                      Icons.lock_outline,
                      'Đổi mật khẩu',
                      () => _openPageAfterCloseDrawer(context, const ChangePasswordPage()),
                    ),
                    
                    // 3. Cài đặt mật mã thanh toán
                    _buildDrawerItem(
                      Icons.pin_outlined,
                      'Cài đặt mật mã thanh toán',
                      () => _openPageAfterCloseDrawer(context, const PaymentPinPage()),
                    ),
                    
                    // 4. Thẻ thành viên
                    _buildDrawerItem(
                      Icons.card_membership,
                      'Thẻ thành viên',
                      () => _openPageAfterCloseDrawer(context, const MemberCardPage()),
                    ),
                    
                    const Divider(height: 1, thickness: 1), 
                    
                    // 5. Điểm
                    _buildDrawerItem(
                      Icons.monetization_on_outlined,
                      'Điểm',
                      () => _openPageAfterCloseDrawer(context, const PointPage()),
                    ),
                    
                    // 6. Thẻ Quà Tặng | Voucher | Coupon
                    _buildDrawerItem(
                      Icons.card_giftcard,
                      'Thẻ Q.Tặng | Voucher | Coupon',
                      () => _openPageAfterCloseDrawer(context, const VoucherPage()),
                    ),
                    
                    const Divider(height: 1, thickness: 1),

                    // 7. Lịch sử Giao dịch
                    _buildDrawerItem(
                      Icons.history,
                      'Lịch sử Giao dịch',
                      () => _openPageAfterCloseDrawer(context, const TicketHistoryPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= MENU PHẢI (END DRAWER) =================
      endDrawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                color: primaryRed,
                child: const Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Thẻ thành viên',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      Icons.movie,
                      'Đặt vé theo phim',
                      () => _openPageAfterCloseDrawer(
                        context,
                        const SelectMoviePage(),
                      ),
                    ),

                    _buildDrawerItem(
                      Icons.location_city,
                      'Đặt vé theo rạp',
                      () => _openPageAfterCloseDrawer(
                        context,
                        const SelectTheaterPage(),
                      ),
                    ),

                    const Divider(height: 1),

                    _buildDrawerItem(
                      Icons.person,
                      'Thông tin tài khoản',
                      () => _openPageAfterCloseDrawer(context, const MemberCardPage()),
                    ),

                    _buildDrawerItem(
                      Icons.lock_outline,
                      'Đổi mật khẩu',
                      () => _openPageAfterCloseDrawer(context, const ChangePasswordPage()),
                    ),

                    _buildDrawerItem(
                      Icons.credit_card,
                      'Thẻ thành viên',
                      () => _openPageAfterCloseDrawer(context, const MemberCardPage()),
                    ),

                    const Divider(height: 1),

                    _buildDrawerItem(
                      Icons.stars_outlined,
                      'Điểm',
                      () => _openPageAfterCloseDrawer(
                        context,
                        const PointPage(),
                      ),
                    ),

                    _buildDrawerItem(
                      Icons.card_giftcard,
                      'Voucher | Coupon',
                      () => _openPageAfterCloseDrawer(
                        context,
                        const VoucherPage(),
                      ),
                    ),

                    const Divider(height: 1),

                    _buildDrawerItem(
                      Icons.history,
                      'Lịch sử giao dịch',
                      () => _openPageAfterCloseDrawer(
                        context,
                        const HistoryPage(),
                      ),
                    ),

                    const Divider(height: 1),

                    _buildDrawerItem(
                      Icons.logout,
                      'Đăng xuất',
                      () async {
                        await FirebaseAuth.instance.signOut();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // ================= CẤU TRÚC LỚP CHÍNH VỚI STACK =================
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/anhdong.gif',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: primaryRed,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/CGV_Logo.svg/1280px-CGV_Logo.svg.png',
                            height: 30,
                            errorBuilder: (_, __, ___) => const Text('CGV', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.confirmation_number_outlined, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TicketHistoryPage()),
                          );
                        },
                      ),
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: PageView.builder(
                              controller: _bannerController,
                              itemCount: _bannerImages.length,
                              onPageChanged: (index) {
                                _currentBannerPage = index;
                              },
                              itemBuilder: (context, index) {
                                final img = _bannerImages[index];
                                return Image.asset(
                                  'assets/images/$img',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[800],
                                      child: const Center(
                                        child: Icon(Icons.image_not_supported, color: Colors.white, size: 40),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                          indicatorSize: TabBarIndicatorSize.label,
                          onTap: (index) {
                            final movieProvider = Provider.of<MovieProvider>(context, listen: false);
                            if (index == 0) {
                              movieProvider.filterMovies('Đang chiếu');
                            } else if (index == 1) {
                              movieProvider.filterMovies('Đặc biệt');
                            } else if (index == 2) {
                              movieProvider.filterMovies('Sắp chiếu');
                            }

                            if (_pageController.hasClients) {
                              _pageController.jumpToPage(0);
                            }
                          },
                          tabs: const [
                            Tab(text: 'Đang chiếu'),
                            Tab(text: 'Đặc biệt'),
                            Tab(text: 'Sắp chiếu'),
                          ],
                        ),

                        const SizedBox(height: 15),

                        movies.isEmpty
                            ? const Center(child: CircularProgressIndicator(color: Colors.white))
                            : SizedBox(
                                height: 420,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: movies.length,
                                  physics: const ClampingScrollPhysics(), 
                                  onPageChanged: (index) {
                                    _currentPage = index; 
                                    setState(() {});
                                  },
                                  itemBuilder: (context, index) {
                                    final movie = movies[index];
                                    double scale = _currentPage == index ? 1.0 : 0.85;

                                    return TweenAnimationBuilder(
                                      tween: Tween(begin: scale, end: scale),
                                      duration: const Duration(milliseconds: 200),
                                      builder: (context, double val, child) {
                                        return Transform.scale(
                                          scale: val,
                                          child: _buildMovieCard(movie, index + 1),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),

                        const SizedBox(height: 10),

                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.face, color: Colors.amber),
                                        const SizedBox(width: 10),
                                        Text('Bạn cần hỗ trợ gì?', style: TextStyle(color: Colors.grey[700])),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCircleMenu(Icons.card_giftcard, 'THẺ QUÀ TẶNG'),
                                  _buildCircleMenu(Icons.fastfood, 'CGV STORE'),
                                  _buildCircleMenu(Icons.icecream, 'ICECON'),
                                ],
                              ),
                              const SizedBox(height: 25),

                              _buildSectionTitle('Tin nóng'),
                              _buildHorizontalList(
                                height: 190,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  List<Map<String, String>> data = [
                                    {
                                      'title': 'MILO PRO & MILO COFFEE CHÍNH THỨC CÓ MẶT TẠI CGV',
                                      'img': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=500'
                                    },
                                    {
                                      'title': 'Xem Phim Ngày Đôi – Nhận Quà Gấp Bội tại quầy vé',
                                      'img': 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=500'
                                    },
                                    {
                                      'title': 'SUMMER COMBO ĐẶC BIỆT DÀNH CHO THÀNH VIÊN',
                                      'img': 'https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=500'
                                    },
                                    {
                                      'title': 'NÓNG - CGV giảm giá vé chỉ còn 49k cho mọi bộ phim tại 8 rạp lớn trên toàn quốc',
                                      'img': 'tinnong.webp'
                                    },
                                    {
                                      'title': 'NÓNG - QUYẾT ĐI BỘ ĐỘI',
                                      'img': 'tinnong2.webp'
                                    }
                                  ];
                                  return _buildHorizontalCard(data[index]['title']!, data[index]['img']!, isVideo: false);
                                },
                              ),
                              const SizedBox(height: 20),

                              _buildSectionTitle('CGV eGift'),
                              _buildHorizontalList(
                                height: 160,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  List<Map<String, String>> data = [
                                    {'title': 'TẾT SUM VẦY 2026', 'img': 'https://images.unsplash.com/photo-1531988042231-d39a9cc12a9a?q=80&w=500'},
                                    {'title': 'NEW YEAR LUCK 2026', 'img': 'https://images.unsplash.com/photo-1467803738586-46b7eb7b16a1?q=80&w=500'},
                                    {'title': 'HAPPY BIRTHDAY CARD', 'img': 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?q=80&w=500'},
                                    {'title': 'QUÀ TẶNG', 'img': 'gift1.webp'},
                                    {'title': 'MƯỢN THẺ VÀO TIM', 'img': 'gift2.webp'},
                                  ];
                                  return _buildHorizontalCard(data[index]['title']!, data[index]['img']!, isVideo: false, imgHeight: 110);
                                },
                              ),
                              const SizedBox(height: 20),

                              _buildSectionTitle('Videos'),
                              _buildHorizontalList(
                                height: 190,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  List<Map<String, String>> data = [
                                    {
                                      'title': 'NGÀY TÀN CỦA PHÓ OAK | Official trailer - Dự kiến khởi chiếu...',
                                      'img': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=500'
                                    },
                                    {
                                      'title': 'LIÊU TRAI LAN NHƯỢC TỰ trailer - KC: 26.06.2026',
                                      'img': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=500'
                                    },
                                    {
                                      'title': 'MA NỮ OÁN TÌNH trailer - KC: 10.07.2006',
                                      'img': 'manu.webp'
                                    }
                                  ];
                                  return _buildHorizontalCard(data[index]['title']!, data[index]['img']!, isVideo: true);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('TẤT CẢ', style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList({required double height, required int itemCount, required IndexedWidgetBuilder itemBuilder}) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 8),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }

  Widget _buildHorizontalCard(String title, String imageUrl, {required bool isVideo, double imgHeight = 120}) {
    final isAsset = !imageUrl.startsWith('http');

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isAsset
                    ? Image.asset(
                        'assets/images/$imageUrl',
                        height: imgHeight,
                        width: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: imgHeight,
                            width: 200,
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, color: Colors.white, size: 30),
                            ),
                          );
                        },
                      )
                    : Image.network(imageUrl, height: imgHeight, width: 200, fit: BoxFit.cover),
              ),
              if (isVideo)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie, int index) {
    return HoverMovieCard(
      movie: movie,
      onTap: () {
        Provider.of<MovieProvider>(context, listen: false).selectMovie(movie);
        Navigator.pushNamed(context, '/movie_detail', arguments: movie);
      },
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
                    ],
                    image: DecorationImage(
                      image: movie.image.startsWith('http') 
                          ? NetworkImage(movie.image) 
                          : AssetImage('assets/images/${movie.image}') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                movie.title.toUpperCase(), 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis, 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                onPressed: () => Navigator.pushNamed(context, '/movie_detail', arguments: movie),
                child: const Text('Đặt Vé', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
          Positioned(
            left: 10,
            bottom: 55,
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 75,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.9),
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(offset: const Offset(2, 2), blurRadius: 5, color: Colors.black.withOpacity(0.5))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircleMenu(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Widget targetPage;
        if (label == 'THẺ QUÀ TẶNG') {
          targetPage = EGiftPage();
        } else if (label == 'CGV STORE') {
          targetPage = CgvStorePage();
        } else if (label == 'ICECON') {
          targetPage = IceconPage();
        } else {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28, 
            backgroundColor: Colors.pink[50],
            child: Icon(icon, color: primaryRed, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label, 
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}