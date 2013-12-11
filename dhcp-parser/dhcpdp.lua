local m={}

--[[
use:
create a dhcp parser struct
poll -> check leases file for changes
lookups -> query current structs
close -> stop it.
]]
function m.new(filename)
	local parser={}
	parser.filename=filename
	parser.ip={} -- ip -> lease
	parser.mac={} -- mac -> ip
	setmetatable(parser,{ __index=m })
	local err
	parser.f, err=io.open(filename,"rb")
	parser.offset=0
	if parser.f ~= nil then
		return parser
	else
		return nil,err
	end
		
end
function m:poll()
	self.f:seek("set",self.offset);
	local ip
	local line
	repeat
		line= self.f:read("*l")		
		if line:match("#")
		then
			print"comment"
		else
		ip=line:match("lease (%d+%.%d+%.%d+%.%d+) {")
		if ip ~= nil
		then
			print(ip)
		end
		end
	until
		line == nil

end
function m:lookupbyip(ip)
end
function m:lookupbymac(mac)
end
function m:close()
	parser.offset=0
	return self.f:close()
end

return m
