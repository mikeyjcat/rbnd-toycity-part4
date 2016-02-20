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
