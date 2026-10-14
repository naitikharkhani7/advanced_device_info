import 'package:flutter/material.dart';
import 'package:advanced_device_info/advanced_device_info.dart';

void main() => runApp(const MyApp());

/// Root application widget configuring dark theme and app shell.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Device Info',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          surface: Color(0xFF1C2541),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1C2541),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const DeviceInfoDashboard(),
    );
  }
}

/// Dashboard demonstrating senior-level asynchronous data fetching,
/// reusable UI components, and complete hardware & security inspection.
class DeviceInfoDashboard extends StatefulWidget {
  const DeviceInfoDashboard({super.key});

  @override
  State<DeviceInfoDashboard> createState() => _DeviceInfoDashboardState();
}

class _DeviceInfoDashboardState extends State<DeviceInfoDashboard> {
  late Future<SystemInfo> _deviceInfoFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _deviceInfoFuture = AdvancedDeviceInfo.getSystemInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DEVICE METRICS & SECURITY',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF818CF8)),
            tooltip: 'Refresh Metrics',
            onPressed: _fetchData,
          ),
        ],
      ),
      body: FutureBuilder<SystemInfo>(
        future: _deviceInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            );
          }

          if (snapshot.hasError) {
            return _ErrorView(
              errorMessage: snapshot.error.toString(),
              onRetry: _fetchData,
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No system information available.'));
          }

          final info = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            color: const Color(0xFF6366F1),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _HeaderBanner(device: info.deviceInfo),
                const SizedBox(height: 14),
                _SecurityOverviewCard(security: info.securityInfo),
                const SizedBox(height: 14),
                _BatteryOverviewCard(battery: info.batteryInfo),
                const SizedBox(height: 14),
                _NetworkOverviewCard(network: info.networkInfo),
                const SizedBox(height: 14),
                _SpecsGrid(cpu: info.cpuInfo, screen: info.screenInfo),
                const SizedBox(height: 14),
                _ResourceUsageCard(
                  title: 'STORAGE USAGE',
                  icon: Icons.storage_rounded,
                  accentColor: Colors.orangeAccent,
                  usedDisplay: info.storageInfo.formattedUsedStorage,
                  totalDisplay: info.storageInfo.formattedTotalStorage,
                  freeDisplay: info.storageInfo.formattedFreeStorage,
                  usagePercent: info.storageInfo.usagePercentage,
                ),
                const SizedBox(height: 14),
                _ResourceUsageCard(
                  title: 'SYSTEM RAM',
                  icon: Icons.memory_rounded,
                  accentColor: Colors.tealAccent,
                  usedDisplay: info.memoryInfo.formattedUsedRam,
                  totalDisplay: info.memoryInfo.formattedTotalRam,
                  freeDisplay: info.memoryInfo.formattedAvailableRam,
                  usagePercent: info.memoryInfo.usagePercentage,
                ),
                if (info.deviceInfo.buildInfo.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _BuildInfoCard(buildInfo: info.deviceInfo.buildInfo),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Top gradient banner presenting core device branding and emulator status.
class _HeaderBanner extends StatelessWidget {
  final DeviceInfo device;

  const _HeaderBanner({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withAlpha(80),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  device.deviceName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (device.isEmulator)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'EMULATOR',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.amberAccent),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${device.manufacturer.toUpperCase()} • ${device.model}',
            style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 14, color: Colors.white60),
              const SizedBox(width: 6),
              Text('Brand: ${device.brand}', style: const TextStyle(fontSize: 12, color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Security card showing Root, Jailbreak, Developer Mode, ADB, and USB Cable status.
class _SecurityOverviewCard extends StatelessWidget {
  final SecurityInfo security;

  const _SecurityOverviewCard({required this.security});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.security_rounded, color: Colors.redAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'SECURITY & INTEGRITY',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: security.isCompromised ? Colors.red.withAlpha(50) : Colors.green.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: security.isCompromised ? Colors.redAccent : Colors.greenAccent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    security.isCompromised ? 'COMPROMISED' : 'SECURE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: security.isCompromised ? Colors.redAccent : Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SecurityBadgeRow(
              label: 'Developer Options',
              value: security.isDeveloperMode ? 'ENABLED' : 'DISABLED',
              isWarning: security.isDeveloperMode,
              icon: Icons.developer_mode_rounded,
            ),
            const SizedBox(height: 8),
            _SecurityBadgeRow(
              label: 'USB Debugging (ADB)',
              value: security.isAdbEnabled ? 'ACTIVE' : 'DISABLED',
              isWarning: security.isAdbEnabled,
              icon: Icons.bug_report_rounded,
            ),
            const SizedBox(height: 8),
            _SecurityBadgeRow(
              label: 'USB Cable Connection',
              value: security.isUsbConnected ? 'CONNECTED' : 'DISCONNECTED',
              isWarning: security.isUsbConnected,
              icon: Icons.usb_rounded,
            ),
            const SizedBox(height: 8),
            _SecurityBadgeRow(
              label: 'Root / Jailbreak',
              value: (security.isRooted || security.isJailbroken) ? 'DETECTED' : 'NOT DETECTED',
              isWarning: security.isRooted || security.isJailbroken,
              icon: Icons.lock_open_rounded,
            ),
            const SizedBox(height: 8),
            _SecurityBadgeRow(
              label: 'Lock Screen / Passcode',
              value: security.isDeviceSecure ? 'CONFIGURED' : 'NOT SET',
              isWarning: !security.isDeviceSecure,
              icon: Icons.lock_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityBadgeRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isWarning;
  final IconData icon;

  const _SecurityBadgeRow({
    required this.label,
    required this.value,
    required this.isWarning,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isWarning ? Colors.amberAccent : Colors.tealAccent,
          ),
        ),
      ],
    );
  }
}

/// Battery Card showing level, power source, charging state, temperature, and power-saver mode.
class _BatteryOverviewCard extends StatelessWidget {
  final BatteryInfo battery;

  const _BatteryOverviewCard({required this.battery});

  @override
  Widget build(BuildContext context) {
    final level = battery.batteryLevel;
    final levelPercent = (level >= 0 ? level / 100.0 : 0.0).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      battery.isCharging ? Icons.battery_charging_full_rounded : Icons.battery_std_rounded,
                      color: Colors.greenAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'BATTERY & POWER',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ],
                ),
                if (battery.isLowPowerMode)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'BATTERY SAVER ON',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  level >= 0 ? '$level% Charge' : 'Unavailable',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${battery.batteryStatus.toUpperCase()} • ${battery.powerSource.toUpperCase()}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: levelPercent,
                minHeight: 10,
                backgroundColor: const Color(0xFF334155),
                valueColor: AlwaysStoppedAnimation<Color>(
                  level > 20 ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Health: ${battery.batteryHealth.toUpperCase()}',
                  style: const TextStyle(fontSize: 11, color: Colors.white60),
                ),
                if (battery.batteryTemperature > 0)
                  Text(
                    'Temp: ${battery.batteryTemperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 11, color: Colors.white60),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Network Card displaying internet state, connection type, and active VPN warning.
class _NetworkOverviewCard extends StatelessWidget {
  final NetworkInfo network;

  const _NetworkOverviewCard({required this.network});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  network.isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                  color: network.isConnected ? const Color(0xFF38BDF8) : Colors.redAccent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      network.isConnected ? 'ONLINE (${network.connectionType.toUpperCase()})' : 'OFFLINE',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      network.isVpnActive ? 'VPN Active (Tunnel detected)' : 'No VPN Active',
                      style: TextStyle(
                        fontSize: 11,
                        color: network.isVpnActive ? Colors.amberAccent : Colors.white60,
                        fontWeight: network.isVpnActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (network.isVpnActive)
              const Icon(Icons.vpn_key_rounded, color: Colors.amberAccent, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Dual-column grid displaying CPU and Display specifications.
class _SpecsGrid extends StatelessWidget {
  final CpuInfo cpu;
  final ScreenInfo screen;

  const _SpecsGrid({required this.cpu, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'CPU',
            icon: Icons.developer_board_rounded,
            iconColor: const Color(0xFF60A5FA),
            value: '${cpu.cores} Cores',
            subtitle: cpu.architecture,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatCard(
            title: 'DISPLAY',
            icon: Icons.screenshot_monitor_rounded,
            iconColor: const Color(0xFF34D399),
            value: '${screen.width} × ${screen.height}',
            subtitle: '${screen.refreshRate.toInt()} Hz • @${screen.scale.toStringAsFixed(1)}x',
          ),
        ),
      ],
    );
  }
}

/// Reusable stat card for quick key-value metrics.
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white54, letterSpacing: 1.1),
                ),
                Icon(icon, color: iconColor, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}

/// Generic, highly reusable resource card handling both Storage and RAM metrics.
class _ResourceUsageCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final String usedDisplay;
  final String totalDisplay;
  final String freeDisplay;
  final double usagePercent;

  const _ResourceUsageCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.usedDisplay,
    required this.totalDisplay,
    required this.freeDisplay,
    required this.usagePercent,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedUsage = (usagePercent / 100.0).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${usagePercent.toStringAsFixed(1)}% Used',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$usedDisplay / $totalDisplay',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: normalizedUsage,
                minHeight: 10,
                backgroundColor: const Color(0xFF334155),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Available: $freeDisplay',
              style: const TextStyle(fontSize: 11, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

/// Expansion card detailing platform-specific hardware/OS build properties.
class _BuildInfoCard extends StatelessWidget {
  final Map<String, dynamic> buildInfo;

  const _BuildInfoCard({required this.buildInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          leading: const Icon(Icons.settings_suggest_rounded, color: Colors.purpleAccent, size: 20),
          title: const Text(
            'DETAILED BUILD INFO',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Divider(color: Colors.white12),
            ...buildInfo.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white54, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        entry.value?.toString() ?? 'N/A',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view with retry action.
class _ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorView({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 56, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Failed to load metrics:\n$errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
