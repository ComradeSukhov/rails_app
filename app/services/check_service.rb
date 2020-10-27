class CheckService
  attr_reader :params, :config

  def initialize(params)
    @params = params
  end

  def get_confg
    client   = HTTPClient.new
    response = client.request(:get, 'http://possible_orders.srv.w55.ru/')
    config   = JSON.parse(response.body)
    @config  = config['specs']
  end

  def checking_params
    if @config[0]['os'][0] == @params[:os] && @config[0]['cpu'].include?(@params[:cpu].to_i)
      return "Good job!"
    else
      return "Need more power! #{@config[0]['os'] == @params[:os]} need to be true and
      #{@config[0]['cpu'].include?(@params[:cpu])} need to be true.

      #{@config[0]['os']} != #{@params[:os]} &&
      #{@config[0]['cpu']} != #{@params[:cpu]} "
    end
  end
end