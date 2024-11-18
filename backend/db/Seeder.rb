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


    encrypted_password1 = BCrypt::Password.create("123")
    encrypted_password2 = BCrypt::Password.create("abc")
  #   db.execute('INSERT INTO users (username, encrypted_password) VALUES (?, ?)', ["ola", encrypted_password1])

  #   db.execute('INSERT INTO qotd (author, quote) VALUES (?,?)' ,["Bill Gates", "Today, you always know whether you are on the Internet or on your PC's hard drive. Tomorrow, you will not care and may not even know."])
  end
end