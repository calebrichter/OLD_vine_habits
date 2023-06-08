// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vine_habits/rally/colors.dart';

import 'package:vine_habits/rally/data.dart';
import 'package:vine_habits/rally/tabs/cards/in_the_word_cards_simple.dart';
import 'package:vine_habits/rally/tabs/sidebar.dart';

/// A page that shows a summary of accounts.
class InTheWordView extends StatelessWidget {
  const InTheWordView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getAccountDataList(context);
    final detailItems = DummyDataService.getAccountDetailList(context);
    final quotes = [
      "Blessed are those who hear my words and put them into practice.",
      "The Word of God is living and active.",
      "The Word of God is sharper than any two-edged sword.",
      "The Word of God is a lamp unto my feet and a light unto my path.",
      "Man does not live by bread alone, but by every word that proceeds from the mouth of God.",
    ];
    return TabWithSidebar(
      restorationId: 'accounts_view',
      // title: GalleryLocalizations.of(context).rallyAccounts,
      //TODO:: tear this biz apart.
      // keep the aesthetics, but make it a list of verses.
      mainView: InTheWordEntityView(quotes: quotes, hearTheWordCards: [
        const HearTheWordViewSimple(),
      ]),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
