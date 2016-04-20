module MenusHelper
  def last_present?
    Menu.last.present?
  end

  def last
    Menu.last
  end
end
