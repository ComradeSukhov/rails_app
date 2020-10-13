class LoginsController < ApplicationController

  rescue_from RuntimeError do
    redirect_to :login, notice: 'Неверный пароль'
  end
    
  def show
  end

  def create
    login_service = LoginService.new(params[:login], params[:password], session)
    redirect_to :login, notice: login_service.message
  end


#   def create
#     if params[:password] == '123'
#       session[:login]     = params[:login]
#       session[:balance] ||= 1000
#       redirect_to :login, notice: "#{greeting}, #{session[:login]}"
#     else
#       redirect_to :login, notice: 'Неверный пароль'
#     end
#   end

  def destroy
    session.delete(:login)
    session.delete(:balance)
    redirect_to :login, notice: 'Вы вышли'
  end

  private

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
