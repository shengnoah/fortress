# MoonScript for GrayLog
GrayLog REST API Wrapper for Moonscript


此程序是Graylog REST对外提供的API的一个Moonscript的Wrapper封装，把REST接口提供的数据服务，变成通过函数调用的方式取得相应REST接口返回的数据。


下面是一个实际的基于Lapis框架程序中调用此SDK的例子：

```lua
class App extends lapis.Application
  "/testcase": =>
    --准备对应REST的输入参数，如果相应该有的项目没有设定会输出NG原因。
    param_data= {
        fields:'username',
        limit:3,
        query:'*',
        from: '2017-01-05 00:00:00',
        to:'2017-01-06 00:00:00',
        filter:'streams'..':'..'673b1666ca624a6231a460fa'
    }
    --进行鉴权信息设定
    url  = GMoonSDK\author 'supervisor', 'password', '127.0.0.1', '12600'
    
    --调用对应'TYPE'相对应的REST服务，返回结果。
    ret = GMoonSDK\dealStream 's_ua', param_data
    ret
```    
