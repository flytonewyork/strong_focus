import 'package:flutter/material.dart';

/*
This app defines a `GoalsScreen` widget that manages the state of the app. The `_goals` list holds the goals, each of which has a `title` and a list of `tasks`. The `_currentGoalIndex` variable keeps track of the current goal being worked on. The `_timerActive` variable is `true` when the 30-minute timer is running, and the `_secondsRemaining` variable holds the number of seconds left in the timer. The `_tasksCompleted` list is a list of booleans that keeps track of which tasks for the current goal have been completed.

The `startTimer` method sets the initial values for `_timerActive`, `_secondsRemaining`, and `_tasksCompleted`, and calls `_tick` to start the countdown.

The `_tick` method updates the `_secondsRemaining` variable every second and calls itself recursively until the timer expires. If the timer expires, a dialog is shown that prompts the user to go to the next goal. If all goals are completed, a different dialog is shown that congratulates the user and prompts them to finish the app.

The `_nextGoal` method increments the `_currentGoalIndex` and either shows a dialog prompting the user to start the next goal or a dialog congratulating the user on completing all goals.

The `_toggleTask` method toggles the completion status of a task for the current goal and checks if all tasks have been completed. If all tasks are completed, a dialog is shown that prompts the user to go to the next goal.

The `build` method returns a `Scaffold` that displays the timer or a button to start the timer, depending on the value of `_timerActive`. If the timer is active, the remaining time is displayed along with the title of the current goal and a list of tasks with checkboxes that can be toggled on and off. When a task is toggled, the `_toggleTask` method is called. If the timer is not active, a single button is displayed that starts the timer when pressed.

This app could be improved in many ways, such as adding error handling and validation, allowing the user to input their own goals and tasks, and using a more attractive and user-friendly design. Nonetheless, it should provide a good starting point for implementing the basic functionality you described.
*/

import 'package:flutter/material.dart';

void main() {
  runApp(GoalsApp());
}

class GoalsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goals App',
      home: GoalsScreen(),
    );
  }
}

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> _goals = [
    Goal(
      title: 'Learn Flutter',
      tasks: ['Read documentation', 'Watch tutorials', 'Build a project'],
    ),
    Goal(
      title: 'Exercise',
      tasks: ['Stretch', 'Cardio', 'Strength training'],
    ),
    Goal(
      title: 'Cook a meal',
      tasks: ['Plan menu', 'Grocery shopping', 'Preparation'],
    ),
  ];
  int _currentGoalIndex = 0;
  bool _timerActive = false;
  int _secondsRemaining = 0;
  List<bool> _tasksCompleted = [];

  void startTimer() {
    _secondsRemaining = 1800;
    _timerActive = true;
    _tasksCompleted =
        List.filled(_goals[_currentGoalIndex].tasks.length, false);
    _tick();
  }

  void _tick() async {
    if (_timerActive) {
      setState(() {
        _secondsRemaining--;
      });
      if (_secondsRemaining == 0) {
        _timerActive = false;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Time\'s up!'),
            content: Text('Your 30 minutes are over.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _nextGoal();
                },
                child: Text('Next goal'),
              ),
            ],
          ),
        );
      } else {
        await Future.delayed(Duration(seconds: 1));
        _tick();
      }
    }
  }

  void _nextGoal() {
    setState(() {
      _currentGoalIndex++;
      if (_currentGoalIndex == _goals.length) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You have completed all your goals.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Finish'),
              ),
            ],
          ),
        );
      } else {
        _timerActive = false;
      }
    });
  }

  void _toggleTask(int taskIndex) {
    setState(() {
      _tasksCompleted[taskIndex] = !_tasksCompleted[taskIndex];
      if (_tasksCompleted.every((completed) => completed)) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You have completed all tasks.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _nextGoal();
                },
                child: Text('Next goal'),
              ),
            ],
          ),
        );
        _timerActive = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
      ),
      body: _timerActive
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 48),
                ),
                SizedBox(height: 24),
                Text(
                  'Goal: ${_goals[_currentGoalIndex].title}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 12),
                Text(
                  'Tasks:',
                  style: TextStyle(fontSize: 18),
                ),
                ..._goals[_currentGoalIndex].tasks.asMap().entries.map(
                      (entry) => CheckboxListTile(
                        value: _tasksCompleted[entry.key],
                        onChanged: _timerActive
                            ? (completed) => _toggleTask(entry.key)
                            : null,
                        title: Text(entry.value),
                      ),
                    ),
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: startTimer,
                child: Text('Start'),
              ),
            ),
    );
  }
}

class Goal {
  final String title;
  final List<String> tasks;

  Goal({
    required this.title,
    required this.tasks,
  });
}
