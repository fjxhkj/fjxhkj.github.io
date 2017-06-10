# SpeedPHP最新版手册源码

本项目源码基于 Markdown 文档,以 mkdocs 来渲染,样式经过特殊优化.
拟将在线渲染的静态网站置于 [readthedocs.io](http://speedphp-manual-org.readthedocs.io/)

## 参考

[mkdocs 官方网站](http://www.mkdocs.org/)

## 本地调试方法

推荐使用 virtualenv 虚拟一个 Python3 的环境.
然后安装 mkdocs:
```
{YOUR_ENV}\Script\activate
pip install mkdocs
```

### 运行调试渲染

```
mkdocs serve
```

默认本地调试URL:

```
http://localhost:8000
```

mkdocs 可监视文件夹,当你修改项目的任何文件时,都将自动刷新浏览器页面.

## 注意事项

- 尽量避免项目中存在中文目录名,否则无法使用py2进行调试,所以上面推荐使用py3环境.