import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_way_smart_people_talk/cipher.dart';
import 'package:the_way_smart_people_talk/cipher_base.dart';
import 'package:the_way_smart_people_talk/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _encryptPlaintextController;
  late TextEditingController _encryptArgotController;

  late TextEditingController _decryptArgotController;
  late TextEditingController _decryptPlaintextController;

  late Cipher _cipher;
  late CipherType _cipherType;

  void setCipherByType(CipherType cipherType) {
    setState(() {
      _cipherType = cipherType;
      switch (cipherType) {
        case CipherType.easy16:
          _cipher = CipherRadix(16);
          break;
        case CipherType.easyNhywzy:
          _cipher = CipherEasyNhywzy();
          break;
        case CipherType.normalNhywzy:
          _cipher = CipherNormalNhywzy();
          break;
      }
    });
  }

  void cipherTypeRadioChanged(CipherType? cipherType) {
    setCipherByType(cipherType!);
    GlobalAppProfile.saveCipherType(cipherType);
    encrypt();
    decrypt();
    Navigator.pop(context);
  }

  void encrypt() {
    _encryptArgotController.text =
        _cipher.encrypt(_encryptPlaintextController.text);
  }

  void decrypt() {
    _decryptPlaintextController.text =
        _decryptArgotController.text.isNotEmpty &&
                _decryptArgotController.text != ''
            ? _cipher.decrypt(_decryptArgotController.text)
            : '';
  }

  Future<String?> getClipboardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  void setClipboardData(String string) {
    Clipboard.setData(ClipboardData(text: string));
  }

  void copyArgotAfterEncoding() {
    setClipboardData(_encryptArgotController.text);
  }

  void copyPlaintextAfterDecoding() {
    setClipboardData(_decryptPlaintextController.text);
  }

  @override
  void initState() {
    _encryptPlaintextController = TextEditingController();
    _encryptArgotController = TextEditingController();

    _decryptArgotController = TextEditingController();
    _decryptPlaintextController = TextEditingController();

    _cipherType = GlobalAppProfile.cipherType;
    setCipherByType(_cipherType);

    super.initState();

    _encryptPlaintextController.addListener(() => encrypt());
    _decryptArgotController.addListener(() => decrypt());
  }

  @override
  void dispose() {
    _encryptPlaintextController.dispose();
    _encryptArgotController.dispose();

    _decryptArgotController.dispose();
    _decryptPlaintextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('????????????????????????'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
            child: ListView(
          children: [
            const Text(
              '???????????????????????????',
              textAlign: TextAlign.center,
            ),
            const Divider(),
            for (var cipherType in CipherType.values)
              RadioListTile(
                  value: cipherType,
                  title: Text(getCipherTypeDescription(cipherType)),
                  groupValue: _cipherType,
                  onChanged: cipherTypeRadioChanged),
          ],
        )),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                Text('?????????????????????: ${getCipherTypeDescription(_cipherType)}'),
              ],
            ),
            const Divider(
              height: 5,
              color: Colors.black,
            ),
            Column(
              // ????????????
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    getClipboardData().then((clipboardText) => {
                          _encryptPlaintextController.text =
                              clipboardText ?? '',
                          copyArgotAfterEncoding()
                        });
                  },
                  icon: const Icon(Icons.paste),
                  label: const Text(
                    '????????????????????????"??????????????????"?????????????????????',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _encryptPlaintextController.clear,
                  icon: const Icon(Icons.clear),
                  label: const Text(
                    '??????"??????????????????"',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: '???????????????',
                      hintText: '????????????????????????',
                      border: OutlineInputBorder()),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  controller: _encryptPlaintextController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: '???????????????',
                      hintText: '???????????????',
                      border: OutlineInputBorder()),
                  // enabled: false,
                  controller: _encryptArgotController,
                ),
                ElevatedButton.icon(
                  onPressed: copyArgotAfterEncoding,
                  icon: const Icon(Icons.copy),
                  label: const Text(
                    '?????????????????????????????????',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 5,
              color: Colors.black,
            ),
            Column(
              // ????????????
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      getClipboardData().then((clipboardData) => {
                            _decryptArgotController.text = clipboardData ?? '',
                            copyPlaintextAfterDecoding()
                          });
                    },
                    icon: const Icon(Icons.paste),
                    label: const Text(
                      '????????????????????????"??????????????????"?????????????????????',
                      overflow: TextOverflow.ellipsis,
                    )),
                ElevatedButton.icon(
                  onPressed: _decryptArgotController.clear,
                  icon: const Icon(Icons.clear),
                  label: const Text(
                    '??????"??????????????????"',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: '???????????????',
                      hintText: '????????????????????????',
                      border: OutlineInputBorder()),
                  controller: _decryptArgotController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: '???????????????',
                      hintText: '???????????????',
                      border: OutlineInputBorder()),
                  // enabled: false,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  controller: _decryptPlaintextController,
                ),
                ElevatedButton.icon(
                  onPressed: copyPlaintextAfterDecoding,
                  icon: const Icon(Icons.copy),
                  label: const Text(
                    '?????????????????????????????????',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
