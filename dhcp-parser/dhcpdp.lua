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
	parser.f=assert(io.open(filename,"r"))
	parser.offset=0
	setmetatable(parser,m)
end
function m:poll()
	local co;
	self.f:seek("set",self.offset);
	
end
function m:lookupbyip(ip)
end
function m:lookupbymac(mac)
end
function m:close()
	parser.offset=0
	return self.f:close()
end
