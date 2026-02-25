import 'package:tree/colors.dart';
import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/pages/addBudgetPage.dart';
import 'package:tree/pages/add_habitspage.dart';
import 'package:tree/pages/editBudgetPage.dart';
import 'package:tree/pages/edit_habitspage.dart';
import 'package:tree/struct/databaseGlobal.dart';
import 'package:tree/struct/settings.dart';
import 'package:tree/widgets/framework/popupFramework.dart';
import 'package:tree/widgets/habit_container.dart';
import 'package:tree/widgets/util/keepAliveClientMixin.dart';
import 'package:tree/widgets/openBottomSheet.dart';
import 'package:tree/widgets/openPopup.dart';
import 'package:tree/widgets/selectItems.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tree/widgets/util/widgetSize.dart';
import 'package:tree/pages/addButton.dart';

class HomePageHabits extends StatefulWidget {
  const HomePageHabits({super.key});

  @override
  State<HomePageHabits> createState() => _HomePageHabitsState();
}

class _HomePageHabitsState extends State<HomePageHabits> {
  double height = 0;

  @override
  Widget build(BuildContext context) {
    return KeepAliveClientMixin(
      child: StreamBuilder<List<Habit>>(
        stream: database.watchAllHabits(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.isEmpty ?? true) {
              return AddButton(
                onTap: () {
                  openBottomSheet(
                    context,
                    EditHomePagePinnedHabitsPopup(
                      showHabitsTotalLabelSetting: false,
                    ),
                    useCustomController: true,
                  );
                },
                height: 160,
                width: null,
                margin: const EdgeInsetsDirectional.only(
                    start: 13, end: 13, bottom: 13),
                labelUnder: "habits".tr(),
                icon: Icons.format_list_bulleted_add,
              );
            }
            // if (snapshot.data!.length == 1) {
            //   return Padding(
            //     padding: const EdgeInsetsDirectional.only(
            //         start: 13, end: 13, bottom: 13),
            //     child: BudgetContainer(
            //       budget: snapshot.data![0],
            //     ),
            //   );
            // }
            List<Widget> HabitItems = [
              ...(snapshot.data?.map((Habit habit) {
                    return Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 3),
                      child: HabitContainer(
                        intermediatePadding: false,
                        habit: habit,
                      ),
                    );
                  }).toList() ??
                  []),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 3, end: 3),
                child: AddButton(
                  onTap: () {
                    openBottomSheet(
                      context,
                      EditHomePagePinnedHabitsPopup(
                        showHabitsTotalLabelSetting: false,
                      ),
                      useCustomController: true,
                    );
                  },
                  height: null,
                  width: null,
                  margin: EdgeInsetsDirectional.all(0),
                  labelUnder: "habit".tr(),
                  icon: Icons.format_list_bulleted_add,
                ),
              ),
            ];
            return Stack(
              children: [
                IgnorePointer(
                  child: Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Opacity(
                      opacity: 0,
                      child: WidgetSize(
                        onChange: (Size size) {
                          setState(() {
                            height = size.height;
                          });
                        },
                        child: HabitContainer(
                          habit: snapshot.data![0],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 13),
                  child: getIsFullScreen(context)
                      ? SizedBox(
                          height: height,
                          child: ListView(
                            addAutomaticKeepAlives: true,
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10,
                            ),
                            children: [
                              for (Widget widget in HabitItems)
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 7),
                                  child: SizedBox(
                                    width: 500,
                                    child: widget,
                                  ),
                                )
                            ],
                          ),
                        )
                      : CarouselSlider(
                          options: CarouselOptions(
                            height: height,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                            viewportFraction: 0.95,
                            clipBehavior: Clip.none,
                            // onPageChanged: (index, reason) {
                            //   if (index == snapshot.data!.length) {
                            //     pushRoute(context,
                            //         AddBudgetPage());
                            //   }
                            // },
                            enlargeFactor: 0.3,
                          ),
                          items: HabitItems,
                        ),
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class EditHomePagePinnedHabitsPopup extends StatelessWidget {
  const EditHomePagePinnedHabitsPopup(
      {super.key, required this.showHabitsTotalLabelSetting});
  final bool showHabitsTotalLabelSetting;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Habit>>(
        stream: database.watchAllHabits(),
        builder: (context, snapshot) {
          List<Habit> allHabits = snapshot.data ?? [];
          return PopupFramework(
            title: "select-habits".tr(),
            outsideExtraWidget: OutsideExtraWidgetIconButton(
              iconData: appStateSettings["outlinedIcons"]
                  ? Icons.edit_outlined
                  : Icons.edit_rounded,
              onPressed: () async {
                pushRoute(context, EditHabitsPage());
              },
            ),
            child: Column(
              children: [
                if (showHabitsTotalLabelSetting)
                  ClipRRect(
                    borderRadius: BorderRadiusDirectional.circular(15),
                    child: TotalSpentToggle(),
                  ),
                if (allHabits.isEmpty)
                  NoResultsCreate(
                    message: "no-habits-found".tr(),
                    buttonLabel: "create-habit".tr(),
                    route: AddHabitsPage(
                      routesToPopAfterDelete: RoutesToPopAfterDelete.None,
                    ),
                  ),
                SelectItems(
                  syncWithInitial: true,
                  checkboxCustomIconSelected: Icons.push_pin_rounded,
                  checkboxCustomIconUnselected: Icons.push_pin_outlined,
                  items: [
                    for (Habit habit in allHabits) habit.habitPk.toString()
                  ],
                  getColor: (habitPk, selected) {
                    for (Habit habit in allHabits) {
                      if (habit.habitPk.toString() == habitPk.toString()) {
                        return HexColor(habit.colour,
                                defaultColor:
                                    Theme.of(context).colorScheme.primary)
                            .withValues(alpha: selected == true ? 0.7 : 0.5);
                      }
                    }
                    return null;
                  },
                  displayFilter: (habitPk) {
                    for (Habit habit in allHabits) {
                      if (habit.habitPk.toString() == habitPk.toString()) {
                        return habit.name;
                      }
                    }
                    return "";
                  },
                  initialItems: [
                    for (Habit habit in allHabits)
                      if (habit.pinned) habit.habitPk.toString()
                  ],
                  onChangedSingleItem: (value) async {
                    Habit habit = allHabits[
                        allHabits.indexWhere((item) => item.habitPk == value)];
                    Habit habitToUpdate =
                        await database.getHabitInstance(habit.habitPk);
                    await database.createOrUpdateHabit(
                      habitToUpdate.copyWith(pinned: !habitToUpdate.pinned),
                      updateSharedEntry: false,
                    );
                  },
                  onLongPress: (String habitPk) async {
                    Habit habit = await database.getHabitInstance(habitPk);
                    if (!context.mounted) return;
                    pushRoute(
                      context,
                      AddHabitsPage(
                        routesToPopAfterDelete: RoutesToPopAfterDelete.One,
                        habit: habit,
                      ),
                    );
                  },
                ),
                if (allHabits.isNotEmpty)
                  AddButton(
                    onTap: () {},
                    height: 50,
                    width: null,
                    margin: const EdgeInsetsDirectional.only(
                      start: 13,
                      end: 13,
                      bottom: 13,
                      top: 13,
                    ),
                    openPage: AddBudgetPage(
                      routesToPopAfterDelete: RoutesToPopAfterDelete.None,
                    ),
                    afterOpenPage: () {
                      Future.delayed(Duration(milliseconds: 100), () {
                        bottomSheetControllerGlobalCustomAssigned
                            ?.snapToExtent(0);
                      });
                    },
                  ),
              ],
            ),
          );
        });
  }
}
