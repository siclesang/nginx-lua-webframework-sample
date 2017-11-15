#!/usr/bin/env lua

local _M={}


_M.templatefile=nil
_M.vars={}


function _M.fileExist(filename)
	local io=require("io")
	local f,err=io.open (filename ,"r")
	--ngx.log(ngx.ERR,"err:" .. err)
	if err==nil then
		io.close(f)
		return filename,nil
	else
		ngx.log(ngx.ERR,filename.." is not exists")
		ngx.exit(403)
	end
end


--设置模板文件
function _M.setTemplateFile(filename)
	f,err=_M.fileExist(filename)
	if err==nil then
		_M.templatefile=filename
		return true
	else
		return false
	end
end


--设置模板传入参数kvtable,
--如果传入kvtable 中的元素还是table类型，将table转换成string,
--例如 {title="a test title",t={"a","b"}} => {title="a test title",t='{"a","b"}'}
function _M.setVars(kvtable)
	if type(kvtable)=="table" then
		for k,v in pairs(kvtable) do
			if type(v) == "table" then
				if next(v) == nil then
					kvtable[k]="{}"
				else
					kvtable[k]='{"'..table.concat(v,'","')..'"}'
				end

			end
		end
		_M.vars=kvtable
		return true
	else
		return false	
	end
end


function _M.stringPlace(string,stringmatch,stringplace)
	return string.gsub(string,stringmatch,stringplace)
end





--模板分析
--模板规则: 
--1.需要代入的变量<%= var %>  
--2.代码块<% block %> 注意<% 后有空格,代码块中需要带入的变量也用变量块<%= var %> 
--3.模板开头和结尾不能有变量或者代码块
--例如
--<html>
--<head>
--    <title><%= title %></title>
--    </head>
--    <body>
--    <% 
--    for k,pp in pairs(<%= t %>) do
--    	print( [[<p> ]]..pp..[[</p>]])
--    end
--    %>
--       </body>
-- </html>
--模板分析策略：
--1.开头加 print([[  结尾加 ]])
--2.将所有的变量块替换为对应的值
--3.将代码块的 "<% " => "]]) ",  "%%>" => " print([[" 
--4.模板传入table格式为{var_name=var_value,var_tablename=var_tablevalue}
function _M.templateParse()
	--ngx.print(_M.templatefile)
	local io=require 'io'
	local fi = io.open (_M.templatefile ,"r")
	text=fi:read("*a")
	text=" ngx.print([["..text.."]]) "
	if _M.vars == nil then
		return text
	end
	for k,v in pairs(_M.vars) do
		local sm="<%%= "..k.." %%>"
		text=_M.stringPlace(text,sm,v)
	end
	-- 没有传入参数的变量替换为空
	text=_M.stringPlace(text,"<%%=(.-)%%>","")
	text=_M.stringPlace(text,"<%% ","]]) ")
	text=_M.stringPlace(text,"%%>"," ngx.print([[")

	io.close(fi)
	return text
end


function _M.templateRun()
	text=_M.templateParse()
	--ngx.print(text) 
	f=assert(loadstring(text))
	if f == nil then
		ngx.print(text)
	else
		return	f()
	end

end


return _M

