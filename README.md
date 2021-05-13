# y-sh
> 主要是用来在git的hook中增加一些限制，1.提交commit的时候，带上当前的分支名称。2.在历史commit中存在一些分支的merge记录就禁止push


# Usage
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Y-WMS-FE/y-sh/main/init.sh)"`

## 前端应用中
在`package.json`文件的`scripts`里增加`"preinstall": "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Y-WMS-FE/y-sh/main/init.sh)\"",`


这样在install依赖的时候就会注入到git的hooks
