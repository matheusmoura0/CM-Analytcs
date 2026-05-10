module ApplicationHelper
  def nav_class(action)
    current_page?(controller: 'dashboard', action: action) ? 'bg-red-800 px-3 py-2 rounded-md text-sm font-medium' : 'hover:bg-red-600 px-3 py-2 rounded-md text-sm font-medium'
  end
  
  def format_number(number)
    number_with_delimiter(number.to_i, delimiter: '.')
  end
  
  def format_percent(value)
    number_to_percentage(value, precision: 1)
  end
  
  def format_currency(value)
    number_to_currency(value, unit: '€', precision: 0)
  end
end
