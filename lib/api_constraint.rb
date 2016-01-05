class ApiConstraint

  def initialize(vendor, version: "1", default: false)
    @vendor = vendor
    @version, @default = version, default
  end

  def module
  	return "v#{@version}"
  end

  def matches?(request)
   return @default unless request.headers.key?('Accept')
   return request.headers['Accept'].include?("application/vnd.#{@vendor}-v#{@version}+")
  end
end
