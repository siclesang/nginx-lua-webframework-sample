#!/usr/bin/env lua


sitemap=require "sitemap"
config=require "config"


local _M = {}


 _M.map1="articles"

 _M.content_root_dir=config.content_root_dir

 _M.auth=nil


function _M.setauth(auth)
	_M.auth=auth
end

function _M.getcustomauth()
	ngx.print(_M.auth)
end

-- \n ==> <br>
function _M.nl2br(input)
    input = string.gsub(input, "\t", "&nbsp&nbsp&nbsp&nbsp")
    return string.gsub(input, "\n", "<br />")
end

--获得作者目录列表
function _M.getauth()
	return sitemap.children(_M.content_root_dir.._M.map1)
end


--获得作者目录下文章列表
function  _M.gettitles(dir)
	--ngx.print(dir)
	--ngx.print(_M.content_root_dir.._M.map1.."/".._M.auth)
	--return sitemap.children(_M.content_root_dir.._M.map1.."/".._M.auth)
	return sitemap.children(dir)
end

--获取指定作者文章列表
function  _M.getAuthTitles(zuozhe)
	--ngx.print(dir)
	local authhome=_M.content_root_dir.._M.map1.."/"..zuozhe
	--return sitemap.children(_M.content_root_dir.._M.map1.."/".._M.auth)
	if lfs.attributes(authhome,"mode") == "directory" then
		return sitemap.children(authhome)
	else
		ngx.log(ngx.ERR,authhome.." is not exists")
		ngx.exit(403)
	end
end

--获得指定作者指定文章名的文章内容
function _M.getAuthTitleContent(zuozhe,title)
	local article=_M.content_root_dir.._M.map1.."/"..zuozhe.."/"..title
	if lfs.attributes(article,"mode") == "file" then
		local file=io.open(article,"r")
		local content=file:read("*a")
		return _M.nl2br(content)
	else
		ngx.log(ngx.ERR,article.." is not exists")
		ngx.exit(403)
	end
end


return _M
