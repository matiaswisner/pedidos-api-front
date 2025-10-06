import 'package:flutter/material.dart';
import 'products_screen.dart';

class BusinessListScreen extends StatefulWidget {
  final String categoryName;

  const BusinessListScreen({super.key, required this.categoryName});

  @override
  State<BusinessListScreen> createState() => _BusinessListScreenState();
}

class _BusinessListScreenState extends State<BusinessListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Negocios simulados (después se reemplaza por datos del backend)
  final List<Map<String, dynamic>> _allBusinesses = [
    {'name': 'Farmacia Central', 'rating': 4.8, 'icon': Icons.local_pharmacy},
    {'name': 'Farmacia Susana', 'rating': 4.5, 'icon': Icons.local_pharmacy},
    {'name': 'Farmacia Don Pepe', 'rating': 4.2, 'icon': Icons.local_pharmacy},
    {'name': 'Farmacia Popular', 'rating': 4.0, 'icon': Icons.local_pharmacy},
  ];

  List<Map<String, dynamic>> _filteredBusinesses = [];

  @override
  void initState() {
    super.initState();
    _filteredBusinesses = _allBusinesses;
  }

  void _filterBusinesses(String query) {
    setState(() {
      _filteredBusinesses = _allBusinesses
          .where((b) => b['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = {
      'celeste': const Color(0xFF6EC1E4),
      'blanco': Colors.white,
      'dorado': const Color(0xFFFFD700),
      'rojoFederal': const Color(0xFFCC2222),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colors['celeste'],
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6EC1E4), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔍 Buscador
              TextField(
                controller: _searchController,
                onChanged: _filterBusinesses,
                decoration: InputDecoration(
                  hintText: 'Buscar ${widget.categoryName.toLowerCase()}...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🏪 Lista de negocios
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredBusinesses.length,
                  itemBuilder: (context, index) {
                    final business = _filteredBusinesses[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: colors['celeste']!.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors['celeste']!.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colors['dorado'],
                          child: Icon(
                            business['icon'],
                            color: colors['celeste'],
                          ),
                        ),
                        title: Text(
                          business['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003366),
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              business['rating'].toString(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          // 🧭 Navegar a productos del negocio seleccionado
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                              const Duration(milliseconds: 700),
                              pageBuilder: (_, __, ___) => ProductsScreen(
                                categoryName: business['name'],
                              ),
                              transitionsBuilder:
                                  (_, animation, __, child) => FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.1, 0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  )),
                                  child: child,
                                ),
                              ),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Abriendo ${business['name']}...',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: colors['celeste'],
                              duration: const Duration(milliseconds: 800),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔙 Botón de volver
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors['rojoFederal'],
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}
