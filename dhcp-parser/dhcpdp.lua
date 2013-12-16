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
	while 1==1 do
		self.offset=self.f:seek();
		line= self.f:read("*l")
		if line==nil then break end
		if line:match("^#")
		then
			print("comment:",line)
			goto nextlease
		end
		local ip=line:match("lease (%d+%.%d+%.%d+%.%d+) {")
		if ip ~= nil
		then
			local lease,mac,state={}
			lease.ip=ip
			while 1==1 do
				local mac,state
				line=self.f:read("*l")
				if line==nil then print "EOF" break end
				if line:match("^}$") ~= nil then break end
				mac=line:match("^  hardware ethernet ([a-z0-9:]+);")
				if mac
				then
					lease.mac=mac
					goto nextleaseline
				end
				state=line:match("^  binding state ([a-z]+);")
				if state
				then
					lease.state=state
					goto nextleaseline
				end
				::nextleaseline::
			end
			if lease.ip and lease.mac and lease.state
			then
				local byip,bymac
				byip=self:lookupbyip(lease.ip)
				bymac=self:lookupbymac(lease.mac)
				if byip and bymac and byip == bymac
				then
					print "Updating existing lease"
					if byip.state ~= lease.state
					then
						if lease.state=="active"
						then
							-- perform callbacks here
							print("starting lease:",lease.ip,lease.mac,lease.state)
						else
							-- perform callbacks here
							print("ending lease:",lease.ip,lease.mac,lease.state)
						end
					end
				elseif byip == nil and bymac == nil
				then
					if lease.state=="active"
					then
						-- perform callbacks here
						print("starting lease:",lease.ip,lease.mac,lease.state)
					end
				elseif bymac and bymac.state=="active"
				then
					-- We should bail out. Not supported
					print "Weird: mac got other ip"
					print("lease:",lease.ip,lease.mac,lease.state)
					print("bymac:",bymac.ip,bymac.mac,bymac.state)
				elseif byip and bymac==nil
				then
					print "IP handed out to other mac"
				end
				::leasecallbacksdone::
				self:updatelease(lease)
			end
		end
		::nextlease::
	end	
end

function m:lookupbyip(ip)
	return self.ip[ip]
end
function m:lookupbymac(mac)
	local ip=self.mac[mac]
	return ip and self.ip[ip]
end
function m:updatelease(lease)
	local ip=lease.ip
	if self.ip[ip]
	then
	else
		self.ip[ip]=lease
		self.mac[lease.mac]=ip
	end
end
function m:close()
	parser.offset=0
	return self.f:close()
end

return m
