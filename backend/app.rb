require 'bcrypt'
require 'sinatra'
require 'time'
require 'jwt'
require 'debug'

MY_SECRET_SIGNING_KEY = "THISISASUPERSECRET"

class QotdApi < Sinatra::Base

  def initialize
    super
    @db = SQLite3::Database.new('db/log-o-matic.db')
    @db.results_as_hash = true
  end

  helpers do

    def authenticated?
      jwt_bearer_token = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
      return false unless jwt_bearer_token
      p "JWT bearer | #{jwt_bearer_token}"
      begin
        @token = JWT.decode(jwt_bearer_token, MY_SECRET_SIGNING_KEY, false)
        @user = @db.execute("SELECT * FROM users WHERE id = ?", @token.first['id']).first
        return !!@user
      rescue JWT::DecodeError => ex
        return false
      end
    end

    def unauthorized_response
      halt 401, { error: 'Unauthorized' }.to_json
    end

  end

  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    content_type :json
    sleep 1 #simulate slow internet connection
  end

  options "*" do
    response.headers["Access-Control-Allow-Methods"] = "GET, PUT, POST, PATCH, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Location, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Expose-Headers"] = "Location, Link"
    200
  end

  # Gets all students
  get '/admin/students' do
    @db.execute('SELECT u.*, t.name AS teacher_name FROM users u LEFT JOIN users t ON u.teacherId = t.userId WHERE u.isTeacher = ?', 0).to_json
  end

  get '/admin/student/:id' do
    p "Getting user: #{id}"

    @db.execute('SELECT * FROM users WHERE id = ? LIMIT 1', params['id']).first.to_json
  end

  post '/admin/addStudent' do
    user_data = JSON.parse(request.body.read)
    user = @db.execute('INSERT INTO users (email, name, password, teacherId, isTeacher) VALUES (?, ?, ?, ?, ?)', [user_data['email'], user_data['name'], BCrypt::Password.new(user_data['password']), user_data['teacherId'], 0])
  end

  # Gets all teachers
  get '/admin/teacher' do
    @db.execute('SELECT * FROM users WHERE isTeacher = ?', 1).to_json
  end

  get '/admin/teacher/:id' do
    p "Getting user: #{id}"
    
    @db.execute('SELECT * FROM users WHERE id = ? LIMIT 1', params['id']).first.to_json
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
    p "Getting all users"
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
    p "Signing in"
    user_data = JSON.parse(request.body.read)
    user = @db.execute('SELECT * FROM users WHERE username = ?', user_data['username']).first

    if user && BCrypt::Password.new(user['encrypted_password']) == user_data['password']
      token = JWT.encode({ id: user['id'], issued_at: Time.now }, MY_SECRET_SIGNING_KEY)
      { token: token }.to_json
    else
      unauthorized_response
    end
  end
end