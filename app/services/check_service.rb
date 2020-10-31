class CheckService
  attr_reader :params, :configs

  def initialize(params)
    @params = params
    @params[:cpu] = @params[:cpu]&.to_i
    @params[:ram] = @params[:ram]&.to_i
    @params[:hdd_capacity] = @params[:hdd_capacity]&.to_i
    get_config
  end

  def get_config
    client    = HTTPClient.new
    response  = client.request(:get, 'http://possible_orders.srv.w55.ru/')
    configs   = JSON.parse(response.body)
    @configs  = configs['specs']
  end

  def params_available?
    @configs.each do |config|
      # 'eq' mean equality
            eq_of_os = config['os'].include?(@params[:os])
           eq_of_cpu = config['cpu'].include?(@params[:cpu])
           eq_of_ram = config['ram'].include?(@params[:ram])
      eq_of_hdd_type = config['hdd_type'].include?(@params[:hdd_type])

      if (eq_of_os &&
          eq_of_cpu &&
          eq_of_ram &&
          eq_of_hdd_type &&
          eq_of_hdd_capacity(config))
            return true
      else
        next
      end
    end
    return false
  end

  def cost_request
    client         = HTTPClient.new
    response_query = "cpu=#{@params[:cpu]}&ram=#{@params[:ram]}" +
                     "&hdd_type=#{@params[:hdd_type]}&hdd_capacity=#{@params[:hdd_capacity]}"

    response  = client.request(:get, "http://cost_server:3001?#{response_query}/")
    configs   = JSON.parse(response.body)
  end

  private

  def eq_of_hdd_capacity(config)
    permitted_hdd_capacity = config['hdd_capacity'][@params[:hdd_type]]
        eq_of_hdd_capacity = (permitted_hdd_capacity['from']..permitted_hdd_capacity['to'])
                             .include?(@params[:hdd_capacity])
  end

end