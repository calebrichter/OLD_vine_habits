// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:vine_habits/data/gallery_options.dart';
import 'package:vine_habits/layout/adaptive.dart';
import 'package:vine_habits/layout/text_scale.dart';
import 'package:vine_habits/rally/charts/line_chart.dart';
import 'package:vine_habits/rally/charts/vertical_fraction_bar.dart';
import 'package:vine_habits/rally/colors.dart';
import 'package:vine_habits/rally/data.dart';
import 'package:vine_habits/rally/formatters.dart';
import 'package:vine_habits/rally/charts/rotating_quote.dart';
import 'package:vine_habits/rally/charts/pie_chart.dart';

class InTheWordEntityView extends StatelessWidget {
  const InTheWordEntityView({
    super.key,
    required this.quotes,
    required this.hearTheWordCards,
  });

  /// The amounts to assign each item.
  final List<String> quotes;
  final List<HearTheWordView> hearTheWordCards;

  @override
  Widget build(BuildContext context) {
    final maxWidth = pieChartMaxSize + (cappedTextScale(context) - 1.0) * 100.0;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              // We decrease the max height to ensure the [RallyPieChart] does
              // not take up the full height when it is smaller than
              // [kPieChartMaxSize].
              maxHeight: math.min(
                constraints.biggest.shortestSide * 0.5,
                maxWidth,
              ),
            ),
            child: RotatingQuoteWidget(
              quotes: quotes,
            ),
          ),
          Container(
            height: 1,
            constraints: BoxConstraints(maxWidth: maxWidth),
            color: RallyColors.inputBackground,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            color: RallyColors.cardBackground,
            child: Column(children: [
              // add a child card for each separate point of the habits
              hearTheWordCards[0],
            ]),
          ),
        ],
      );
    });
  }
}

/// A reusable widget to show balance information of a single entity as a card.
class HearTheWordView extends StatelessWidget {
  const HearTheWordView({
    super.key,
    required this.indicatorColor,
    required this.indicatorFraction,
    required this.title,
    required this.subtitle,
    required this.semanticsLabel,
    required this.suffix,
  });

  final Color indicatorColor;
  final double indicatorFraction;
  final String title;
  final String subtitle;
  final String semanticsLabel;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        button: true,
        enabled: true,
        label: semanticsLabel,
      ),
      excludeSemantics: true,
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 350),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, openContainer) =>
            FinancialEntityCategoryDetailsPage(),
        openColor: RallyColors.primaryBackground,
        closedColor: RallyColors.primaryBackground,
        closedElevation: 0,
        closedBuilder: (context, openContainer) {
          return TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: openContainer,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 32 + 60 * (cappedTextScale(context) - 1),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: VerticalFractionBar(
                          color: indicatorColor,
                          fraction: indicatorFraction,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: textTheme.bodyMedium!
                                      .copyWith(fontSize: 16),
                                ),
                                Text(
                                  subtitle,
                                  style: textTheme.bodyMedium!
                                      .copyWith(color: RallyColors.gray60),
                                ),
                              ],
                            ),
                            Text(
                              'Hear the Word',
                              style: textTheme.bodyLarge!.copyWith(
                                fontSize: 20,
                                color: RallyColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 32),
                        padding: const EdgeInsetsDirectional.only(start: 12),
                        child: suffix,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: RallyColors.dividerColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Data model for [HearTheWordView].
class FinancialEntityCategoryModel {
  const FinancialEntityCategoryModel(
    this.indicatorColor,
    this.indicatorFraction,
    this.title,
    this.subtitle,
    this.usdAmount,
    this.suffix,
  );

  final Color indicatorColor;
  final double indicatorFraction;
  final String title;
  final String subtitle;
  final double usdAmount;
  final Widget suffix;
}

HearTheWordView buildFinancialEntityFromAccountData(
  AccountData model,
  int accountDataIndex,
  BuildContext context,
) {
  final amount = usdWithSignFormat(context).format(model.primaryAmount);
  final shortAccountNumber = model.accountNumber.substring(6);
  return HearTheWordView(
    suffix: const Icon(Icons.chevron_right, color: Colors.grey),
    title: model.name,
    subtitle: '• • • • • • $shortAccountNumber',
    semanticsLabel: AppLocalizations.of(context)!.rallyAccountAmount(
      model.name,
      shortAccountNumber,
      amount,
    ),
    indicatorColor: RallyColors.accountColor(accountDataIndex),
    indicatorFraction: 1,
  );
}

HearTheWordView buildFinancialEntityFromBillData(
  BillData model,
  int billDataIndex,
  BuildContext context,
) {
  final amount = usdWithSignFormat(context).format(model.primaryAmount);
  return HearTheWordView(
    suffix: const Icon(Icons.chevron_right, color: Colors.grey),
    title: model.name,
    subtitle: model.dueDate,
    semanticsLabel: AppLocalizations.of(context)!.rallyBillAmount(
      model.name,
      model.dueDate,
      amount,
    ),
    indicatorColor: RallyColors.billColor(billDataIndex),
    indicatorFraction: 1,
  );
}

HearTheWordView buildFinancialEntityFromBudgetData(
  BudgetData model,
  int budgetDataIndex,
  BuildContext context,
) {
  final amountUsed = usdWithSignFormat(context).format(model.amountUsed);
  final primaryAmount = usdWithSignFormat(context).format(model.primaryAmount);
  final amount =
      usdWithSignFormat(context).format(model.primaryAmount - model.amountUsed);

  return HearTheWordView(
    suffix: Text(
      AppLocalizations.of(context)!.rallyFinanceLeft,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: RallyColors.gray60, fontSize: 10),
    ),
    title: model.name,
    subtitle: '$amountUsed / $primaryAmount',
    semanticsLabel: AppLocalizations.of(context)!.rallyBudgetAmount(
      model.name,
      model.amountUsed,
      model.primaryAmount,
      amount,
    ),
    indicatorColor: RallyColors.budgetColor(budgetDataIndex),
    indicatorFraction: model.amountUsed / model.primaryAmount,
  );
}

