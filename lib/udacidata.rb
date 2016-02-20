require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  def self.create(opts = nil)
    product = new(id: opts[:id], brand: opts[:brand], name: opts[:name],
                  price: opts[:price])
    # puts "product #{product}"
    @data_path = File.dirname(__FILE__) + '/../data/data.csv'
    csv = CSV.read(@data_path)
    # puts "product id #{product.id}"
    # puts "csv read #{csv}"
    unless csv.find { |p| product.id == p[0] }
      CSV.open(@data_path, 'a') do |new_csv|
        # new_csv << csv
        new_csv << [product.id, opts[:brand], opts[:name], opts[:price]]
      end
    end
    product
  end
end
