require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  create_finder_methods('brand', 'name')

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
    @data_path = File.dirname(__FILE__) + '/../data/data.csv'

    csv = CSV.read(@data_path).drop(1) # skip header
    # puts "i am here #{csv}"
    csv.map { |r| create_object_from_array(r) }
  end

  # return an array of the first n records (or just the first)
  def self.first(n = 1)
    csv = CSV.read(@data_path).drop(1) # skip header
    records = csv.first(n).map { |r| create_object_from_array(r) }
    n == 1 ? records[0] : records
  end

  # return an array of the last n records (or just the last)
  def self.last(n = 1)
    csv = CSV.read(@data_path).drop(1) # skip header
    records = csv.last(n).map { |r| create_object_from_array(r) }

    n == 1 ? records[0] : records
  end

  # return an array of records that match the supplied criteria
  # parameters = hash with field to find by, and value to match
  def self.where(opts = nil)
    csv = CSV.read(@data_path).drop(1) # skip header
    records = csv.map { |r| create_object_from_array(r) }
    records.select { |r| r.send(opts.to_a[0][0]) == opts.to_a[0][1] }
  end

  # find record by id
  def self.find(id)
    csv = CSV.read(@data_path)
    record = csv.find { |r| id == r[0].to_i }

    unless record
      fail ToyCityErrors::ProductNotFoundError, "Product :#{id} does not exist"
    end

    create_object_from_array(record)
  end

  def update(opts = nil)
    record = { id: id, brand: brand, name: name, price: price }
    opts.each_pair { |k, v| record[k] = v } # update hash with supplied data
    array = record.to_a.map { |p| p[1] } # convert hash to array

    self.class.destroy(id) # remove existing record
    self.class.add_record_to_csv(array) # add updated record
    self.class.create_object_from_array(array) # return updated object
  end

  # remove the record matching the provied key
  def self.destroy(id)
    record = find(id) # save record for returning

    # read all records excluding the one to be deleted
    csv = CSV.read(@data_path)
    records = csv.select { |r| id != r[0].to_i }
    # save data to CSV
    CSV.open(@data_path, 'w') do |file|
      records.each { |r| file << r }
    end

    record # return deleted record
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
