-- TODO 可以给对象一个唯一识别符
-- TODO 支持继承

function __ELog(msg,...)
	print(string.format(msg,...))
	error(string.format(msg,...))
end
function __WLog(msg,...)
	print(string.format(msg,...))
end

function class(name)
	-- 类型要有名字
	if type(name) ~= "string" then
		__ELog("invalid class name {%s}!",tostring(name))
		return
	end
	-- 类名不能重复
	if rawget(_G,name) then
		__ELog("dulplicated class name {%s}!!",name)
		return
	end

	local class_obj = {__reg = {},__name = name} -- __reg 变量注册用，__name 类名
	rawset(_G,name,class_obj) -- 注册名为 name 的全局变量作为代表类的表
	
	class_obj.__index = function (tbl,k) -- 只是访问就不用检查了
		return  rawget(class_obj,k)
	end

	class_obj.__newindex = function (tbl,k,v)
		if not class_obj.__reg[k]  and type(v) ~= "function" then -- 如果赋值的是一个函数，就允了
			__ELog("class member not defined !! class:{%s},member:{%s}",class_obj.__name,tostring(k))
			return
		end		
		rawset(tbl,k,v)-- 这个可能是对象在调用，所以用 tbl		
	end

	class_obj.__call = function(tbl,...) -- 支持连续定义多个变量
		local args = {...}
		for i,memberName in ipairs(args) do
			-- 必须是字符串
			if type(memberName) ~= "string" then
				__ELog("member should be string type!! class:{%s},member:{%s}",class_obj.__name,tostring(memberName))
				return
			end
			-- 重复定义给个提示
			if class_obj.__reg[memberName] then
				__WLog("dulplicated memberName {%s} in class {%s} !!",memberName,class_obj.__name)
			end

			class_obj.__reg[memberName] = true
		end
	end

	-- 提供类名
	class_obj.GetType = function ()
		return class_obj.__name
	end


	-- 创建对象
	class_obj.new = function(_,...)
		--------------------------------------------------
		-- 定义对象 start
		--------------------------------------------------
		local obj = {}
		obj.__class = class_obj

		if class_obj.Ctor then
			class_obj.Ctor(obj,...)
		end

		setmetatable(obj,class_obj) -- TODO 对象的权限跟类的权限应当是不同的
		return obj
		--------------------------------------------------
		--定义对象 end
		--------------------------------------------------
	end

	setmetatable(class_obj,class_obj) -- 设置元表要最后设，让访问控制在最后生效

	return class_obj
end


-- test
class("CFruit") -- 创建一个全局类 CFruit
CFruit("m_Name") -- 定义类变量
CFruit("m_Size")
CFruit("m_Color")
-- CFruit.m_Name = "Fruit"
function CFruit:Ctor(name)
	self.m_Name = name
end

function CFruit:Move(x,y)
	print("moveto",x,y)
end

peach = CFruit:new("peach")
print(peach.m_Name)

peach.m_Name = "hello"
print(peach.m_Name,peach:GetType())

peach:Move(1,2) -- 调用类函数

-- peach.m_Name1 = "good" -- 会报错


apple = CFruit:new("apple")
print(apple.m_Name)
