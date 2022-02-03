<div align='center'>

  # K-mail

  <img src="https://img.shields.io/badge/license-GPL3.0-blue">
  <img src="https://img.shields.io/badge/DarkRP-2.7.0-lightgreen">
  <img src="https://img.shields.io/badge/ulib-2.63-orange">
  <img src="https://img.shields.io/badge/ulx-3.73-red">

  A Server Compansate System for DarkRP.

</div>

中文     [English](https://github.com/ninthseason/gmod-Kmail/edit/main/README.md)

---

### 前言

之所以开发这个插件，是因为我所玩的 DarkRP 服务器时常维护。导致玩家不得不损失其所在工作的进度。

利用该插件，我们可以在维护后对于全服适当补偿。



### 实现

这是一个类邮箱系统，灵感来源自一些网游以邮件形式发送奖励。

其通过两张表维护插件的数据：

- 邮件表 - 维护每个补偿条目（补偿标题，补偿正文，补偿金额，处理人）。
- 玩家表 - 维护每个玩家已领取的补偿

逻辑大致如下：

1. 管理员通过**发送补偿**向**邮件表**写入补偿条目
2. 玩家读取**邮件表**数据以获得所有补偿条目
3. 玩家读取**玩家表**数据以获得自己已领取过的补偿条目（用于显示“已领取”）
4. 玩家通过**领取补偿**向服务器发送领取请求
5. 服务器验证该请求是否合法
6. 验证成功则给予补偿，并在**玩家表**中进行标记



### 使用方法

#### 前置

本插件为 DarkRP 模式开发。

本插件基于 ULX 及其依赖库 ULib。

#### 安装

- 从创意工坊安装：

- 直接下载安装。（不多赘述）

#### 指南

聊天框输入`!menu`打开 ulx 菜单，找到 "服务器补偿系统" tab。

按界面上的字面意思操作即可。

> 注：只有 superadmin 可以发布补偿