import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/queue_visualizer_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_options_widget.dart';
import './widgets/task_card_widget.dart';

class TaskManagement extends StatefulWidget {
  const TaskManagement({Key? key}) : super(key: key);

  @override
  State<TaskManagement> createState() => _TaskManagementState();
}

class _TaskManagementState extends State<TaskManagement>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State variables
  String _searchQuery = '';
  String _currentSort = 'priority_queue';
  Map<String, dynamic> _activeFilters = {};
  List<int> _selectedTaskIds = [];
  bool _isMultiSelectMode = false;
  bool _showQueueVisualization = false;
  bool _isLoading = false;

  // Mock data
  final List<Map<String, dynamic>> _allTasks = [
    {
      "id": 1,
      "title": "Complete project proposal",
      "description":
          "Finalize the quarterly project proposal with budget analysis and timeline",
      "category": "Daily",
      "priority": "High",
      "status": "Pending",
      "dueDate": "2025-08-22T10:00:00.000Z",
      "estimatedMinutes": 120,
      "createdAt": "2025-08-20T09:00:00.000Z",
    },
    {
      "id": 2,
      "title": "Review team performance",
      "description": "Conduct monthly performance reviews for team members",
      "category": "Monthly",
      "priority": "Normal",
      "status": "Pending",
      "dueDate": "2025-08-25T14:00:00.000Z",
      "estimatedMinutes": 90,
      "createdAt": "2025-08-19T11:30:00.000Z",
    },
    {
      "id": 3,
      "title": "Update personal website",
      "description": "Add new portfolio projects and update resume section",
      "category": "Yearly",
      "priority": "Low",
      "status": "Done",
      "dueDate": "2025-09-15T16:00:00.000Z",
      "estimatedMinutes": 180,
      "createdAt": "2025-08-18T13:15:00.000Z",
    },
    {
      "id": 4,
      "title": "Quick email responses",
      "description": "Reply to pending client emails",
      "category": "Daily",
      "priority": "Normal",
      "status": "Pending",
      "dueDate": "2025-08-21T17:00:00.000Z",
      "estimatedMinutes": 15,
      "createdAt": "2025-08-21T08:45:00.000Z",
    },
    {
      "id": 5,
      "title": "Plan annual conference",
      "description":
          "Organize company annual conference including venue booking and speaker arrangements",
      "category": "Yearly",
      "priority": "High",
      "status": "Pending",
      "dueDate": "2025-12-01T09:00:00.000Z",
      "estimatedMinutes": 300,
      "createdAt": "2025-08-15T10:20:00.000Z",
    },
    {
      "id": 6,
      "title": "Grocery shopping",
      "description": "Buy weekly groceries and household items",
      "category": "Daily",
      "priority": "Low",
      "status": "Done",
      "dueDate": "2025-08-21T19:00:00.000Z",
      "estimatedMinutes": 45,
      "createdAt": "2025-08-21T07:30:00.000Z",
    },
    {
      "id": 7,
      "title": "Prepare monthly budget",
      "description":
          "Create detailed budget plan for next month including expense tracking",
      "category": "Monthly",
      "priority": "High",
      "status": "Pending",
      "dueDate": "2025-08-30T12:00:00.000Z",
      "estimatedMinutes": 60,
      "createdAt": "2025-08-20T14:00:00.000Z",
    },
    {
      "id": 8,
      "title": "Call dentist appointment",
      "description": "Schedule routine dental checkup",
      "category": "Daily",
      "priority": "Normal",
      "status": "Pending",
      "dueDate": "2025-08-23T11:00:00.000Z",
      "estimatedMinutes": 10,
      "createdAt": "2025-08-21T09:15:00.000Z",
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<Map<String, dynamic>> get _filteredTasks {
    List<Map<String, dynamic>> filtered = List.from(_allTasks);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        final title = (task['title'] as String? ?? '').toLowerCase();
        final description =
            (task['description'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_activeFilters['category'] != null &&
        (_activeFilters['category'] as List).isNotEmpty) {
      final categories = _activeFilters['category'] as List<String>;
      filtered = filtered
          .where((task) => categories.contains(task['category']))
          .toList();
    }

    // Apply priority filter
    if (_activeFilters['priority'] != null &&
        (_activeFilters['priority'] as List).isNotEmpty) {
      final priorities = _activeFilters['priority'] as List<String>;
      filtered = filtered
          .where((task) => priorities.contains(task['priority']))
          .toList();
    }

    // Apply status filter
    if (_activeFilters['status'] != null &&
        (_activeFilters['status'] as List).isNotEmpty) {
      final statuses = _activeFilters['status'] as List<String>;
      filtered =
          filtered.where((task) => statuses.contains(task['status'])).toList();
    }

    // Apply fast completion filter
    if (_activeFilters['fastCompletion'] == true) {
      filtered = filtered
          .where((task) => (task['estimatedMinutes'] ?? 0) <= 15)
          .toList();
    }

    // Apply sorting
    return _sortTasks(filtered);
  }

  List<Map<String, dynamic>> _sortTasks(List<Map<String, dynamic>> tasks) {
    switch (_currentSort) {
      case 'priority_queue':
        return _sortByPriorityQueue(tasks);
      case 'fifo':
        tasks.sort((a, b) => DateTime.parse(a['createdAt'])
            .compareTo(DateTime.parse(b['createdAt'])));
        return tasks;
      case 'lilo':
        tasks.sort((a, b) => DateTime.parse(b['createdAt'])
            .compareTo(DateTime.parse(a['createdAt'])));
        return tasks;
      case 'due_date':
        tasks.sort((a, b) {
          if (a['dueDate'] == null && b['dueDate'] == null) return 0;
          if (a['dueDate'] == null) return 1;
          if (b['dueDate'] == null) return -1;
          return DateTime.parse(a['dueDate'])
              .compareTo(DateTime.parse(b['dueDate']));
        });
        return tasks;
      case 'creation_date':
        tasks.sort((a, b) => DateTime.parse(b['createdAt'])
            .compareTo(DateTime.parse(a['createdAt'])));
        return tasks;
      default:
        return tasks;
    }
  }

  List<Map<String, dynamic>> _sortByPriorityQueue(
      List<Map<String, dynamic>> tasks) {
    tasks.sort((a, b) {
      final weightA = _calculateEffectiveWeight(a);
      final weightB = _calculateEffectiveWeight(b);
      return weightB.compareTo(weightA); // Higher weight first
    });
    return tasks;
  }

  double _calculateEffectiveWeight(Map<String, dynamic> task) {
    final priority = task['priority'] ?? 'Normal';
    final priorityValue = _getPriorityValue(priority);

    double deadlineUrgency = 1.0;
    if (task['dueDate'] != null) {
      final dueDate = DateTime.parse(task['dueDate']);
      final now = DateTime.now();
      final daysUntilDue = dueDate.difference(now).inDays;

      if (daysUntilDue <= 0) {
        deadlineUrgency = 5.0; // Overdue
      } else if (daysUntilDue <= 1) {
        deadlineUrgency = 4.0; // Due today/tomorrow
      } else if (daysUntilDue <= 7) {
        deadlineUrgency = 3.0; // Due this week
      } else {
        deadlineUrgency = 1.0; // Future
      }
    }

    final timeFactor = 1.0;
    return priorityValue + (deadlineUrgency * timeFactor);
  }

  double _getPriorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3.0;
      case 'normal':
        return 2.0;
      case 'low':
        return 1.0;
      default:
        return 2.0;
    }
  }

  void _toggleTaskSelection(int taskId) {
    setState(() {
      if (_selectedTaskIds.contains(taskId)) {
        _selectedTaskIds.remove(taskId);
        if (_selectedTaskIds.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedTaskIds.add(taskId);
        _isMultiSelectMode = true;
      }
    });
  }

  void _toggleTaskCompletion(int taskId) {
    setState(() {
      final taskIndex = _allTasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        final currentStatus = _allTasks[taskIndex]['status'];
        _allTasks[taskIndex]['status'] =
            currentStatus == 'Done' ? 'Pending' : 'Done';
      }
    });
  }

  void _deleteTask(int taskId) {
    setState(() {
      _allTasks.removeWhere((task) => task['id'] == taskId);
      _selectedTaskIds.remove(taskId);
      if (_selectedTaskIds.isEmpty) {
        _isMultiSelectMode = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted successfully'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo functionality would be implemented here
          },
        ),
      ),
    );
  }

  void _bulkMarkComplete() {
    setState(() {
      for (final taskId in _selectedTaskIds) {
        final taskIndex = _allTasks.indexWhere((task) => task['id'] == taskId);
        if (taskIndex != -1) {
          _allTasks[taskIndex]['status'] = 'Done';
        }
      }
      _selectedTaskIds.clear();
      _isMultiSelectMode = false;
    });
  }

  void _bulkDelete() {
    setState(() {
      _allTasks.removeWhere((task) => _selectedTaskIds.contains(task['id']));
      _selectedTaskIds.clear();
      _isMultiSelectMode = false;
    });
  }

  void _onVoiceInput() {
    // Voice input functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice input feature coming soon')),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsWidget(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
        },
      ),
    );
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _activeFilters.remove(filterKey);
    });
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Task Management',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isMultiSelectMode) ...[
            IconButton(
              onPressed: _bulkMarkComplete,
              icon: CustomIconWidget(
                iconName: 'done_all',
                color: AppTheme.success,
                size: 6.w,
              ),
            ),
            IconButton(
              onPressed: _bulkDelete,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.error,
                size: 6.w,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedTaskIds.clear();
                  _isMultiSelectMode = false;
                });
              },
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.textSecondary,
                size: 6.w,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _showSortOptions,
              icon: CustomIconWidget(
                iconName: 'sort',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _showQueueVisualization = !_showQueueVisualization;
                });
              },
              icon: CustomIconWidget(
                iconName: _showQueueVisualization ? 'view_list' : 'analytics',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(4.w),
            color: AppTheme.lightTheme.cardColor,
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (query) => setState(() => _searchQuery = query),
              onVoiceInput: _onVoiceInput,
              onFilter: _showFilterModal,
            ),
          ),

          // Filter chips
          if (_activeFilters.isNotEmpty)
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              color: AppTheme.lightTheme.cardColor,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _buildFilterChips(),
              ),
            ),

          // Queue visualization (if enabled)
          if (_showQueueVisualization)
            QueueVisualizerWidget(
              tasks: filteredTasks,
              sortMode: _currentSort,
              onToggleView: () {
                setState(() {
                  _showQueueVisualization = false;
                });
              },
            ),

          // Task list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshTasks,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredTasks.isEmpty
                      ? EmptyStateWidget(
                          category: _getEmptyStateCategory(),
                          onAddTask: () => Navigator.pushNamed(
                              context, '/task-creation-edit'),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            final taskId = task['id'] as int;

                            return TaskCardWidget(
                              task: task,
                              isSelected: _selectedTaskIds.contains(taskId),
                              isMultiSelectMode: _isMultiSelectMode,
                              onTap: () => _toggleTaskSelection(taskId),
                              onToggleComplete: () =>
                                  _toggleTaskCompletion(taskId),
                              onEdit: () => Navigator.pushNamed(
                                context,
                                '/task-creation-edit',
                                arguments: task,
                              ),
                              onDuplicate: () {
                                // Duplicate task functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Task duplicated')),
                                );
                              },
                              onSetReminder: () => Navigator.pushNamed(
                                context,
                                '/notifications-alarms',
                                arguments: task,
                              ),
                              onDelete: () => _deleteTask(taskId),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/task-creation-edit'),
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 6.w,
              ),
            ),
    );
  }

  List<Widget> _buildFilterChips() {
    final chips = <Widget>[];

    _activeFilters.forEach((key, value) {
      if (value is List && (value).isNotEmpty) {
        final list = value as List<String>;
        chips.add(
          FilterChipWidget(
            label: '$key (${list.length})',
            count: list.length,
            isSelected: true,
            onTap: () {},
            onRemove: () => _removeFilter(key),
          ),
        );
      } else if (value is bool && value) {
        chips.add(
          FilterChipWidget(
            label: key == 'fastCompletion' ? 'Fast Tasks' : key,
            count: 0,
            isSelected: true,
            onTap: () {},
            onRemove: () => _removeFilter(key),
          ),
        );
      }
    });

    return chips;
  }

  String _getEmptyStateCategory() {
    if (_activeFilters['category'] != null &&
        (_activeFilters['category'] as List).length == 1) {
      return (_activeFilters['category'] as List).first.toLowerCase();
    }
    if (_activeFilters['status'] != null &&
        (_activeFilters['status'] as List).length == 1) {
      final status = (_activeFilters['status'] as List).first.toLowerCase();
      return status == 'done' ? 'completed' : 'pending';
    }
    if (_activeFilters['priority'] != null &&
        (_activeFilters['priority'] as List).length == 1) {
      final priority = (_activeFilters['priority'] as List).first.toLowerCase();
      return '${priority}_priority';
    }
    if (_activeFilters['fastCompletion'] == true) {
      return 'fast_completion';
    }
    return 'all';
  }
}
