require_relative 'find_by'
require_relative 'errors'
require 'csv'

# TODO: Introduce error checking
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
    # TODO: Use create object
    csv.map { |r| new(id: r[0], brand: r[1], name: r[2], price: r[3]) }
  end

  # return an array of the first n records (or just the first)
  def self.first(n = 1)
    csv = CSV.read(@data_path).drop(1) # skip header
    records = csv.first(n).map do |r|
    # TODO: Use create object
      new(id: r[0], brand: r[1], name: r[2], price: r[3])
    end
    n == 1 ? records[0] : records
  end

  # return an array of the last n records (or just the last)
  def self.last(n = 1)
    csv = CSV.read(@data_path).drop(1) # skip header
    records = csv.last(n).map do |r|
    # TODO: Use create object
      new(id: r[0], brand: r[1], name: r[2], price: r[3])
    end

    n == 1 ? records[0] : records
  end

  # find record by id
  def self.find(id)
    csv = CSV.read(@data_path)
    record = csv.find { |r| id == r[0].to_i }

    unless record
      fail ToyCityErrors::ProductNotFoundError, "Product :#{id} does not exist"
    end

    # TODO: Use create object
    new(id: record[0], brand: record[1], name: record[2], price: record[3])
  end

  # remove the record matching the provied key
  def self.destroy(id)
    record = self.find(id)  # save record for returning

    # read all records excluding the one to be deleted
    csv = CSV.read(@data_path)
    records = csv.select { |r| id != r[0].to_i }
    # save data to CSV
    CSV.open(@data_path, 'w') do |file|
      records.each { |r| file << r }
    end

    record # return deleted record
  end

  # find first record by brand
  def self.find_by_brand(brand)
    csv = CSV.read(@data_path)
    record = csv.find { |r| brand == r[1] }

    unless record
      fail ToyCityErrors::ProductNotFoundError, "Brand :#{brand} does not exist"
    end

    create_object_from_array(record)
  end

  # helper methods
  # check if record exists (by id)
  def self.record_in_csv?(id)
    csv = CSV.read(@data_path)
    csv.find { |r| id == r[0].to_i }
  end

  def self.add_record_to_csv(record)
    CSV.open(@data_path, 'a') do |csv|
      csv << record
    end
  end

  def self.create_object_from_array(record)
    new(id: record[0], brand: record[1], name: record[2], price: record[3])
  end
end
