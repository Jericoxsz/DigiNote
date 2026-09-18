import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================
// APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DigiNote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DigiColors.primaryPink,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

class DigiColors {
  static const Color primaryPink = Color(0xFFE713C4);
  static const Color lightPink = Color(0xFFF151D6);
  static const Color lavender = Color(0xFFCB93E8);
  static const Color darkPurple = Color(0xFF7B2E9B);

  static const Color background = Color(0xFFFFF8FC);
  static const Color textDark = Color(0xFF2D2630);
  static const Color textGrey = Color(0xFF777177);
}

// ============================================================
// MODELS
// ============================================================

class NoteItem {
  String title;
  String content;

  NoteItem({
    required this.title,
    required this.content,
  });
}

class TaskItem {
  String text;
  bool done;

  TaskItem({
    required this.text,
    this.done = false,
  });
}

class UserAccount {
  String username;
  String password;

  UserAccount({
    required this.username,
    required this.password,
  });
}

// ============================================================
// LOCAL ACCOUNTS
// ============================================================

final Map<String, UserAccount> accounts = {};

// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Please enter username and password.');
      return;
    }

    final account = accounts[username];

    if (account == null || account.password != password) {
      _showMessage('Invalid username or password.');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DigiNoteHome(username: username),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: DigiColors.darkPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DigiColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: DigiColors.darkPurple,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'DIGINOTE',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: DigiColors.textDark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Your simple digital notes',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 35),

                _InputField(
                  controller: usernameController,
                  hintText: 'Username',
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 14),

                _InputField(
                  controller: passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DigiColors.primaryPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      color: DigiColors.darkPurple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REGISTER PAGE
// ============================================================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void _register() {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (username.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showMessage('Please complete all fields.');
      return;
    }

    if (password != confirm) {
      _showMessage('Passwords do not match.');
      return;
    }

    if (accounts.containsKey(username)) {
      _showMessage('Username already exists.');
      return;
    }

    accounts[username] = UserAccount(
      username: username,
      password: password,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully!'),
        backgroundColor: DigiColors.darkPurple,
      ),
    );

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: DigiColors.darkPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DigiColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: DigiColors.textDark,
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Icon(
                Icons.person_add_alt_1_rounded,
                size: 70,
                color: DigiColors.darkPurple,
              ),

              const SizedBox(height: 15),

              const Text(
                'REGISTER',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 30),

              _InputField(
                controller: usernameController,
                hintText: 'Username',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 14),

              _InputField(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _InputField(
                controller: confirmController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: obscureConfirm,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureConfirm = !obscureConfirm;
                    });
                  },
                  icon: Icon(
                    obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DigiColors.primaryPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE INPUT FIELD
// ============================================================

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: DigiColors.darkPurple,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: DigiColors.lavender.withValues(alpha: 0.18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class DigiNoteHome extends StatefulWidget {
  final String username;

  const DigiNoteHome({
    super.key,
    required this.username,
  });

  @override
  State<DigiNoteHome> createState() => _DigiNoteHomeState();
}

class _DigiNoteHomeState extends State<DigiNoteHome> {
  int _selectedTab = 0;

  final List<NoteItem> _notes = [];
  final List<TaskItem> _tasks = [];

  // ==========================================================
  // ADD NOTE
  // ==========================================================

  void _addNote() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return const _AddNoteDialog();
      },
    ).then((result) {
      if (!mounted || result == null) {
        return;
      }

      if (result is Map<String, String>) {
        setState(() {
          _notes.add(
            NoteItem(
              title: result['title']!.isEmpty
                  ? 'Untitled'
                  : result['title']!,
              content: result['content']!,
            ),
          );
        });
      }
    });
  }

  // ==========================================================
  // ADD TASK
  // ==========================================================

  void _addTask() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return const _AddTaskDialog();
      },
    ).then((result) {
      if (!mounted || result == null) {
        return;
      }

      if (result is String && result.trim().isNotEmpty) {
        setState(() {
          _tasks.add(
            TaskItem(
              text: result.trim(),
            ),
          );
        });
      }
    });
  }

  // ==========================================================
  // DELETE TASK
  // ==========================================================

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // ==========================================================
  // DELETE NOTE
  // ==========================================================

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  // ==========================================================
  // TOGGLE TASK
  // ==========================================================

  void _toggleTaskDone(int index) {
    setState(() {
      _tasks[index].done = !_tasks[index].done;
    });
  }

  // ==========================================================
  // OPEN NOTE
  // ==========================================================

  Future<void> _openNote(int index) async {
    final note = _notes[index];

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteDetailPage(
          title: note.title,
          content: note.content,
        ),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      if (result['delete'] == true) {
        _notes.removeAt(index);
      } else {
        final title = (result['title'] as String).trim();
        final content = (result['content'] as String).trim();

        _notes[index].title =
            title.isEmpty ? 'Untitled' : title;

        _notes[index].content = content;
      }
    });
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final isNoteTab = _selectedTab == 0;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ====================================================
          // HEADER
          // ====================================================

          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20,
              topPadding + 14,
              12,
              18,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DigiColors.primaryPink,
                  DigiColors.lightPink,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIGINOTE',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Hello! Keep your notes organized.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: _logout,
                  tooltip: 'Logout',
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // ====================================================
          // CONTENT
          // ====================================================

          Expanded(
            child: Stack(
              children: [
                isNoteTab
                    ? _buildNoteList()
                    : _buildTaskList(),

                // =================================================
                // FLOATING ADD BUTTON
                // =================================================

                Positioned(
                  right: 20,
                  bottom: 18,
                  child: GestureDetector(
                    onTap: isNoteTab ? _addNote : _addTask,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: DigiColors.darkPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: DigiColors.darkPurple
                                .withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 31,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ====================================================
          // BOTTOM NAVIGATION
          // ====================================================

          Row(
            children: [
              Expanded(
                child: _TabButton(
                  label: 'NOTE',
                  icon: Icons.menu_book_rounded,
                  selected: _selectedTab == 0,
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                  },
                ),
              ),

              Expanded(
                child: _TabButton(
                  label: 'TASK',
                  icon: Icons.checklist_rounded,
                  selected: _selectedTab == 1,
                  onTap: () {
                    setState(() {
                      _selectedTab = 1;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // NOTE LIST
  // ==========================================================

  Widget _buildNoteList() {
    if (_notes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.note_alt_outlined,
                size: 70,
                color: DigiColors.lavender.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 12),
              Text(
                'No notes yet.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap + to add one.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        95,
      ),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];

        return Dismissible(
          key: ValueKey(note),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            _deleteNote(index);
          },
          background: _deleteBackground(),
          child: GestureDetector(
            onTap: () {
              _openNote(index);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: DigiColors.lavender.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.note_alt_rounded,
                      color: DigiColors.darkPurple,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: DigiColors.textDark,
                          ),
                        ),

                        if (note.content.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // TASK LIST
  // ==========================================================

  Widget _buildTaskList() {
    if (_tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.checklist_rounded,
                size: 70,
                color: DigiColors.lavender.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 12),
              Text(
                'No tasks yet.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap + to add one.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        95,
      ),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];

        return Dismissible(
          key: ValueKey(task),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            _deleteTask(index);
          },
          background: _deleteBackground(),
          child: GestureDetector(
            onTap: () {
              _toggleTaskDone(index);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: DigiColors.lavender.withValues(
                  alpha: task.done ? 0.48 : 0.78,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      task.done
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: DigiColors.darkPurple,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Text(
                      task.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: DigiColors.textDark,
                        fontWeight: FontWeight.w600,
                        decoration: task.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // DELETE BACKGROUND
  // ==========================================================

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 22),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

// ============================================================
// ADD NOTE DIALOG
// FIXED VERSION
// ============================================================

class _AddNoteDialog extends StatefulWidget {
  const _AddNoteDialog();

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _add() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    Navigator.pop(
      context,
      {
        'title': title,
        'content': content,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      title: const Text(
        'Add Note',
        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Title',
              filled: true,
              fillColor:
                  DigiColors.lavender.withValues(alpha: 0.28),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 120,
            child: TextField(
              controller: contentController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Note content...',
                filled: true,
                fillColor:
                    DigiColors.lavender.withValues(alpha: 0.28),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: DigiColors.darkPurple,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        ElevatedButton(
          onPressed: _add,
          style: ElevatedButton.styleFrom(
            backgroundColor: DigiColors.primaryPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// ============================================================
// ADD TASK DIALOG
// FIXED VERSION
// ============================================================

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _add() {
    final text = controller.text.trim();

    if (text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context, text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      title: const Text(
        'Add Task',
        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      scrollable: true,
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Type your task...',
          filled: true,
          fillColor:
              DigiColors.lavender.withValues(alpha: 0.28),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: DigiColors.darkPurple,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        ElevatedButton(
          onPressed: _add,
          style: ElevatedButton.styleFrom(
            backgroundColor: DigiColors.primaryPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// ============================================================
// NOTE DETAIL PAGE
// ============================================================

class NoteDetailPage extends StatefulWidget {
  final String title;
  final String content;

  const NoteDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.title,
    );

    contentController = TextEditingController(
      text: widget.content,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(
      context,
      {
        'title': titleController.text,
        'content': contentController.text,
      },
    );
  }

  void _delete() {
    Navigator.pop(
      context,
      {
        'delete': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: DigiColors.primaryPink,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Note',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _delete,
            icon: const Icon(
              Icons.delete_outline_rounded,
            ),
          ),
          IconButton(
            onPressed: _save,
            icon: const Icon(
              Icons.check_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  filled: true,
                  fillColor:
                      DigiColors.lavender.withValues(alpha: 0.28),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color:
                        DigiColors.lavender.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical:
                        TextAlignVertical.top,
                    style: const TextStyle(
                      fontSize: 16,
                      color: DigiColors.textDark,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write your note...',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// BOTTOM TAB BUTTON
// ============================================================

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? DigiColors.primaryPink
              : DigiColors.lightPink,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: DigiColors.primaryPink
                        .withValues(alpha: 0.18),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: const Offset(0, -1),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: selected
                  ? BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white
                              .withValues(alpha: 0.35),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    )
                  : null,
              child: Icon(
                icon,
                color: Colors.black,
                size: 22,
              ),
            ),

            const SizedBox(height: 3),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                color: Colors.black,
                fontWeight: selected
                    ? FontWeight.w900
                    : FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                shadows: selected
                    ? [
                        Shadow(
                          color: Colors.white
                              .withValues(alpha: 0.35),
                          blurRadius: 3,
                        ),
                      ]
                    : [],
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}