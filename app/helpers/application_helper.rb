module ApplicationHelper

def print_multiline(field)
  field.gsub("\r\n","<br/>").html_safe
end
	
end
