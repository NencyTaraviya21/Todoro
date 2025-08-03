import 'package:todoro/import_export/todoro_import_export.dart';

class DatabaseService extends GetxService {
  Database? _database;

  Future<DatabaseService> init() async {
    await initDatabase();
    return this;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    return await openDatabase(
      path,
      version: DB_VERSION,
      onCreate: createTables,
      onUpgrade: onUpgrade,
    );
  }

  Future<void> createTables(Database db, int version) async {
    // region Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        priority VARCHAR(20) NOT NULL DEFAULT 'medium',
        deadline DATETIME,
        estimatedPomodoros INTEGER NOT NULL DEFAULT 1,
        completedPomodoros INTEGER NOT NULL DEFAULT 0,
        isCompleted BOOLEAN NOT NULL DEFAULT 0,
        createdAt DATETIME NOT NULL,
        updatedAt DATETIME NOT NULL
      )
    ''');
  //endregion
    // region PomodoroSessions table
    await db.execute('''
      CREATE TABLE pomodoroSessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER NOT NULL,
        startTime DATETIME NOT NULL,
        endTime DATETIME,
        type BOOLEAN NOT NULL,
        wasCompleted BOOLEAN NOT NULL DEFAULT 0,
        createdAt DATETIME NOT NULL,
        FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');
  //endregion
    // region indexes
    await db.execute('CREATE INDEX idx_tasks_userId ON tasks(userId)');
    await db.execute('CREATE INDEX idx_tasks_priority ON tasks(priority)');
    await db.execute('CREATE INDEX idx_tasks_deadline ON tasks(deadline)');
    await db.execute(
      'CREATE INDEX idx_pomodoroSessions_taskId ON pomodoroSessions(taskId)',
    );
    //endregion
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS pomodoroSessions');
      await db.execute('DROP TABLE IF EXISTS tasks');
      await createTables(db, newVersion);
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  @override
  void onClose() {
    closeDatabase();
    super.onClose();
  }
}
