import 'package:tree/colors.dart';
import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/pages/settingsPage.dart';
import 'package:tree/struct/databaseGlobal.dart';
import 'package:tree/struct/settings.dart';
import 'package:tree/widgets/animatedExpanded.dart';
import 'package:tree/widgets/dropdownSelect.dart';
import 'package:tree/widgets/framework/pageFramework.dart';
import 'package:tree/widgets/framework/popupFramework.dart';
import 'package:tree/widgets/navigationFramework.dart';
import 'package:tree/widgets/openBottomSheet.dart';
import 'package:tree/widgets/openPopup.dart';
import 'package:tree/widgets/openSnackbar.dart';
import 'package:tree/widgets/globalSnackbar.dart';
import 'package:tree/widgets/saveBottomButton.dart';
import 'package:tree/widgets/selectCategoryImage.dart';
import 'package:tree/widgets/selectChips.dart';
import 'package:tree/widgets/selectColor.dart';
import 'package:tree/widgets/settingsContainers.dart';
import 'package:tree/widgets/tappable.dart';
import 'package:tree/widgets/tappableTextEntry.dart';
import 'package:tree/widgets/textInput.dart';
import 'package:tree/widgets/textWidgets.dart';
import 'package:tree/widgets/util/showDatePicker.dart';
import 'package:tree/pages/addCategoryPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide SliverReorderableList, ReorderableDelayedDragStartListener;

class AddHabitsPage extends StatefulWidget {
  const AddHabitsPage({
    super.key,
    this.habit,
    this.isAddedOnlyHabit = false,
    required this.routesToPopAfterDelete,
  });

  /// When a habit is passed in, we are editing that habit
  final Habit? habit;
  final bool isAddedOnlyHabit;
  final RoutesToPopAfterDelete routesToPopAfterDelete;

  @override
  _AddHabitsPageState createState() => _AddHabitsPageState();
}

class _AddHabitsPageState extends State<AddHabitsPage> {
  // ── Form state ──────────────────────────────────────────────────────────────
  String? selectedTitle;
  String selectedNote = "";
  late String? selectedImage = widget.habit == null ? "image.png" : null;
  String? selectedEmoji;
  late Color? selectedColor =
      widget.habit?.colour == null ? null : HexColor(widget.habit?.colour);
  HabitFrequency selectedFrequency = HabitFrequency.daily;
  List<int> selectedFrequencyDays = [];
  bool goalEnabled = false;
  double? selectedGoalAmount;
  String? selectedGoalUnit;
  bool reminderEnabled = false;
  String? selectedReminderTime;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  bool? canAddHabit;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _goalAmountController = TextEditingController();
  final TextEditingController _goalUnitController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  // ── Setters ─────────────────────────────────────────────────────────────────
  void setSelectedColor(Color? color) {
    setState(() => selectedColor = color);
    determineBottomButton();
  }

  void setSelectedImage(String? image) {
    setState(() {
      selectedImage = (image ?? "").replaceFirst("assets/categories/", "");
      selectedEmoji = null;
    });
    determineBottomButton();
  }

  void setSelectedEmoji(String? emoji) {
    setState(() {
      selectedEmoji = emoji;
      selectedImage = null;
    });
    determineBottomButton();
  }

  void setSelectedTitle(String title) {
    setState(() => selectedTitle = title);
    determineBottomButton();
  }

  void determineBottomButton() {
    bool canAdd = selectedTitle != null && selectedTitle!.trim().isNotEmpty;
    if (canAdd != canAddHabit) {
      setState(() => canAddHabit = canAdd);
    }
  }

  // ── Build Habit object ──────────────────────────────────────────────────────
  Habit createHabit() {
    return Habit(
      habitPk: widget.habit?.habitPk ?? "-1",
      name: (selectedTitle ?? "").trim(),
      note: selectedNote.trim(),
      colour: toHexString(selectedColor),
      iconName: selectedImage,
      emojiIconName: selectedEmoji,
      order: widget.habit?.order ?? 0,
      pinned: widget.habit?.pinned ?? false,
      archived: widget.habit?.archived ?? false,
      frequency: selectedFrequency,
      frequencyDays:
          selectedFrequencyDays.isNotEmpty ? selectedFrequencyDays : null,
      goalAmount: goalEnabled ? selectedGoalAmount : null,
      goalUnit: goalEnabled ? selectedGoalUnit : null,
      reminderEnabled: reminderEnabled,
      reminderTime: reminderEnabled ? selectedReminderTime : null,
      startDate: selectedStartDate,
      endDate: selectedEndDate,
      dateCreated: widget.habit?.dateCreated ?? DateTime.now(),
      dateTimeModified: null,
    );
  }

