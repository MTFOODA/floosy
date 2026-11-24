import '../../../../core/localization/app_localizations.dart';
import '../../../../domain/entities/bank_directory.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  AppLocalizations get _l => AppLocalizations.s(context);
  int _currentStep = 0;
  late PageController _pageController;
  String? _selectedCurrency = 'EGP';
  String? _selectedBank;
  bool _smsPermissionGranted = false;
  bool _notificationPermissionGranted = false;

  final List<Map<String, String>> _currencies = [
    {'code': 'EGP', 'name': 'Egyptian Pound'},
    {'code': 'USD', 'name': 'US Dollar'},
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'SAR', 'name': 'Saudi Riyal'},
    {'code': 'AED', 'name': 'UAE Dirham'},
  ];

  final List<Map<String, String>> _banks = [
    {'id': '1', 'name': 'Commercial International Bank (CIB)', 'code': 'CIB'},
    {'id': '2', 'name': 'National Bank of Egypt (NBE)', 'code': 'NBE'},
    {'id': '3', 'name': 'Banque Misr', 'code': 'MISR'},
    {'id': '4', 'name': 'QNB Egypt', 'code': 'QNB'},
    {'id': '5', 'name': 'AlexBank', 'code': 'ALEX'},
    {'id': '6', 'name': 'HSBC Egypt', 'code': 'HSBC'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.dashboard);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / 5,
                minHeight: 4,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomeStep(),
                  _buildCurrencyStep(),
                  _buildBankStep(),
                  _buildPermissionsStep(),
                  _buildSummaryStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text(_l['previousStep']),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      child: Text(
                        _currentStep == 4
                            ? _l['onboardingStart']
                            : _l['nextStep'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            _l['onboardingWelcome'],
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            _l['onboardingIntro'],
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey, height: 1.6),
          ),
          const SizedBox(height: 40),
          _buildFeatureItem(
            '💰',
            _l['onboardingTrack'],
            _l['onboardingTrackHint'],
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            '📊',
            _l['onboardingAnalytics'],
            _l['onboardingAnalyticsHint'],
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            '🎯',
            _l['onboardingGoals'],
            _l['onboardingGoalsHint'],
          ),
          const SizedBox(height: 24),
          _buildFeatureItem('🤖', _l['onboardingAI'], _l['onboardingAIHint']),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            _l['selectCurrency'],
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _l['currencyHint'],
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ..._currencies.map((currency) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () =>
                    setState(() => _selectedCurrency = currency['code']),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedCurrency == currency['code']
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedCurrency == currency['code']
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _selectedCurrency == currency['code']
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _l.currencyName(currency['code']!),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _l.currencySymbol(currency['code']!),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBankStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            _l['selectBank'],
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _l['bankHint'],
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ..._banks.map((bank) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedBank = bank['id']),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedBank == bank['id']
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedBank == bank['id']
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _selectedBank == bank['id']
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              BankCatalog.displayName(
                                bank['code'],
                                arabic: _l.isArabic,
                              ),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_l['bankCode']}: ${bank['code']}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPermissionsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            _l['enablePermissions'],
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _l['permissionsIntro'],
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildPermissionCard(
            '📱',
            _l['smsAccess'],
            _l['smsAccessHint'],
            _smsPermissionGranted,
            () async {
              // TODO: Request SMS permission
              setState(() => _smsPermissionGranted = true);
            },
          ),
          const SizedBox(height: 16),
          _buildPermissionCard(
            '🔔',
            _l['notifications'],
            _l['notificationsHint'],
            _notificationPermissionGranted,
            () async {
              // TODO: Request notification permission
              setState(() => _notificationPermissionGranted = true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(
    String emoji,
    String title,
    String description,
    bool isGranted,
    VoidCallback onRequest,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isGranted)
            Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
          else
            ElevatedButton(
              onPressed: onRequest,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(_l['grantPermission']),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            _l['allSet'],
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildSummaryItem(
            _l['currency'],
            _selectedCurrency == null
                ? _l['notSelected']
                : _l.currencyName(_selectedCurrency!),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            _l['bankLabel'],
            _selectedBank == null
                ? _l['notSelected']
                : BankCatalog.displayName(
                    _banks.firstWhere((b) => b['id'] == _selectedBank)['code'],
                    arabic: _l.isArabic,
                  ),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            _l['smsTracking'],
            _smsPermissionGranted ? _l['enabledLabel'] : _l['disabledLabel'],
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            _l['notifications'],
            _notificationPermissionGranted
                ? _l['enabledLabel']
                : _l['disabledLabel'],
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _l['onboardingSettingsHint'],
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
