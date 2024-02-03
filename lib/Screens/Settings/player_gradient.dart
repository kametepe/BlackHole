/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 * 
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2023, Ankit Sangwan
 */

import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/Helpers/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlayerGradientSelection extends StatefulWidget {
  const PlayerGradientSelection({super.key});

  @override
  State<PlayerGradientSelection> createState() =>
      _PlayerGradientSelectionState();
}

class _PlayerGradientSelectionState extends State<PlayerGradientSelection> {
  final List<String> types = [
    'simple',
    'halfLight',
    'halfDark',
    'fullLight',
    'fullDark',
    'fullDarkOnly',
    'fullMix',
    'fullMixDarker',
    'fullMixBlack',
  ];
  final Set<String> recommended = {
    'halfDark',
    'fullDark',
    'fullMixBlack',
  };
  final Map<String, String> typeMapping = {
    'simple': 'Simple',
    'halfLight': 'Half Light',
    'halfDark': 'Half Dark',
    'fullLight': 'Full Light',
    'fullDark': 'Full Dark',
    'fullDarkOnly': 'Full Dark Only',
    'fullMix': 'Full Mix',
    'fullMixDarker': 'Full Mix Darker',
    'fullMixBlack': 'Full Mix Black',
  };
  final List<Color?> gradientColor = [Colors.lightGreen, Colors.teal];
  final MyTheme currentTheme = GetIt.I<MyTheme>();
  String gradientType = Hive.box('settings')
      .get('gradientType', defaultValue: 'halfDark')
      .toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(
            context,
          )!
              .playerScreenBackground,
        ),
      ),
      body: SafeArea(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: MediaQuery.sizeOf(context).width >
                  MediaQuery.sizeOf(context).height
              ? 6
              : 3,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          physics: const BouncingScrollPhysics(),
          childAspectRatio: 0.6,
          children: types
              .map(
                (type) => GestureDetector(
                  onTap: () {
                    setState(() {
                      gradientType = type;
                      Hive.box('settings').put('gradientType', type);
                    });
                  },
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Card(
                          elevation: 5,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: gradientType == type ? 1.0 : 0.3,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          // ignore: use_decorated_box
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: type == 'simple'
                                    ? Alignment.topLeft
                                    : Alignment.topCenter,
                                end: type == 'simple'
                                    ? Alignment.bottomRight
                                    : (type == 'halfLight' ||
                                            type == 'halfDark')
                                        ? Alignment.center
                                        : Alignment.bottomCenter,
                                colors: type == 'simple'
                                    ? Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? currentTheme.getBackGradient()
                                        : [
                                            const Color(0xfff5f9ff),
                                            Colors.white,
                                          ]
                                    : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? [
                                            if (type == 'halfDark' ||
                                                type == 'fullDark' ||
                                                type == 'fullDarkOnly')
                                              gradientColor[1] ??
                                                  Colors.grey[900]!
                                            else
                                              gradientColor[0] ??
                                                  Colors.grey[900]!,
                                            if (type == 'fullMix' ||
                                                type == 'fullMixDarker' ||
                                                type == 'fullMixBlack' ||
                                                type == 'fullDarkOnly')
                                              gradientColor[1] ?? Colors.black
                                            else
                                              Colors.black,
                                            if (type == 'fullMixDarker')
                                              gradientColor[1] ?? Colors.black,
                                            if (type == 'fullMixBlack')
                                              Colors.black,
                                          ]
                                        : [
                                            gradientColor[0] ??
                                                const Color(0xfff5f9ff),
                                            Colors.white,
                                          ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Spacer(
                              flex: 3,
                            ),
                            Center(
                              child: GradientCard(
                                child: FittedBox(
                                  child: SizedBox.square(
                                    dimension:
                                        MediaQuery.sizeOf(context).width / 5,
                                    child: gradientType == type
                                        ? const Icon(Icons.check_rounded)
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                            Center(
                              child: Text(
                                typeMapping[type]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.skip_previous_rounded),
                                  if (gradientType == type)
                                    const Icon(Icons.pause_rounded)
                                  else
                                    const Icon(Icons.play_arrow_rounded),
                                  const Icon(Icons.skip_next_rounded),
                                ],
                              ),
                            ),
                            const Spacer(
                              flex: 3,
                            ),
                          ],
                        ),
                        if (recommended.contains(type))
                          const Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.star_border_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
