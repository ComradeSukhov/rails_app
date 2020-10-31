class ReportService

  def initialize(report)
    @report = report
  end

  def body
    reporter = ReportController.new
    reporter.__send__( @report.name.to_sym, @report.quantity.to_i, @report.hdd_type )
  end

end

class CostManager
  attr_accessor :data, :price  

  def initialize(data, price)
    @data  = data
    @prices = price
  end

  def set_cost
    if @data.class == Array
      @data.each { |vm| vm.cost = calc_cost(vm) }
    else
      @data.cost = calc_cost(vm)
    end
  end

  def calc_cost(vm)
    cpu_price = find_price('cpu')
    ram_price = find_price('ram')
    hdd_price = find_price(vm.hdd_type)

    cpu_cost     = cpu_price * vm.cpu
    ram_cost     = ram_price * vm.ram
    hdd_cost     = hdd_price * vm.hdd_capacity
    add_hdd_cost = clac_add_hdd(vm)

    cost = cpu_cost + ram_cost + hdd_cost + add_hdd_cost

    # Изначально цены установленны в копейках. Приводим цену к рублевому эквиваленту
    cost / 100
  end

  def find_price(incoming_price_name)
    found_price = @prices.select do |price|
                    price_name = price.select { |parametr| parametr.class == String }[0]
                    price_name == incoming_price_name
                  end

    # Во втором элементе массива ожидаем стоимость. В первом лежит имя товара
    found_price[0][1]
  end

  def clac_add_hdd(vm)
    add_hdd_cost = vm.addit_hdd.map do |hdd|
                     hdd_type     = hdd[:hdd_type]
                     hdd_capacity = hdd[:hdd_capacity]

                     hdd_capacity * find_price(hdd_type)
                   end
    add_hdd_cost.sum
  end
end

class CsvReader
  require 'csv'

  def initialize(csv_file_name)
    # Создаем переменную с путем до CSV файла
    сurrent_path = File.expand_path(File.dirname(__FILE__))
    @csv_file_dir = "#{сurrent_path}/csv_db/#{csv_file_name}"
  end

  # CSV.open возвращает 2-мерный массив
  def read
    csv = CSV.open(@csv_file_dir)
    csv.map { |arr| reveal_integers(arr) }
  end

  private

  # Меняет на числа те строки, который выражают собой числа
  def reveal_integers(arr)
    arr.map { |val| val.match?(/\A\d+\z/) ? val.to_i : val }
  end

end

class ReportController
  def initialize
  end

  def most_expensive(quantity = 1)
    vm_confs    = CsvReader.new('02_ruby_vms.csv').read
    vol_confs   = CsvReader.new('02_ruby_volumes.csv').read
    price_confs = CsvReader.new('02_ruby_prices.csv').read

    vms = VM.new_array(vm_confs, vol_confs)

    # Устанавливаем цену для каждой ВМ
    cost_manager = CostManager.new(vms,price_confs)
    cost_manager.set_cost

    selecter           = Selecter.new(vms)
    vms_most_expensive = selecter.most_expensive(quantity)

    report = Reporter.new(vms_most_expensive)
    report.most_expensive_report
  end

  def cheapest(quantity = 1)
    vm_confs    = CsvReader.new('02_ruby_vms.csv').read
    vol_confs   = CsvReader.new('02_ruby_volumes.csv').read
    price_confs = CsvReader.new('02_ruby_prices.csv').read

    vms = VM.new_array(vm_confs, vol_confs)

    # Устанавливаем цену для каждой ВМ
    cost_manager = CostManager.new(vms,price_confs)
    cost_manager.set_cost

    selecter     = Selecter.new(vms)
    vms_cheapest = selecter.cheapest(quantity)

    report = Reporter.new(vms_cheapest)
    report.cheapest_report
  end

  def most_voluminous_by_type(type, quantity = 1)
    vm_confs    = CsvReader.new('02_ruby_vms.csv').read
    vol_confs   = CsvReader.new('02_ruby_volumes.csv').read
    price_confs = CsvReader.new('02_ruby_prices.csv').read

    vms = VM.new_array(vm_confs, vol_confs)

    # Устанавливаем цену для каждой ВМ
    cost_manager = CostManager.new(vms,price_confs)
    cost_manager.set_cost

    selecter                    = Selecter.new(vms)
    vms_most_voluminous_by_type = selecter.most_voluminous_by_type(type, quantity)

    report = Reporter.new(vms_most_voluminous_by_type)
    report.most_voluminous_by_type_report(type)
  end

  def most_add_hdd_by_quant(quantity = 1, type = nil)
    vm_confs    = CsvReader.new('02_ruby_vms.csv').read
    vol_confs   = CsvReader.new('02_ruby_volumes.csv').read
    price_confs = CsvReader.new('02_ruby_prices.csv').read

    vms = VM.new_array(vm_confs, vol_confs)

    # Устанавливаем цену для каждой ВМ
    cost_manager = CostManager.new(vms,price_confs)
    cost_manager.set_cost

    selecter                  = Selecter.new(vms)
    vms_most_add_hdd_by_quant = selecter.most_add_hdd_by_quant(quantity, type)

    report = Reporter.new(vms_most_add_hdd_by_quant)
    report.most_add_hdd_by_quant_report
  end
  
  def most_add_hdd_by_vol(quantity = 1, type = nil)
    vm_confs    = CsvReader.new('02_ruby_vms.csv').read
    vol_confs   = CsvReader.new('02_ruby_volumes.csv').read
    price_confs = CsvReader.new('02_ruby_prices.csv').read

    vms = VM.new_array(vm_confs, vol_confs)

    # Устанавливаем цену для каждой ВМ
    cost_manager = CostManager.new(vms,price_confs)
    cost_manager.set_cost

    selecter                = Selecter.new(vms)
    vms_most_add_hdd_by_vol = selecter.most_add_hdd_by_vol(quantity, type)

    report = Reporter.new(vms_most_add_hdd_by_vol)
    report.most_add_hdd_by_vol_report
  end
