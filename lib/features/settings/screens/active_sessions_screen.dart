import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../config/theme/app_colors.dart';

class ActiveSessionsScreen extends StatefulWidget {
  const ActiveSessionsScreen({super.key});

  @override
  State<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends State<ActiveSessionsScreen> {
  List<dynamic>? _sessions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final sessions = await authProvider.getActiveSessions();
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.activeSessions, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessions == null || _sessions!.isEmpty
              ? Center(child: Text(l10n.noActiveSessions))
              : RefreshIndicator(
                  onRefresh: _fetchSessions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _sessions!.length,
                    itemBuilder: (context, index) {
                      final session = _sessions![index];
                      final lastActive = DateTime.parse(session['lastActive']);
                      final formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(lastActive);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: CircleAvatar(
                            backgroundColor: index == 0 ? Colors.green : AppColors.primary,
                            child: Icon(index == 0 ? Icons.smartphone : Icons.devices, color: Colors.white),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  session['deviceName'], 
                                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (index == 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(l10n.current, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(l10n.ip(session['ipAddress'] ?? 'Unknown'), style: TextStyle(fontSize: 12, color: theme.hintColor)),
                              Text(l10n.lastActive(formattedDate), style: TextStyle(fontSize: 12, color: theme.hintColor)),
                            ],
                          ),
                          trailing: index == 0 
                            ? null 
                            : IconButton(
                                icon: const Icon(Icons.logout, color: Colors.red),
                                onPressed: () => _revokeSession(session['id'], l10n),
                              ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Future<void> _revokeSession(String sessionId, AppLocalizations l10n) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.revokeSession(sessionId);
    if (success) {
      _fetchSessions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.sessionRevoked)),
        );
      }
    }
  }
}
