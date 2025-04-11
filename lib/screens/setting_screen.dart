import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _audioEnabled = true;
  bool _vibrationEnabled = true;
  bool _countdownEnabled = true;
  double _speechRate = 0.5;
  double _volume = 1.0;
  String _language = "en-US";
  bool _isLoading = true;
  late FlutterTts _flutterTts;
  List<String> _availableLanguages = ["en-US"];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadSettings();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    // Get available languages if possible
    try {
      final languages = await _flutterTts.getLanguages;
      if (languages != null) {
        setState(() {
          _availableLanguages = List<String>.from(languages);
        });
      }
    } catch (e) {
      // Fallback to default if getting languages fails
      _availableLanguages = ["en-US"];
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _audioEnabled = prefs.getBool('audioEnabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
      _countdownEnabled = prefs.getBool('countdownEnabled') ?? true;
      _speechRate = prefs.getDouble('speechRate') ?? 0.5;
      _volume = prefs.getDouble('volume') ?? 1.0;
      _language = prefs.getString('language') ?? "en-US";
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audioEnabled', _audioEnabled);
    await prefs.setBool('vibrationEnabled', _vibrationEnabled);
    await prefs.setBool('countdownEnabled', _countdownEnabled);
    await prefs.setDouble('speechRate', _speechRate);
    await prefs.setDouble('volume', _volume);
    await prefs.setString('language', _language);
  }

  // Test the TTS with current settings
  Future<void> _testTts() async {
    if (_audioEnabled) {
      await _flutterTts.setLanguage(_language);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setVolume(_volume);
      await _flutterTts.speak("This is a test of the voice notification");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio notifications are disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                children: [
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ListTile(
                            title: Text(
                              'Notification Settings',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SwitchListTile(
                            title: const Text('Audio Notifications'),
                            subtitle: const Text('Enable voice instructions'),
                            value: _audioEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _audioEnabled = value;
                              });
                              _saveSettings();
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Vibration'),
                            subtitle: const Text(
                              'Vibrate when intervals change',
                            ),
                            value: _vibrationEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _vibrationEnabled = value;
                              });
                              _saveSettings();
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Countdown Notifications'),
                            subtitle: const Text(
                              'Announce when approaching interval end',
                            ),
                            value: _countdownEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _countdownEnabled = value;
                              });
                              _saveSettings();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_audioEnabled)
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ListTile(
                              title: Text(
                                'Voice Settings',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: const Text('Speech Rate'),
                              subtitle: Slider(
                                value: _speechRate,
                                min: 0.1,
                                max: 1.0,
                                divisions: 9,
                                label: _speechRate.toStringAsFixed(1),
                                onChanged: (double value) {
                                  setState(() {
                                    _speechRate = value;
                                  });
                                  _saveSettings();
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Volume'),
                              subtitle: Slider(
                                value: _volume,
                                min: 0.1,
                                max: 1.0,
                                divisions: 9,
                                label: _volume.toStringAsFixed(1),
                                onChanged: (double value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                  _saveSettings();
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Language'),
                              subtitle: DropdownButton<String>(
                                value:
                                    _availableLanguages.contains(_language)
                                        ? _language
                                        : _availableLanguages.first,
                                isExpanded: true,
                                items:
                                    _availableLanguages.map((String lang) {
                                      return DropdownMenuItem<String>(
                                        value: lang,
                                        child: Text(lang),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _language = newValue;
                                    });
                                    _saveSettings();
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.volume_up),
                                  label: const Text('Test Voice'),
                                  onPressed: _testTts,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'C25K Runner',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Version 1.0.0',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