end

class Reporter
  attr_accessor :data
  def initialize(data)
    @data = data
  end

  def most_expensive_report
    report_string = ''
    report_string << header
    report_string << "#{@data.size} самых дорогих ВМ"
    report_string << space_x_2
    @data.each do |vm|
      report_string << vm_main_report(vm)
    end
    report_string
  end

  def cheapest_report
    report_string = ''
    report_string << header
    report_string << "#{@data.size} самых дешевых ВМ"
    report_string << space_x_2
    @data.each do |vm|
      report_string << vm_main_report(vm)
    end
    report_string
  end

  def most_voluminous_by_type_report(type)
    report_string = ''
    report_string << header
    report_string << "#{@data.size} самых объемных ВМ по параметру #{type}"
    report_string << space_x_2
    @data.each do |vm|
      volum = Selecter.new
      volum = volum.culc_vol_by_type(vm, type)
      report_string << "                     Объем дисков #{type} ВМ : #{volum}"
      report_string << vm_main_report(vm)
    end
    report_string
  end

  def most_add_hdd_by_quant_report
    report_string = ''
    report_string << header
    report_string << "#{@data.size} ВМ у которых подключено больше всего дополнительных дисков по количеству"
    report_string << "с учетом типа диска если параметр hdd_type указан"
    report_string << space_x_2
    @data.each do |vm|
      report_string << "Количество дисков ВМ = #{vm.addit_hdd.size}"
      report_string << "\n\r"
      report_string << vm_main_report(vm)
    end
    report_string
  end

  def most_add_hdd_by_vol_report
    report_string = ''
    report_string << header
    report_string << "#{@data.size} ВМ у которых подключено больше всего дополнительных дисков по объему"
    report_string << "с учетом типа диска если параметр hdd_type указан"
    report_string << space_x_2
    @data.each do |vm|
      report_string << vm_main_report(vm)
    end
    report_string
  end

  private

  def vm_main_report(vm)
    vm_main_report_string = ''
    vm_main_report_string << "                     Стоимость ВМ в рублях: #{vm.cost}"
    vm_main_report_string << "                          Идентификатор ВМ: #{vm.id}"
    vm_main_report_string << "              Количество CPU в ВМ в штуках: #{vm.cpu}"
    vm_main_report_string << "Количество оперативной памяти в гигабайтах: #{vm.ram}"
    vm_main_report_string << "                        Тип жесткого диска: #{vm.hdd_type}"
    vm_main_report_string << "                      Объем жесткого диска: #{vm.hdd_capacity}"
    vm_main_report_string << "___________________________________________"
    vm_main_report_string << "Дополнительные жесткие диски:"
    vm.addit_hdd.each_with_index do |hdd, index|
      hdd_type     = hdd[:hdd_type]
      hdd_capacity = hdd[:hdd_capacity]
      vm_main_report_string << "Диск № #{index+1}"
      vm_main_report_string << "Тип: #{hdd_type} | Объем: #{hdd_capacity}"
      vm_main_report_string << "___________________________"
    end
    vm_main_report_string << "\n\r"
    vm_main_report_string << "\n\r"
    vm_main_report_string << "-------------------------------------------"
    vm_main_report_string << "\n\r"
    vm_main_report_string << "\n\r"
    vm_main_report_string
  end

  def header
    header_string = ''
    header_string << '          Отчет'
    header_string << "\n\r"
    header_string
  end

  def space_x_2
    space_x_2 = ''
    space_x_2 << "\n\r"
    space_x_2 << "\n\r"
    space_x_2
  end

