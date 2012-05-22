module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "PrincetonFML"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def is_admin?
    session[:admin]
  end

  def admin_names
    Set.new ['The Giant Peach', 'A Boy Named James']
  end
end
