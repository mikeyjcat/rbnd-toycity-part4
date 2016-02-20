require_relative 'find_by'
require_relative 'errors'
require 'csv'

# TODO: Introduce error checking and error class
class Udacidata
  def self.create(opts = nil)
    object = new(id: opts[:id], brand: opts[:brand], name: opts[:name],
                 price: opts[:price])
    @data_path = File.dirname(__FILE__) + '/../data/data.csv'

    unless record_in_csv?(object.id)
      add_record_to_csv([object.id, opts[:brand], opts[:name], opts[:price]])
    end
    object
  end

  def self.all
    csv = CSV.read(@data_path).drop(1) # skip header
    csv.map { |r| new(id: r[0], brand: r[1], name: r[2], price: r[3]) }
  end

  # return an array of the first n records (or just the first)
  def self.first(n = 1)
    csv = CSV.read(@data_path).drop(1) # skip header
    records = csv.first(n).map do |r|
      new(id: r[0], brand: r[1], name: r[2], price: r[3])
    end
    n == 1 ? records[0] : records
  end

  # return an array of the last n records (or just the last)
  def self.last(n = 1)
    csv = CSV.read(@data_path).drop(1) # skip header
    records = csv.last(n).map do |r|
      new(id: r[0], brand: r[1], name: r[2], price: r[3])
    end
    n == 1 ? records[0] : records
  end

  # find record by id
  def self.find(id)
    csv = CSV.read(@data_path)
    record = csv.find { |r| id == r[0].to_i }
    new(id: record[0], brand: record[1], name: record[2], price: record[3])
  end

  # check if record exists (by id)
  def self.record_in_csv?(id)
    csv = CSV.read(@data_path)
    csv.find { |r| id == r[0].to_i }
  end

  def self.add_record_to_csv(record)
    CSV.open(@data_path, 'a') do |new_csv|
      new_csv << record
    end
  end
end
