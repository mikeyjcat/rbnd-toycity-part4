module Analyzable
  def average_price(objects)
    (objects.map { |o| o.price.to_f }.inject(&:+) / objects.size).round(2)
  end

  def count_by_brand(objects)
    results = {}
    objects.each do |o|
      if results[o.brand]
        results[o.brand] = results[o.brand] + 1
      else
        results[o.brand] = 1
      end
    end
    results
  end

  def count_by_name(objects)
    results = {}
    objects.each do |o|
      if results[o.name]
        results[o.name] = results[o.name] + 1
      else
        results[o.name] = 1
      end
    end
    results
  end
end
