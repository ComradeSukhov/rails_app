class OrdersController < ApplicationController
  # Полное отключение проверки токена
  skip_before_action :verify_authenticity_token

  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index

    orders = Order.includes(:networks, :tags)

    render json: orders

    # With help Serializer
    # render json: Order.first(3), each_serializer: OrderSerializer
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    render json: params
  end

  def calc
    render plain: rand(100)
  end

  def first
    @order = Order.first
    render :show
  end
  
  def check
    if session[:login]

      unless session[:credits]
        render json: { result: false, error: 'Mister, you dont have a wallet. How were you going to pay?' }, status: :unauthorized
        return
      end

      begin
        check = CheckService.new(vm_params)
        if check.params_available?
          cost = check.cost_request['cost']
          balance = session[:credits]
          if balance >= cost
          render json: {
            result: true,
            total: cost,
            balance: session[:credits],
            balance_after_transaction: balance - cost
          }, status: :ok
          else
            render json: { result: false, error: 'Not enough gold' }, status: :not_acceptable
          end
        else
          render json: { result: false, error: 'Parameters is not available' }, status: :not_acceptable
        end
      rescue(SocketError)
        render json: { result: false, error: 'Access error to the external system' }, status: 503
      end
      
    else
      redirect_to :login, notice: 'Войдите в систему что бы проверить заказ'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params[:order][:status] = params[:order][:status].to_i
      params.require(:order).permit(:name, :status, :cost, :user_id)
    end
    
    def vm_params
      params.permit(:cpu, :ram, :hdd_type, :hdd_capacity, :os)
    end
end
