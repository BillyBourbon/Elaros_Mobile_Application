BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "CaloriesConsumption" (
	"id"	INTEGER,
	"timestamp"	DATETIME,
	"calories"	REAL
);
CREATE TABLE IF NOT EXISTS "HeartRate" (
	"id"	INTEGER,
	"timestamp"	DATETIME,
	"value"	INTEGER
);
CREATE TABLE IF NOT EXISTS "Intensities" (
	"id"	INTEGER,
	"timestamp"	DATETIME,
	"intensity"	INTEGER
);
CREATE TABLE IF NOT EXISTS "IntensityStates" (
	"id"	INTEGER NOT NULL UNIQUE,
	"value"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "SleepLogs" (
	"id"	INTEGER,
	"timestamp"	DATETIME,
	"value"	INTEGER
);
CREATE TABLE IF NOT EXISTS "SleepStates" (
	"id"	INTEGER NOT NULL UNIQUE,
	"value"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "StepCount" (
	"id"	INTEGER,
	"timestamp"	DATETIME,
	"steps"	INTEGER
);
CREATE TABLE IF NOT EXISTS "UserGoals" (
	"userId"	INTEGER NOT NULL,
	"goalName"	TEXT NOT NULL UNIQUE,
	"goalValue"	INTEGER NOT NULL,
	"dataSource"	TEXT NOT NULL,
	PRIMARY KEY("userId","goalName")
);
CREATE TABLE IF NOT EXISTS "UserProfile" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"age"	INTEGER NOT NULL CHECK("age" > 0 AND "age" < 150),
	"gender"	TEXT NOT NULL,
	"height"	REAL NOT NULL CHECK("height" > 0),
	"weight"	REAL NOT NULL CHECK("weight" > 0),
	"medical_condition"	TEXT,
	"profile_image_url"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
COMMIT;
