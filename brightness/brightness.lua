#!/usr/bin/lua
local p=require"posix"
if p.getpid().euid > 0 then
	assert(p.exec("/usr/bin/sudo",arg[0],...))
else
	print("rooted!")
end