  // ── Save ────────────────────────────────────────────────────────────────────
  Future addHabit() async {
    loadingIndeterminateKey.currentState?.setVisibility(true);
    Habit habit = createHabit();
    if (widget.habit == null) {
      // New habit: set order to be at the end
      List<Habit> allHabits = await database.watchAllHabits().first;
      habit = habit.copyWith(order: allHabits.length);
    }
    await database.createOrUpdateHabit(
      habit,
      insert: widget.habit == null,
    );
    loadingIndeterminateKey.currentState?.setVisibility(false);
    savingHapticFeedback();
    popRoute(context);
  }

  Habit? habitInitial;

  void showDiscardChangesPopupIfNotEditing() {
    Habit habitCreated = createHabit();
    if (habitCreated != habitInitial && widget.habit == null) {
      discardChangesPopup(context, forceShow: true);
    } else {
      popRoute(context);
    }
  }

  void discardChangesPopupIfHabitPassed() {
    discardChangesPopup(
      context,
      previousObject: widget.habit!,
      currentObject: createHabit(),
    );
  }

  // ── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      // We are editing a habit — fill in the information
      final h = widget.habit!;
      selectedTitle = h.name;
      selectedNote = h.note;
      selectedImage = h.iconName;
      selectedEmoji = h.emojiIconName;
      selectedColor = h.colour == null ? null : HexColor(h.colour);
      selectedFrequency = h.frequency;
      selectedFrequencyDays = h.frequencyDays ?? [];
      goalEnabled = h.goalAmount != null;
      selectedGoalAmount = h.goalAmount;
      selectedGoalUnit = h.goalUnit;
      reminderEnabled = h.reminderEnabled;
      selectedReminderTime = h.reminderTime;
      selectedStartDate = h.startDate;
      selectedEndDate = h.endDate;