List<HearTheWordView> buildAccountDataListViews(
  List<AccountData> items,
  BuildContext context,
) {
  return List<HearTheWordView>.generate(
    items.length,
    (i) => buildFinancialEntityFromAccountData(items[i], i, context),
  );
}

List<HearTheWordView> buildBillDataListViews(
  List<BillData> items,
  BuildContext context,
) {
  return List<HearTheWordView>.generate(
    items.length,
    (i) => buildFinancialEntityFromBillData(items[i], i, context),
  );
}

List<HearTheWordView> buildBudgetDataListViews(
  List<BudgetData> items,
  BuildContext context,
) {
  return <HearTheWordView>[
    for (int i = 0; i < items.length; i++)
      buildFinancialEntityFromBudgetData(items[i], i, context)
  ];
}

class FinancialEntityCategoryDetailsPage extends StatelessWidget {
  FinancialEntityCategoryDetailsPage({super.key});

  final List<DetailedEventData> items =
      DummyDataService.getDetailedEventItems();

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return ApplyTextOptions(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.rallyAccountDataChecking,
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: RallyLineChart(events: items),
            ),
            Expanded(
              child: Padding(
                padding: isDesktop ? const EdgeInsets.all(40) : EdgeInsets.zero,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (DetailedEventData detailedEventData in items)
                      _DetailedEventCard(
                        title: detailedEventData.title,
                        date: detailedEventData.date,
                        amount: detailedEventData.amount,
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

class _DetailedEventCard extends StatelessWidget {
  const _DetailedEventCard({
    required this.title,
    required this.date,
    required this.amount,
  });

  final String title;
  final DateTime date;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _EventTitle(title: title),
                      ),
                      _EventDate(date: date),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _EventAmount(amount: amount),
                        ),
                      ),
                    ],
                  )
                : Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _EventTitle(title: title),
                          _EventDate(date: date),
                        ],
                      ),
                      _EventAmount(amount: amount),
                    ],
                  ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              color: RallyColors.dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventAmount extends StatelessWidget {
  const _EventAmount({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      usdWithSignFormat(context).format(amount),
      style: textTheme.bodyLarge!.copyWith(
        fontSize: 20,
        color: RallyColors.gray,
      ),
    );
  }
}

class _EventDate extends StatelessWidget {
  const _EventDate({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      shortDateFormat(context).format(date),
      semanticsLabel: longDateFormat(context).format(date),
      style: textTheme.bodyMedium!.copyWith(color: RallyColors.gray60),
    );
  }
}

class _EventTitle extends StatelessWidget {
  const _EventTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: textTheme.bodyMedium!.copyWith(fontSize: 16),
    );
  }
}
