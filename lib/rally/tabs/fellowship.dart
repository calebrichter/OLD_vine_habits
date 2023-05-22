// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:vine_habits/rally/charts/pie_chart.dart';
import 'package:vine_habits/rally/data.dart';
import 'package:vine_habits/rally/finance.dart';
import 'package:vine_habits/rally/tabs/sidebar.dart';

class FellowshipView extends StatefulWidget {
  const FellowshipView({super.key});

  @override
  State<FellowshipView> createState() => _FellowshipViewState();
}

class _FellowshipViewState extends State<FellowshipView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getBudgetDataList(context);
    final capTotal = sumBudgetDataPrimaryAmount(items);
    final usedTotal = sumBudgetDataAmountUsed(items);
    final detailItems = DummyDataService.getBudgetDetailList(
      context,
      capTotal: capTotal,
      usedTotal: usedTotal,
    );

    return TabWithSidebar(
      restorationId: 'budgets_view',
      mainView: FinancialEntityView(
        quotes: [],
        financialEntityCards: buildBudgetDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
