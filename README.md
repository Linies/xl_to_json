## xl_to_json

将xlsx文件内容转为json文件格式输出

1. xlmap.yaml文件声明描述

* *input：输入文档所在路径（根目录起始）
* *output：输出路径
* *index：输出键值具体key
* sheet：可指定文档对应表（否则以默认首页）
* ignores：忽略生成的项

2. 生成规则描述
   1. xlsx文件中首column为标识定义，供配置文件定位查找，且生成对应首column字段的文件
   2. rows中必须要指定有为index索引项的row，以这行row作为键值
   3. 键值对应column的其他值

```yaml
targets:
  - input: '文档.xlsx'
    output: 'res/json'
    index: '索引<key>'
    sheet: 'Sheet2'
    ignores:
      - '序号<index>'
      - '模块<module>'
      - '备注'
```
