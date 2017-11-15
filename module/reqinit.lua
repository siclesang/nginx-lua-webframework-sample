#!/usr/bin/env lua


local _M = {}

function _M.getargs()
	return ngx.req.get_uri_args()
end

function _M.getarg(key1,key2)
	local v1=nil
	local v2=nil
	 local args = ngx.req.get_uri_args()
         for key, val in pairs(args) do
             if type(val) == "table" then
                 --ngx.say(key, ": ", table.concat(val, ", "))
             else
                 --ngx.say(key, ": ", val,"<br>")
		if key == key1 then
			v1=val	
		end 
		if key == key2 then
			v2=val	
		end 
             end
         end


	return v1,v2
end

return _M
