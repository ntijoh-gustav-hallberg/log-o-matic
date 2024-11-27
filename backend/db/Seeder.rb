require 'sqlite3'
require 'bcrypt'

class Seeder
  def self.seed!
    db = SQLite3::Database.new('db/log-o-matic.db')

    print('Seeding the Seedy Seed')

    db.execute('DROP TABLE IF EXISTS users')
    db.execute('DROP TABLE IF EXISTS answers')
    db.execute('DROP TABLE IF EXISTS comments')
    db.execute('DROP TABLE IF EXISTS posts')
    db.execute('DROP TABLE IF EXISTS questions')

    db.execute('CREATE TABLE users(
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        password TEXT NOT NULL,
        teacherId INTERGER,
        isTeacher INTEGER
    )')
    db.execute('CREATE TABLE answers(
      answerId INTEGER PRIMARY KEY AUTOINCREMENT,
      questionId INTEGER,
      postId INTEGER NOT NULL,
      answer TEXT NOT NULL
    )')
    db.execute('CREATE TABLE comments(
      commentId INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      comment TEXT NOT NULL,
      postId INTEGER NOT NULL
    )')
    db.execute('CREATE TABLE posts(
      postId INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      date TEXT NOT NULL,
      week INTEGER NOT NULL
    )')
    db.execute('CREATE TABLE questions(
      questionId INTEGER PRIMARY KEY AUTOINCREMENT,
      question TEXT
    )')

    add_data(db)
  end

  def self.add_data(db)
    # Encrypt password using BCrypt for security
    encrypted_password = BCrypt::Password.create('studentpassword')
  
    # Insert one student with encrypted password
    db.execute('INSERT INTO users (email, name, password, isTeacher) VALUES (?, ?, ?, ?)',
               ['student@example.com', 'John Student', encrypted_password, 0]) # Student
  
    # Insert posts for week 47 (one post for each day: Monday to Friday)
    db.execute('INSERT INTO posts (userId, date, week) VALUES (?, ?, ?)', [0, '2024-11-18', 47]) # Monday
    db.execute('INSERT INTO posts (userId, date, week) VALUES (?, ?, ?)', [0, '2024-11-19', 47]) # Tuesday
    db.execute('INSERT INTO posts (userId, date, week) VALUES (?, ?, ?)', [0, '2024-11-20', 47]) # Wednesday
    db.execute('INSERT INTO posts (userId, date, week) VALUES (?, ?, ?)', [0, '2024-11-21', 47]) # Thursday
    db.execute('INSERT INTO posts (userId, date, week) VALUES (?, ?, ?)', [0, '2024-11-22', 47]) # Friday
  
    # Insert 2 programming-related questions
    db.execute('INSERT INTO questions (question) VALUES (?)', ['What programming language do you prefer?'])
    db.execute('INSERT INTO questions (question) VALUES (?)', ['What is your favorite coding project?'])
  
    # Insert some test data for users (teacher and student)
    encrypted_password1 = BCrypt::Password.create("123")
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?,?,?,?,?)', ['1@1.se', 'skibidi', encrypted_password1, nil, 1]) # Teacher
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?,?,?,?,?)', ['2@2.se', 'rizzler', encrypted_password1, 1, 0]) # Student
  
    # Insert a few more users, one teacher and students
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', ["daniel.berg@ga.ntig.se", "Daniel Berg", BCrypt::Password.create("abc"), nil, 1]) # Teacher
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', ["emma.svensson@elev.ga.ntig.se", "Emma Svensson", BCrypt::Password.create("123"), 3, 0]) # Student
  
    # Insert questions
    db.execute('INSERT INTO questions (question) VALUES (?)', "Hur mår du?")
    db.execute('INSERT INTO questions (question) VALUES (?)', "Vad har du gjort idag?")
  
    # Insert answers for posts
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [1, 1, 'Python']) # Monday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [2, 1, 'Building a web scraper']) # Monday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [1, 2, 'JavaScript']) # Tuesday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [2, 2, 'Building an API with Node.js']) # Tuesday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [1, 3, 'Ruby']) # Wednesday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [2, 3, 'Developing a mobile app']) # Wednesday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [1, 4, 'C#']) # Thursday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [2, 4, 'Building a game engine']) # Thursday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [1, 5, 'Go']) # Friday
    db.execute('INSERT INTO answers (questionId, postId, answer) VALUES (?, ?, ?)', [2, 5, 'Developing cloud-based applications']) # Friday
  
    # Insert comments (one teacher commenting on students' posts)
    db.execute('INSERT INTO comments (userId, comment, postId) VALUES (?, ?, ?)', [1, 'Great answers! Keep it up!', 1]) # Teacher commenting on Monday's post
    db.execute('INSERT INTO comments (userId, comment, postId) VALUES (?, ?, ?)', [1, 'Nice project idea for a mobile app!', 3]) # Teacher commenting on Wednesday's post
  end
  
end
