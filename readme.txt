一个基于 nginx+lua 的 简单lua web 框架

只是练习,以备后查


说明
1.框架的路由 有nginx 配置实现
2.框架提供模板功能
3.一个简单的例子




----nginx config example-------
--- mime.types 添加text/html html htm shtml lua vv; 支持 .lua .vv 扩展名，可自定义

    location / {
        try_files $uri  /index.lua;
        content_by_lua_file $document_root$uri;
                }
    location ~ (.js|.css|.html|.jpg)$ {
        root /home/webuser/www/views/static;
        expires 30d;
        }



----主要目录------------------

.
├── content
│   ├── articles
│   │   └── test
│   │       └── aa
│   └── index
├── data
├── module          #模块目录
│   ├── articles.lua
│   ├── config.lua    #配置模块
│   ├── pageshow.lua  #页面显示相关模块
│   ├── reqinit.lua
│   ├── sitemap.lua
│   └── template.lua  #模板分析模块
├── template         #模板目录
│   ├── articlesbody.html
│   ├── body.html
│   ├── footer.html
│   ├── header.html
│   ├── indexbody.html
│   ├── page.html
│   └── sitemap.html
└── views             #docmentroot 
    ├── articles.vv
    ├── index.lua
    └── static
        ├── css
        │   └── style.css
        ├── html
        ├── img
        │   ├── land.jpg
        │   └── willow.jpg
        └── js
            └── echarts.min.js
