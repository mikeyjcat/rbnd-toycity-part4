require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  def self.create(opts = nil)
    product = new(id: opts[:id], brand: opts[:brand], name: opts[:name],
                  price: opts[:price])
    @data_path = File.dirname(__FILE__) + '/../data/data.csv'

    unless product_in_csv?(product.id)
      add_product_to_csv([product.id, opts[:brand], opts[:name], opts[:price]])
    end
    product
  end

  def self.all
    csv = CSV.read(@data_path)
    csv.map { |p| new(id: p[0], brand: p[1], name: p[2], price: p[3]) }
  end

  def self.first
    csv = CSV.read(@data_path).drop(1)
    new(id: csv[0][0], brand: csv[0][1], name: csv[0][2], price: csv[0][3])
  end

  def self.product_in_csv?(id)
    csv = CSV.read(@data_path)
    csv.find { |p| id == p[0] }
  end

  def self.add_product_to_csv(product)
    CSV.open(@data_path, 'a') do |new_csv|
      new_csv << product
    end
  end
end
