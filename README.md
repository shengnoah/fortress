# MoonScript for Graylog
GrayLog REST API Wrapper for Moonscript


此程序是Graylog REST对外提供的API的一个Moonscript的Wrapper封装，把REST接口提供的数据服务，变成通过函数调用的方式取得相应REST接口返回数据。


下面是一个实际的基于Lapis框架程序中调用此SD的K例子：

```lua
class App extends lapis.Application
  "/testcase": =>
    param_data= {
        fields:'username',
        limit:3,
        query:'*',
        from: '2017-01-05 00:00:00',
        to:'2017-01-06 00:00:00',
        filter:'streams'..':'..'673b1666ca624a6231a460fa'
    }

    url  = GMoonSDK\author 'supervisor', 'password', '127.0.0.1', '12600'
    ret = GMoonSDK\dealStream 's_ua', param_data
    ret
```    
