require 'bcrypt'
require 'debug'
require 'sinatra'
require 'time'
require 'jwt'
require 'json'

MY_SECRET_SIGNING_KEY = 'your-256-bit-secret'

class App < Sinatra::Base
  def initialize
    super
    @db = SQLite3::Database.new('db/log-o-matic.db')
    @db.results_as_hash = true
  end

  helpers do
    def authenticated?
      # jwt_bearer_token = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
      # return false unless jwt_bearer_token

      # p "JWT bearer | #{jwt_bearer_token}"
      # begin
      #  @token = JWT.decode(jwt_bearer_token, MY_SECRET_SIGNING_KEY, false)
      #  @user = @db.execute('SELECT * FROM users WHERE id = ?', @token.first['id']).first
      #  !!@user
      # rescue JWT::DecodeError => e
      #  false
      # end
      true
    end

    def unauthorized_response
      puts('Failed Response')
      halt 401, { error: 'Unauthorized' }.to_json
    end
  end

  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    content_type :json
    sleep 1 # simulate slow internet connection
  end

  options '*' do
    response.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] =
      'Authorization, Content-Type, Location, Accept, X-User-Email, X-Auth-Token'
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Expose-Headers'] = 'Location, Link'
    200
  end

  # Admin
  post '/admin/resetPassword' do
    user_data = JSON.parse(request.body.read)
    user = @db.execute('UPDATE users SET password = ? WHERE email = ?', [BCrypt::Password.create(user_data['password']), user_data['email']])
  end

  get '/admin/person/:id' do
    p "Getting user: #{id}"
    
    @db.execute('SELECT * FROM users WHERE userId = ? LIMIT 1', params['id']).first.to_json
  end

  # Students
  get '/admin/students' do
    @db.execute('SELECT u.*, t.userId AS teacher_id, t.name AS teacher_name FROM users u LEFT JOIN users t ON u.teacherId = t.userId WHERE u.isTeacher = ?', 0).to_json
  end

  post '/admin/student/changeTeacher' do
    user_data = JSON.parse(request.body.read)
    user = @db.execute('UPDATE users SET teacherId = ? WHERE email = ?', [user_data['teacherId'], user_data['email']])
  end

  post '/admin/student/add' do
    user_data = JSON.parse(request.body.read)
    user = @db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', [user_data['email'], user_data['name'], BCrypt::Password.create(user_data['password']), user_data['teacherId'], 0])
  end

  # Teachers
  get '/admin/teachers' do
    @db.execute('SELECT * FROM users WHERE isTeacher = ?', 1).to_json
  end

  post '/admin/teacher/add' do
    user_data = JSON.parse(request.body.read)
    user = @db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', [user_data['email'], user_data['name'], BCrypt::Password.create(user_data['password']), nil, 1])
  end
  
  # Questions
  get '/admin/questions' do
    @db.execute('SELECT * FROM questions').to_json
  end

  post '/admin/question/update' do
    user_data = JSON.parse(request.body.read)
    user = @db.execute('UPDATE questions SET question = ? WHERE questionId = ?', [user_data['question'], user_data['questionId']])
  end

  post '/admin/question/remove' do
    user_data = JSON.parse(request.body.read)
    user = @db.execute('DELETE FROM questions WHERE questionId = ?', user_data)
  end

  post '/admin/question/add' do
    user_data = JSON.parse(request.body.read)
    user = @db.execute('INSERT INTO questions (question) VALUES (?)', user_data)

    true
  get '/api/v1/posts' do
    content_type :json

    puts('Attempting to fetch backend data for Posts')

    if authenticated?

      puts('Succeeded in Authentification')
      student_id = params['studentId']
      week = params['week']
      puts "Student ID: #{params['studentId']}, Week: #{params['week']}"
      posts = @db.execute('SELECT * FROM posts WHERE userId = ? AND week = ?', [student_id, week])

      puts "Found posts #{posts}"

      result = posts.map do |post|
        post_id = post['postId']

        questions = @db.execute(
          'SELECT questionId, question FROM questions WHERE questionId IN (SELECT questionId FROM answers WHERE postId = ?)', [post_id]
        )

        answers = @db.execute('SELECT answerId, questionId, answer FROM answers WHERE postId = ?', post_id)
        # Fetch related comments
        comments = @db.execute('SELECT commentId, userId, comment FROM comments WHERE postId = ?', post_id)

        puts "Inputting answers: #{answers} and comments #{comments} for post id #{post_id}"
        {
          postId: post['postId'],
          userId: post['userId'],
          date: post['date'],
          questions: questions,
          answers: answers,
          comments: comments
        }
      end

      result.to_json
    else
      unauthorized_response
    end
  end

  get '/api/v1/qotd' do
    if authenticated?
      qotd = @db.execute('SELECT * FROM qotd ORDER BY RANDOM() LIMIT 1').first.to_json
      qotd
    else
      unauthorized_response
    end
  end

  get '/api/v1/users/?' do
    p 'Getting all users'
    if authenticated?
      @db.execute('SELECT id, username FROM users').to_json
    else
      unauthorized_response
    end
  end

  get '/api/v1/users/:id/?' do
    p "Getting user: #{id}"
    if authenticated?
      @db.execute('SELECT id, username FROM users WHERE id = ? LIMIT 1', params['id']).first.to_json
    else
      unauthorized_response
    end
  end

  post '/api/v1/users/signin' do
    p 'Signing in'
    user_data = JSON.parse(request.body.read)
    user = @db.execute('SELECT * FROM users WHERE email = ?', user_data['email']).first

    if user && BCrypt::Password.new(user['password']) == user_data['password']
      token = JWT.encode({ id: user['id'], issued_at: Time.now }, MY_SECRET_SIGNING_KEY)
      { token: token , isTeacher: user['isTeacher']}.to_json
    else
      unauthorized_response
    end
  end
end
