module ApplicationHelper
    def current_class?(path)
    return "border-b-2 border-[#E93A7D]" if request.path == path
    ""
  end
end
