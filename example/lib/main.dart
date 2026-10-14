import 'dart:math';
import 'package:flutter/material.dart';
import 'package:advanced_device_info/advanced_device_info.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Device Info',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF6366F1), surface: Color(0xFF1E293B)),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const DeviceInfoDashboard(),
    );
  }
}

/// Dashboard demonstrating senior-level asynchronous data fetching,
/// reusable UI components, and clean separation of concerns.
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
        title: const Text('DEVICE METRICS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18)),
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
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
          }

          if (snapshot.hasError) {
            return _ErrorView(errorMessage: snapshot.error.toString(), onRetry: _fetchData);
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
                _SpecsGrid(cpu: info.cpuInfo, screen: info.screenInfo),
                const SizedBox(height: 14),
                _ResourceUsageCard(
                  title: 'STORAGE USAGE',
                  icon: Icons.storage_rounded,
                  accentColor: Colors.orangeAccent,
                  usedBytes: info.storageInfo.usedStorage,
                  totalBytes: info.storageInfo.totalStorage,
                  freeBytes: info.storageInfo.freeStorage,
                  usagePercent: info.storageInfo.usagePercentage,
                ),
                const SizedBox(height: 14),
                _ResourceUsageCard(
                  title: 'SYSTEM RAM',
                  icon: Icons.memory_rounded,
                  accentColor: Colors.tealAccent,
                  usedBytes: info.memoryInfo.usedRam,
                  totalBytes: info.memoryInfo.totalRam,
                  freeBytes: info.memoryInfo.availableRam,
                  usagePercent: info.memoryInfo.usagePercentage,
                ),
                if (info.deviceInfo.buildInfo.isNotEmpty) ...[const SizedBox(height: 14), _BuildInfoCard(buildInfo: info.deviceInfo.buildInfo)],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  final DeviceInfo device;

  const _HeaderBanner({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFEC4899)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withAlpha(80), blurRadius: 14, offset: const Offset(0, 6))],
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
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
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

  const _StatCard({required this.title, required this.value, required this.subtitle, required this.icon, required this.iconColor});

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
            Text(
              value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}

/// Generic, highly reusable resource card handling both Storage and RAM metrics.
/// Eliminates code duplication for progress bars, percentage badges, and byte calculations.
class _ResourceUsageCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final int usedBytes;
  final int totalBytes;
  final int freeBytes;
  final double usagePercent;

  const _ResourceUsageCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.usedBytes,
    required this.totalBytes,
    required this.freeBytes,
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
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${usagePercent.toStringAsFixed(1)}% Used', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text('${usedBytes.toReadableBytes()} / ${totalBytes.toReadableBytes()}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
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
            Text('Available: ${freeBytes.toReadableBytes()}', style: const TextStyle(fontSize: 11, color: Colors.white60)),
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
          title: const Text('DETAILED BUILD INFO', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
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
                      child: Text(entry.value?.toString() ?? 'N/A', style: const TextStyle(color: Colors.white, fontSize: 12)),
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
            ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

/// Clean extension on [int] to eliminate repeated formatBytes boilerplate.
extension ByteFormatting on int {
  String toReadableBytes({int decimals = 1}) {
    if (this <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(this) / log(1024)).floor().clamp(0, suffixes.length - 1);
    return '${(this / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