end

class Selecter
  attr_accessor :vm_arr
  def initialize(vm_arr = [])
    @vm_arr = vm_arr
  end

  def most_expensive(quantity = 1)
    @vm_arr.max_by(quantity) { |vm| vm.cost }
  end

  def cheapest(quantity = 1)
    @vm_arr.min_by(quantity) { |vm| vm.cost }
  end

  def most_voluminous_by_type(type, quantity = 1)
    @vm_arr.max_by(quantity) do |vm|
      culc_vol_by_type(vm, type)
    end
  end

  def most_add_hdd_by_quant(quantity = 1, type = nil)
    if type == nil
      @vm_arr.max_by(quantity) do |vm|
        vm.addit_hdd.size
      end
    else
      @vm_arr.max_by(quantity) do |vm|
        arr_of_hdd = vm.addit_hdd.select do |hdd|
                       hdd_type     = hdd[:hdd_type]
                       hdd_type == type
                     end
        arr_of_hdd.size
      end
    end
  end

  def most_add_hdd_by_vol(quantity = 1, type = nil)
    if type == nil
      @vm_arr.max_by(quantity) do |vm|
        volum = 0
        vm.addit_hdd.each do |hdd|
          hdd_capacity = hdd[:hdd_capacity]
          volum += hdd_capacity
        end
        volum
      end
    else
      @vm_arr.max_by(quantity) do |vm|
        volum = 0
        vm.addit_hdd.select do |hdd|
          hdd_type     = hdd[:hdd_type]
          hdd_capacity = hdd[:hdd_capacity]

          volum += hdd_capacity if hdd_type == type
        end
        volum
      end
    end
  end

  def culc_vol_by_type(vm, type)
    volum = 0

    # Добавляем объем основного hdd VM если условие true
    volum += vm.hdd_capacity if vm.hdd_type == type

    # Добавляем объем дополнительных hdd VM если условие true
    vm.addit_hdd.each do |hdd|
      hdd_type     = hdd[:hdd_type]
      hdd_capacity = hdd[:hdd_capacity]

      volum += hdd_capacity if hdd_type == type
    end
    volum
  end
end

class VM
  attr_reader :id, :cpu, :ram, :hdd_type, :hdd_capacity, :addit_hdd, :cost
  attr_writer :cost

  def initialize(vm_conf, vol_confs = [])
    @id           = vm_conf[0]
    @cpu          = vm_conf[1]
    @ram          = vm_conf[2]
    @hdd_type     = vm_conf[3]
    @hdd_capacity = vm_conf[4]
    @addit_hdd    = vol_confs
    @cost         = nil
  end

  # Классовый метод который возвращает массив инстансов вычислительных машин
  # Аргумент vm_confs ожидается в виде 2-мерного массива
  def self.new_array(vm_confs, vol_confs = 0)
    vm_confs.map do |vm_conf|
      vm_id = vm_conf[0] 
      VM.new(vm_conf, addit_hdd(vol_confs, vm_id))
    end
  end

  # Классовый метод который возвращает 2-мерный массив где каждый элемент это конфигурация
  # дополнительного hdd
  # Аргумент vol_confs ожидается в виде 2-мерного массива.
  def self.addit_hdd(vol_confs, vm_id)
    hdd_arr = vol_confs.select do |vol_conf|
                vol_conf_vm_id  = vol_conf[0]
                vol_conf_vm_id == vm_id
              end

    # Убираем из конфигураций hdd айдишник VM которому принадлежит hdd
    hdd_arr.map! do |hdd|
        hdd = [hdd[1], hdd[2]]
    end

    hdd_arr.map! do |hdd|
      hdd_type     = hdd.select { |parametr| parametr.class == String }[0]
      hdd_capacity = hdd.select { |parametr| parametr.class == Integer }[0]
      { hdd_type: hdd_type, hdd_capacity: hdd_capacity }
    end
  end

end