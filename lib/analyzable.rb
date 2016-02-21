module Analyzable
  def average_price(objects)
    (objects.map { |o| o.price.to_f }.inject(&:+) / objects.size).round(2)
  end

  def count_by_brand(objects)
    { objects.first.brand => objects.size }
  end

  def count_by_name(objects)
    { objects.first.name => objects.size }
  end
end
