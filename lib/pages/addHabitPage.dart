import 'package:tree/colors.dart';
import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/pages/addCategoryPage.dart';
import 'package:tree/struct/databaseGlobal.dart';
import 'package:tree/struct/settings.dart';
import 'package:tree/widgets/animatedExpanded.dart';
import 'package:tree/widgets/framework/pageFramework.dart';
import 'package:tree/widgets/framework/popupFramework.dart';
import 'package:tree/widgets/openBottomSheet.dart';
import 'package:tree/widgets/openPopup.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide SliverReorderableList, ReorderableDelayedDragStartListener;

class AddHabitPage extends StatefulWidget {
  AddHabitPage({
    Key? key,
    this.habit,
    required this.routesToPopAfterDelete,
  }) : super(key: key);

  /// When a habit is passed in, we are editing that habit
  final Habit? habit;
  final RoutesToPopAfterDelete routesToPopAfterDelete;

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
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

  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _goalAmountController = TextEditingController();
  TextEditingController _goalUnitController = TextEditingController();
  FocusNode _titleFocusNode = FocusNode();

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
    Habit habit = createHabit();
    await database.createOrUpdateHabit(
      habit,
      insert: widget.habit == null,
    );
    popRoute(context);
  }

  // ── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
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
    }
    canAddHabit = false;
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
        return "Daily";
      case HabitFrequency.specificDays:
        return "Specific Days";
      case HabitFrequency.weekly:
        return "Weekly";
      case HabitFrequency.monthly:
        return "Monthly";
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

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.habit != null) {
          discardChangesPopup(context,
              previousObject: widget.habit!, currentObject: createHabit());
        } else {
          discardChangesPopup(context,
              previousObject: null,
              currentObject: createHabit(),
              forceShow:
                  selectedTitle != null && selectedTitle!.trim().isNotEmpty);
        }
        return false;
      },
      child: PageFramework(
        horizontalPaddingConstrained: true,
        resizeToAvoidBottomInset: true,
        dragDownToDismiss: true,
        title: widget.habit == null ? "Add Habit" : "Edit Habit",
        onBackButton: () async {
          if (widget.habit != null) {
            discardChangesPopup(context,
                previousObject: widget.habit!, currentObject: createHabit());
          } else {
            popRoute(context);
          }
        },
        onDragDownToDismiss: () async {
          if (widget.habit != null) {
            discardChangesPopup(context,
                previousObject: widget.habit!, currentObject: createHabit());
          } else {
            popRoute(context);
          }
        },
        actions: [
          // Delete button (edit mode only)
          if (widget.habit != null &&
              widget.routesToPopAfterDelete !=
                  RoutesToPopAfterDelete.PreventDelete)
            IconButton(
              padding: EdgeInsetsDirectional.all(15),
              tooltip: "Delete Habit",
              onPressed: () async {
                DeletePopupAction? action = await openDeletePopup(
                  context,
                  title: "Delete Habit?",
                  subtitle: widget.habit!.name,
                );
                if (action == DeletePopupAction.Delete) {
                  await database.deleteHabit(widget.habit!.habitPk);
                  if (widget.routesToPopAfterDelete ==
                      RoutesToPopAfterDelete.All) {
                    popAllRoutes(context);
                  } else {
                    popRoute(context);
                    popRoute(context);
                  }
                }
              },
              icon: Icon(
                appStateSettings["outlinedIcons"]
                    ? Icons.delete_outlined
                    : Icons.delete_rounded,
              ),
            ),
        ],

        // ── Save button ───────────────────────────────────────────────────
        staticOverlay: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: selectedTitle == null || selectedTitle!.trim().isEmpty
              ? SaveBottomButton(
                  label: "Set Name",
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Future.delayed(Duration(milliseconds: 100), () {
                      _titleFocusNode.requestFocus();
                    });
                  },
                  disabled: false,
                )
              : SaveBottomButton(
                  label: widget.habit == null ? "Add Habit" : "Save Changes",
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
                            title: "Select Icon",
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
                            // ── 3. Name text field ────────────────────────
                            TextInput(
                              autoFocus: kIsWeb && getIsFullScreen(context),
                              focusNode: _titleFocusNode,
                              labelText: "Habit name",
                              bubbly: false,
                              controller: _titleController,
                              onChanged: (text) => setSelectedTitle(text),
                              padding: EdgeInsetsDirectional.zero,
                              fontSize: getIsFullScreen(context) ? 34 : 27,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            // ── 4. Note text field ────────────────────────
                            TextInput(
                              labelText: "Note (optional)",
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

                // ── 5. Frequency selector ─────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: TextFont(
                    text: "Frequency",
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

                // ── 6. Goal toggle + fields ───────────────────────────────
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                  child: SettingsContainerSwitch(
                    title: "Goal",
                    description: "Set a target amount per completion",
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
                                  labelText: "Amount",
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
                                  labelText: "Unit (e.g. minutes, pages)",
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

                // ── 7. Reminder toggle + time picker ──────────────────────
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                  child: SettingsContainerSwitch(
                    title: "Reminder",
                    description: reminderEnabled && selectedReminderTime != null
                        ? "Reminder at $selectedReminderTime"
                        : "Get notified to complete this habit",
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
                            title: selectedReminderTime ?? "Select time",
                            placeholder: "Select time",
                            onTap: () => _pickReminderTime(),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : SizedBox.shrink(key: ValueKey("noReminder")),
                ),

                SizedBox(height: 5),

                // ── 8. Start date / end date ──────────────────────────────
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: TextFont(
                    text: "Dates (optional)",
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
                          placeholder: "Start date",
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
                          placeholder: "End date",
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
}
