// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:vine_habits/data/gallery_options.dart';
import 'package:vine_habits/layout/adaptive.dart';
import 'package:vine_habits/layout/text_scale.dart';
import 'package:vine_habits/rally/charts/vertical_fraction_bar.dart';
import 'package:vine_habits/rally/colors.dart';
import 'package:vine_habits/rally/charts/rotating_quote.dart';
import 'package:vine_habits/rally/charts/pie_chart.dart';
import 'package:url_launcher/url_launcher.dart';

class InTheWordEntityView extends StatelessWidget {
  const InTheWordEntityView({
    super.key,
    required this.quotes,
    required this.hearTheWordCards,
  });

  /// The amounts to assign each item.
  final List<String> quotes;
  final List<HearTheWordViewSimple> hearTheWordCards;

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
class HearTheWordViewSimple extends StatelessWidget {
  const HearTheWordViewSimple({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics.fromProperties(
      properties: const SemanticsProperties(
        button: true,
        enabled: true,
        label: 'Hear the word',
      ),
      excludeSemantics: true,
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 350),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, openContainer) => HearTheWordDetailsPage(),
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
                        child: const VerticalFractionBar(
                          color: Colors.red,
                          fraction: 1,
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
                                  'title',
                                  style: textTheme.bodyMedium!
                                      .copyWith(fontSize: 16),
                                ),
                                Text(
                                  'subtitle',
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
                        child: Text('Suffix'),
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

class HearTheWordDetailsPage extends StatelessWidget {
  const HearTheWordDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final List<String> sermonLinks = [
      'https://www.youtube.com/@videosonthevine7634/streams',
    ];
    return ApplyTextOptions(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Hear The Word',
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
                height: 200,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    child: Center(
                      child: Text(
                        'Hear The Word',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: RallyColors.gray60,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                )),
            Expanded(
              child: Padding(
                padding: isDesktop ? const EdgeInsets.all(40) : EdgeInsets.zero,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Create child for Sermons in Worship
                    OpenContainerLinkButton(externalLinks: sermonLinks),
                    //TODO: Create child for Online Bibles
                    //TODO: Create child for Sermons on podcast
                    //TODO: Create child for How to improve your hearing -> expands into new card
                    // see DetialedEventCard for spacing/alignment
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

class SermonsCard extends StatelessWidget {
  const SermonsCard({
    super.key,
  });

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
                        child: Text('Title'),
                      ),
                      Text('Subtext'),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Placeholder(),
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
                        children: [],
                      ),
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

class LinkListPage extends StatelessWidget {
  const LinkListPage({
    super.key,
    required this.externalLinks,
  });
  final List<String> externalLinks;
  @override
  Widget build(BuildContext context) {
    bool isDesktop = isDisplayDesktop(context);
    return ApplyTextOptions(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('Sermon Links',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 18)),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Center(
                    child: Text(
                      'Hear The Word',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: RallyColors.gray60,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: isDesktop ? const EdgeInsets.all(40) : EdgeInsets.zero,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Create child for Sermons in Worship
                    Text(isDesktop.toString()),
                    for (var link in externalLinks)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        child: isDesktop
                            ? Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: InkWell(
                                        child: Text(link),
                                        onTap: () {
                                          openUrl(link);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child: Text(link),
                                        onTap: () {
                                          openUrl(link);
                                        },
                                      ),
                                      Placeholder(),
                                    ],
                                  ),
                                ],
                              ),
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

void openUrl(String urlToParse) async {
  Uri url = Uri.parse(urlToParse);
  var urllaunchable =
      await canLaunchUrl(url); //canLaunch is from url_launcher package
  if (urllaunchable) {
    await launchUrl(url); //launch is from url_launcher package to launch URL
  } else {
    throw ("URL can't be launched.");
  }
}

class OpenContainerLinkButton extends StatelessWidget {
  const OpenContainerLinkButton({
    super.key,
    required this.externalLinks,
  });
  final List<String> externalLinks;
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return TextButton(
          onPressed: openContainer,
          child: Text(
            'Sermon Links',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: RallyColors.gray60,
                  fontWeight: FontWeight.w600,
                ),
          ),
        );
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return LinkListPage(externalLinks: externalLinks);
      },
      transitionDuration: Duration(milliseconds: 499),
      transitionType: ContainerTransitionType.fadeThrough,
    );
  }
}
