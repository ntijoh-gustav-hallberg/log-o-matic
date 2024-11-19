require 'sqlite3'
require 'bcrypt'
class Seeder

  def self.seed!  
    db = SQLite3::Database.new('db/log-o-matic.db')

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
      date TEXT NOT NULL
    )')
    db.execute('CREATE TABLE questions(
      questionId INTEGER PRIMARY KEY AUTOINCREMENT,
      question TEXT
    )')


    # Test data
    encrypted_password1 = BCrypt::Password.create("123")
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?,?,?,?,?)', ['1@1.se', 'skibidi', encrypted_password1, nil, 1])
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?,?,?,?,?)', ['2@2.se', 'rizzler', encrypted_password1, 1, 0])

    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', ["daniel.berg@ga.ntig.se", "Daniel Berg", BCrypt::Password.create("abc"), nil, 1])
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', ["ola.lindberg@ga.ntig.se", "Ola Lindberg", BCrypt::Password.create("def"), nil, 1])
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', ["emma.svensson@elev.ga.ntig.se", "Emma Svensson", BCrypt::Password.create("123"), 3, 0])
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', ["alex.johansson@elev.ga.ntig.se", "Alex Johansson", BCrypt::Password.create("123"), 3, 0])
    db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', ["maria.karlsson@elev.ga.ntig.se", "Maria Karlsson", BCrypt::Password.create("123"), 4, 0])

  #   db.execute('INSERT INTO qotd (author, quote) VALUES (?,?)' ,["Bill Gates", "Today, you always know whether you are on the Internet or on your PC's hard drive. Tomorrow, you will not care and may not even know."])
  end
end