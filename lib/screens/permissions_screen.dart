import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../design_system/design_system.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  Map<Permission, PermissionStatus> _permissionStatuses = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final permissions = [
        Permission.microphone,
        Permission.storage,
        Permission.notification,
      ];

      final statuses = <Permission, PermissionStatus>{};
      for (final permission in permissions) {
        statuses[permission] = await permission.status;
      }

      setState(() {
        _permissionStatuses = statuses;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error checking permissions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPermission(Permission permission) async {
    try {
      // Verificar se a permissão pode ser solicitada
      if (permission == Permission.manageExternalStorage) {
        _showPermissionInfoDialog(permission);
        return;
      }

      final status = await permission.request();
      setState(() {
        _permissionStatuses[permission] = status;
      });

      if (status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '✅ Permissão ${_getPermissionName(permission)} concedida!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('❌ Permissão ${_getPermissionName(permission)} negada'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (status.isPermanentlyDenied) {
        _showPermissionSettingsDialog(permission);
      }
    } catch (e) {
      print('❌ Error requesting permission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erro ao solicitar permissão: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPermissionSettingsDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão Necessária'),
        content: Text(
          'A permissão ${_getPermissionName(permission)} foi negada permanentemente. '
          'Você precisa habilitá-la nas configurações do dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }

  void _showPermissionInfoDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informação sobre Permissão'),
        content: Text(
          'A permissão ${_getPermissionName(permission)} não é necessária para o funcionamento básico do app. '
          'Esta permissão é opcional e pode ser ignorada.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  String _getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.microphone:
        return 'Microfone';
      case Permission.storage:
        return 'Armazenamento';
      case Permission.notification:
        return 'Notificações';
      default:
        return permission.toString();
    }
  }

  String _getPermissionDescription(Permission permission) {
    switch (permission) {
      case Permission.microphone:
        return 'Necessário para TTS e gravação de áudio';
      case Permission.storage:
        return 'Necessário para salvar configurações e dados do app';
      case Permission.notification:
        return 'Necessário para notificações do app';
      default:
        return 'Permissão necessária para o funcionamento do app';
    }
  }

  Color _getStatusColor(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
        return Colors.orange;
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      case PermissionStatus.restricted:
        return Colors.grey;
      case PermissionStatus.limited:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Concedida';
      case PermissionStatus.denied:
        return 'Negada';
      case PermissionStatus.permanentlyDenied:
        return 'Negada Permanentemente';
      case PermissionStatus.restricted:
        return 'Restrita';
      case PermissionStatus.limited:
        return 'Limitada';
      default:
        return 'Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DSHeader(
        title: 'Permissões do App',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  DSCard(
                    sp4: true,
                    br3: true,
                    child: Column(
                      children: [
                        DSIcon(
                          Icons.security,
                          icon8: true,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const DSVerticalSpacing.sm(),
                        const DSTitle(
                          'Permissões do App',
                          textAlign: TextAlign.center,
                        ),
                        const DSVerticalSpacing.sm(),
                        const DSBody(
                          'O app precisa das seguintes permissões para funcionar corretamente:',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const DSVerticalSpacing.lg(),

                  // Permissões Automáticas
                  const DSCard(
                    sp4: true,
                    br3: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            DSIcon(
                              Icons.check_circle,
                              color: Colors.green,
                              icon3: true,
                            ),
                            DSHorizontalSpacing.md(),
                            DSTitle('Permissões Automáticas'),
                          ],
                        ),
                        DSVerticalSpacing.sm(),
                        DSBody(
                            'Estas permissões são concedidas automaticamente:'),
                        DSVerticalSpacing.sm(),
                        DSBody('• Internet - Para conectividade'),
                        DSBody('• Wake Lock - Para manter TTS ativo'),
                        DSBody('• Modificar Configurações de Áudio - Para TTS'),
                        DSBody(
                            '• Acesso ao Estado da Rede - Para verificar conectividade'),
                      ],
                    ),
                  ),

                  const DSVerticalSpacing.xl2(),

                  // Permissions List
                  Expanded(
                    child: ListView.separated(
                      itemCount: _permissionStatuses.length,
                      separatorBuilder: (context, index) =>
                          const DSVerticalSpacing.md(),
                      itemBuilder: (context, index) {
                        final permission =
                            _permissionStatuses.keys.elementAt(index);
                        final status = _permissionStatuses[permission]!;

                        return DSCard(
                          sp4: true,
                          br3: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getStatusColor(status) == Colors.green
                                        ? Icons.check_circle
                                        : Icons.warning,
                                    color: _getStatusColor(status),
                                    size: 24,
                                  ),
                                  const DSHorizontalSpacing.md(),
                                  Expanded(
                                    child:
                                        DSTitle(_getPermissionName(permission)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(status)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getStatusText(status),
                                      style: TextStyle(
                                        color: _getStatusColor(status),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const DSVerticalSpacing.sm(),
                              DSBody(_getPermissionDescription(permission)),
                              const DSVerticalSpacing.md(),
                              if (status != PermissionStatus.granted)
                                DSButton(
                                  text: status ==
                                          PermissionStatus.permanentlyDenied
                                      ? 'Abrir Configurações'
                                      : 'Solicitar Permissão',
                                  icon: status ==
                                          PermissionStatus.permanentlyDenied
                                      ? Icons.settings
                                      : Icons.security,
                                  primary: true,
                                  onPressed: () =>
                                      _requestPermission(permission),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const DSVerticalSpacing.xl2(),

                  // Action Buttons
                  DSButton(
                    text: 'Verificar Novamente',
                    icon: Icons.refresh,
                    primary: false,
                    large: true,
                    onPressed: _checkPermissions,
                  ),
                ],
              ),
            ),
    );
  }
}