      _titleController.text = h.name;
      _noteController.text = h.note;
      if (h.goalAmount != null) {
        _goalAmountController.text = h.goalAmount.toString();
      }
      if (h.goalUnit != null) {
        _goalUnitController.text = h.goalUnit!;
      }
      // Set to false because we can't save until we made some changes
      setState(() {
        canAddHabit = false;
      });
    }
    if (widget.habit == null) {
      Future.delayed(Duration.zero, () {
        habitInitial = createHabit();
      });
    }
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleController.dispose();
    _noteController.dispose();
    _goalAmountController.dispose();
    _goalUnitController.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  String _frequencyLabel(HabitFrequency f) {
    switch (f) {
      case HabitFrequency.daily:
        return "daily".tr();
      case HabitFrequency.specificDays:
        return "specific-days".tr();
      case HabitFrequency.weekly:
        return "weekly".tr();
      case HabitFrequency.monthly:
        return "monthly".tr();
    }
  }

  static const List<String> _dayNames = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  // ── Time picker ─────────────────────────────────────────────────────────────
  Future<void> _pickReminderTime() async {
    TimeOfDay initial = TimeOfDay(hour: 9, minute: 0);
    if (selectedReminderTime != null) {
      final parts = selectedReminderTime!.split(":");
      if (parts.length == 2) {
        initial = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 9,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        selectedReminderTime =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.habit != null) {
          discardChangesPopupIfHabitPassed();
        } else {
          showDiscardChangesPopupIfNotEditing();
        }
        return false;
      },
      child: PageFramework(
        horizontalPaddingConstrained: true,
        resizeToAvoidBottomInset: true,
        dragDownToDismiss: true,
        title: widget.habit == null ? "add-habit".tr() : "edit-habit".tr(),
        onBackButton: () async {
          if (widget.habit != null) {
            discardChangesPopupIfHabitPassed();
          } else {
            showDiscardChangesPopupIfNotEditing();
          }
        },
        onDragDownToDismiss: () async {
          if (widget.habit != null) {
            discardChangesPopupIfHabitPassed();
          } else {
            showDiscardChangesPopupIfNotEditing();
          }
        },
        actions: [
          CustomPopupMenuButton(
            showButtons: true,
            keepOutFirst: true,
            items: [
              if (widget.habit != null &&
                  widget.routesToPopAfterDelete !=
                      RoutesToPopAfterDelete.PreventDelete)
                DropdownItemMenu(
                  id: "delete-habit",
                  label: "delete-habit".tr(),
                  icon: appStateSettings["outlinedIcons"]
                      ? Icons.delete_outlined
                      : Icons.delete_rounded,
                  action: () async {
                    DeletePopupAction? action = await openDeletePopup(
                      context,
                      title: "delete-habit-question".tr(),
                      subtitle: widget.habit!.name,
                    );
                    if (action == DeletePopupAction.Delete) {
                      await database.deleteHabit(widget.habit!.habitPk);
                      openSnackbar(
                        SnackbarMessage(
                          title: "deleted-habit".tr(),
                          icon: Icons.delete,
                          description: widget.habit!.name,
                        ),
                      );
                      if (widget.routesToPopAfterDelete ==
                          RoutesToPopAfterDelete.All) {
                        popAllRoutes(context);
                      } else {
                        popRoute(context);
                      }
                    }
                  },
                ),
            ],
          ),
        ],

        // ── Save button ───────────────────────────────────────────────────
        staticOverlay: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: selectedTitle == null || selectedTitle!.trim().isEmpty
              ? SaveBottomButton(
                  label: "set-name".tr(),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Future.delayed(Duration(milliseconds: 100), () {
                      _titleFocusNode.requestFocus();
                    });
                  },
                  disabled: false,
                )
              : SaveBottomButton(
                  label: widget.habit == null
                      ? "add-habit".tr()
                      : "save-changes".tr(),
                  onTap: () async => await addHabit(),
                  disabled: !(canAddHabit ?? false),
                ),
        ),

        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Icon picker + Name field ───────────────────────────
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Tappable(
                      onTap: () {
                        openBottomSheet(
                          context,
                          PopupFramework(
                            title: "select-icon".tr(),
                            child: SelectCategoryImage(
                              setSelectedImage: setSelectedImage,
                              setSelectedEmoji: setSelectedEmoji,
                              selectedImage: "assets/categories/" +
                                  selectedImage.toString(),
                              setSelectedTitle: (String? titleRecommendation) {
                                if (titleRecommendation != null &&
                                    (selectedTitle == null ||
                                        selectedTitle == "")) {
                                  setSelectedTitle(titleRecommendation
                                      .capitalizeFirstofEach);
                                  _titleController.text =
                                      titleRecommendation.capitalizeFirstofEach;
                                }
                              },
                            ),
                          ),
                          showScrollbar: true,
                        );
                      },
                      color: Colors.transparent,
                      child: IconPreview(
                        selectedImage: selectedImage,
                        selectedEmoji: selectedEmoji,
                        selectedColor: selectedColor,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Name text field ────────────────────────
                            TextInput(
                              autoFocus: kIsWeb && getIsFullScreen(context),
                              focusNode: _titleFocusNode,
                              labelText: "habit-name-placeholder".tr(),
                              bubbly: false,
                              controller: _titleController,
                              onChanged: (text) => setSelectedTitle(text),
                              padding: EdgeInsetsDirectional.zero,
                              fontSize: getIsFullScreen(context) ? 34 : 27,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            // ── Note text field ────────────────────────
                            TextInput(
                              labelText: "note-placeholder".tr(),
                              bubbly: false,
                              controller: _noteController,
                              onChanged: (text) {
                                selectedNote = text;
                              },
                              padding: EdgeInsetsDirectional.zero,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // ── 2. Colour picker ──────────────────────────────────────
                Container(
                  height: 65,
                  child: SelectColor(
                    horizontalList: true,
                    selectedColor: selectedColor,
                    setSelectedColor: setSelectedColor,
                    previewBuilder: (color) => IconPreview(
                      selectedImage: selectedImage,
                      selectedEmoji: selectedEmoji,
                      selectedColor: color,
                      switcherDuration: Duration.zero,
                      smallPreview: true,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // ── 3. Frequency selector ─────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: TextFont(
                    text: "frequency".tr(),
                    textColor: getColor(context, "textLight"),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                SelectChips<HabitFrequency>(
                  items: HabitFrequency.values,
                  getSelected: (f) => f == selectedFrequency,
                  onSelected: (f) {
                    setState(() => selectedFrequency = f);
                  },
                  getLabel: (f) => _frequencyLabel(f),
                  allowMultipleSelected: false,
                ),

                // ── Weekday selector (shown only for specificDays) ────────
                AnimatedSizeSwitcher(
                  child: selectedFrequency == HabitFrequency.specificDays
                      ? Padding(
                          key: ValueKey("weekdays"),
                          padding: const EdgeInsetsDirectional.only(bottom: 10),
                          child: SelectChips<int>(
                            items: List.generate(7, (i) => i),
                            getSelected: (day) =>
                                selectedFrequencyDays.contains(day),
                            onSelected: (day) {
                              setState(() {
                                if (selectedFrequencyDays.contains(day)) {
                                  selectedFrequencyDays.remove(day);
                                } else {
                                  selectedFrequencyDays.add(day);
                                }
                              });
                            },
                            getLabel: (day) => _dayNames[day],
                            allowMultipleSelected: true,
                          ),
                        )
                      : SizedBox.shrink(key: ValueKey("noWeekdays")),
                ),

                SizedBox(height: 5),

                // ── 4. Goal toggle + fields ───────────────────────────────
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                  child: SettingsContainerSwitch(
                    title: "goal".tr(),
                    description: "goal-description".tr(),
                    icon: appStateSettings["outlinedIcons"]
                        ? Icons.flag_outlined
                        : Icons.flag_rounded,
                    initialValue: goalEnabled,
                    onSwitched: (value) {
                      setState(() => goalEnabled = value);
                    },
                    enableBorderRadius: true,
                  ),
                ),
                AnimatedSizeSwitcher(
                  child: goalEnabled
                      ? Padding(
                          key: ValueKey("goalFields"),
                          padding: const EdgeInsetsDirectional.only(
                            start: 20,
                            end: 20,
                            top: 5,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextInput(
                                  labelText: "amount".tr(),
                                  bubbly: true,
                                  controller: _goalAmountController,
                                  onChanged: (text) {
                                    selectedGoalAmount = double.tryParse(text);
                                  },
                                  padding: EdgeInsetsDirectional.zero,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: TextInput(
                                  labelText: "unit-placeholder".tr(),
                                  bubbly: true,
                                  controller: _goalUnitController,
                                  onChanged: (text) {
                                    selectedGoalUnit = text;
                                  },
                                  padding: EdgeInsetsDirectional.zero,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(key: ValueKey("noGoal")),
                ),

                // ── 5. Reminder toggle + time picker ──────────────────────
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                  child: SettingsContainerSwitch(
                    title: "reminder".tr(),
                    description: reminderEnabled && selectedReminderTime != null
                        ? "reminder-at".tr() + " $selectedReminderTime"
                        : "reminder-description".tr(),
                    icon: appStateSettings["outlinedIcons"]
                        ? Icons.notifications_outlined
                        : Icons.notifications_rounded,
                    initialValue: reminderEnabled,
                    onSwitched: (value) {
                      setState(() => reminderEnabled = value);
                      if (value && selectedReminderTime == null) {
                        _pickReminderTime();
                      }
                    },
                    enableBorderRadius: true,
                  ),
                ),
                AnimatedSizeSwitcher(
                  child: reminderEnabled
                      ? Padding(
                          key: ValueKey("reminderTime"),
                          padding: const EdgeInsetsDirectional.only(
                            start: 20,
                            end: 20,
                            top: 5,
                            bottom: 10,
                          ),
                          child: TappableTextEntry(
                            title: selectedReminderTime ?? "select-time".tr(),
                            placeholder: "select-time".tr(),
                            onTap: () => _pickReminderTime(),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : SizedBox.shrink(key: ValueKey("noReminder")),
                ),

                SizedBox(height: 5),

                // ── 6. Start date / end date ──────────────────────────────
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: TextFont(
                    text: "dates-optional".tr(),
                    textColor: getColor(context, "textLight"),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TappableTextEntry(
                          title: selectedStartDate != null
                              ? getWordedDateShortMore(selectedStartDate!)
                              : null,
                          placeholder: "start-date".tr(),
                          onTap: () async {
                            DateTime? picked = await showCustomDatePicker(
                              context,
                              selectedStartDate ?? DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => selectedStartDate = picked);
                            }
                          },
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: getColor(context, "textLight"),
                        ),
                      ),
                      Expanded(
                        child: TappableTextEntry(
                          title: selectedEndDate != null
                              ? getWordedDateShortMore(selectedEndDate!)
                              : null,
                          placeholder: "end-date".tr(),
                          onTap: () async {
                            DateTime? picked = await showCustomDatePicker(
                              context,
                              selectedEndDate ?? DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => selectedEndDate = picked);
                            }
                          },
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Extra space for the save button
                SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
