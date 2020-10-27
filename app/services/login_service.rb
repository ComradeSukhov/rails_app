class LoginService
  attr_reader :login, :password, :session

  def initialize(login, password, session)
    @login, @password, @session = login, password, session
  end

  def message
    raise if password != '123'

    session[:login] = login
    session[:credits] ||= 1000

    "#{greeting}, #{login}"
  end

  def greeting
    case Time.now.hour
    when (6..10)
        'Доброе утро'
    when (11..18)
        'Добрый день'
    when (19..22)
        'Добрый вечер'
    when (23..5)
        'Доброй ночи'
    end
  end

end
  