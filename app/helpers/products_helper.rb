module ProductsHelper
  def select_progress_bar_class(index)
    case index
    when 1
      "progress-bar-danger"
    when 2
      "progress-bar-warning"
    when 3
      "progress-bar-info"
    when 4
      "progress-bar-primary"
    when 5
      "progress-bar-success"
    end
  end
end
