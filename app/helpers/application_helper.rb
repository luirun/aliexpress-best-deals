module ApplicationHelper

	def random_colors #used to generate lines with random colors on homepage
		colors = ["#f1c40f","#16a085","#e74c3c","#8e44ad","#34495e","#87D37C","#F89406","#F62459","#03C9A9"]
		return colors[rand(0..colors.length-1)]
	end

	def pretty_url_encode(url)
		first_url = url
		for i in 0..url.length-1
			if url[i] == "-"
				url[i] = "^%"
			end

			if url[i] == " "
				url[i] = "-"
			end

			if url[i] == "."
				url[i] = "%^"
			end
		end
		return url
	end

	def pretty_url_decode(url)
		for i in 0..url.length-1
			if url[i] == "-"
				url[i] = " "
			end

			if url[i] == "^" && url[i+1] == "%"
				url[i] = "-"
				if i+1 < url.length
					url[i+1] = ""
				end
			end

			if url[i] == "%" && url[i+1] == "^"
				url[i] = "."
				if i+1 < url.length
					url[i+1] = ""
				end
			end
		end
		return url
	end

	def print_multiline(field)
	  field.gsub("\r\n","<br/>").html_safe
	end

	def is_admin
		if current_user == nil
				flash[:notice] = "You must login to access this page!"
				session[:return_to] = request.fullpath
				redirect_to login_path
		else
			if current_user.is_admin != "y"
				flash[:notice] = "You must be an admin to access this page!"
				redirect_to root_path
			else
				flash[:notice] = "Have luck admin!"
			end
		end
	end

end
