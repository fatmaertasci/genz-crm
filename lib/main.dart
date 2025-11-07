import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'data/models/customer.dart';
import 'data/repositories/customer_repository.dart';
import 'data/utils/initial_data.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/viewmodels/customer_list_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());

  final customerRepository = CustomerRepository();
  await customerRepository.init();

  // Initialize demo data
  await InitialData.initializeData(customerRepository);

  runApp(MyApp(repository: customerRepository));
}

class MyApp extends StatelessWidget {
  final CustomerRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CustomerListViewModel(repository),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'GenZ CRM',
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
