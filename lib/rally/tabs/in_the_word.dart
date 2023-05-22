// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:vine_habits/rally/data.dart';
import 'package:vine_habits/rally/finance.dart';
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
    ];
    return TabWithSidebar(
      restorationId: 'accounts_view',
      //TODO:: tear this biz apart.
      // keep the aesthetics, but make it a list of verses.
      mainView: FinancialEntityView(
        quotes: quotes,
        financialEntityCards: buildAccountDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
