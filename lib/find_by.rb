class Module
 INDICES = { 'brand' =>  1, 'name' => 2 }.freeze

  def create_finder_methods(*attributes)
    attributes.each do |attribute|
      # create text to define method
      new_method = %{
        def self.find_by_#{attribute}(key)
          csv = CSV.read(@data_path)

          index = INDICES["#{attribute}"].to_i

          record = csv.find { |r| key == r[index] }

          unless record
            fail ToyCityErrors::ProductNotFoundError,
                 "#{attribute} : key does not exist"
          end

          create_object_from_array(record)
        end
        }
        puts new_method

      # Pass variable into class_eval as an argument
      self.class_eval(new_method)
    end
  end
end
