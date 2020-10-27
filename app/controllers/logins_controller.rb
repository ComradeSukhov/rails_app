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

  def destroy
    session.delete(:login)
    session.delete(:credits)
    redirect_to :login, notice: 'Вы вышли'
  end
end
