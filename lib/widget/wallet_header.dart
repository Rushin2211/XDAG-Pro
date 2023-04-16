import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xdag/common/color.dart';
import 'package:xdag/common/helper.dart';
import 'package:xdag/model/db_model.dart';
import 'package:xdag/model/wallet_modal.dart';
import 'package:xdag/page/detail/contacts_page.dart';
import 'package:xdag/page/detail/receive_page.dart';
import 'package:xdag/page/detail/wallet_detail.dart';
import 'package:xdag/widget/desktop.dart';
import 'package:xdag/widget/home_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({super.key});

  @override
  Widget build(BuildContext context) {
    WalletModal walletModal = Provider.of<WalletModal>(context);
    Wallet wallet = walletModal.getWallet();
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          if (!wallet.isBackup)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: MyCupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pushNamed(context, '/back_up_test_start'),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: DarkColors.redColorMask2,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).backup_your_wallet,
                          style: const TextStyle(fontSize: 12, fontFamily: 'RobotoMono', fontWeight: FontWeight.w400, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white),
                    ],
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
          Container(
            decoration: BoxDecoration(
              color: DarkColors.blockColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Image.asset('images/logo.png', width: 40, height: 40),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            decoration: BoxDecoration(
                              color: DarkColors.redColorMask,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "TEST",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            wallet.hideBalance == true ? "****" : "${wallet.amount} XDAG",
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                MyCupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: wallet.address));
                    Helper.showToast(context, AppLocalizations.of(context).copied_to_clipboard);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    // color: Colors.amber,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            wallet.address,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 12, fontFamily: 'RobotoMono', fontWeight: FontWeight.w400, color: Colors.white54),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy_rounded, size: 12, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: HomeHeaderButton(
                title: AppLocalizations.of(context).security,
                icon: wallet.isBackup ? 'images/security_1.png' : 'images/security.png',
                onPressed: () async {
                  Helper.changeAndroidStatusBar(true);
                  await Helper.showBottomSheet(context, const WalletDetailPage());
                  Helper.changeAndroidStatusBar(false);
                },
              )),
              const SizedBox(width: 15),
              Expanded(
                  child: HomeHeaderButton(
                title: AppLocalizations.of(context).send,
                icon: 'images/send.png',
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: DarkColors.bgColor,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext buildContext) => const ContactsPage(),
                  );
                },
              )),
              const SizedBox(width: 15),
              Expanded(
                  child: HomeHeaderButton(
                title: AppLocalizations.of(context).receive,
                icon: 'images/receive.png',
                onPressed: () async {
                  Helper.changeAndroidStatusBar(true);
                  await Helper.showBottomSheet(context, const ReceivePage());
                  Helper.changeAndroidStatusBar(false);
                },
              )),
            ],
          ),
        ],
      ),
    );
  }
}
