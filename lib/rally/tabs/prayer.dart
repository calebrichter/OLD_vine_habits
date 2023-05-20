// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:vine_habits/rally/charts/pie_chart.dart';
import 'package:vine_habits/rally/data.dart';
import 'package:vine_habits/rally/finance.dart';
import 'package:vine_habits/rally/tabs/sidebar.dart';

/// A page that shows a summary of bills.
class PrayerView extends StatefulWidget {
  const PrayerView({super.key});

  @override
  State<PrayerView> createState() => _PrayerViewState();
}

class _PrayerViewState extends State<PrayerView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getBillDataList(context);
    final dueTotal = sumBillDataPrimaryAmount(items);
    final paidTotal = sumBillDataPaidAmount(items);
    final detailItems = DummyDataService.getBillDetailList(
      context,
      dueTotal: dueTotal,
      paidTotal: paidTotal,
    );

    return TabWithSidebar(
      restorationId: 'bills_view',
      mainView: FinancialEntityView(
        heroLabel: AppLocalizations.of(context)!.rallyBillsDue,
        heroAmount: dueTotal,
        segments: buildSegmentsFromBillItems(items),
        wholeAmount: dueTotal,
        financialEntityCards: buildBillDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
