--!optimize 2
--!strict

local GreenTea = require("@packages/GreenTea")
local LuauPolyfill = require("@packages/LuauPolyfill")

local Error = LuauPolyfill.Error

type Node<K, V> = {
	Key: K,
	Next: Node<K, V>?,
	Previous: Node<K, V>?,
	Value: V,
}

export type LRUCache<K, V> = typeof(setmetatable(
	{} :: {
		Capacity: number,
		Size: number,

		Clear: (self: LRUCache<K, V>) -> (),
		Get: (self: LRUCache<K, V>, key: K) -> V?,
		Set: (self: LRUCache<K, V>, key: K, value: V) -> (),
	},
	{} :: {
		__len: (self: LRUCache<K, V>) -> number,
		__tostring: (self: LRUCache<K, V>) -> string,
	}
))
type Private<K, V> = typeof(setmetatable(
	{} :: {
		Capacity: number,
		Size: number,

		Clear: (self: Private<K, V>) -> (),
		Get: (self: Private<K, V>, key: K) -> V?,
		Set: (self: Private<K, V>, key: K, value: V) -> (),

		Head: Node<K, V>,
		NodesMap: {[K]: Node<K, V>},
		Tail: Node<K, V>,
	},
	{} :: {
		__len: (self: Private<K, V>) -> number,
		__tostring: (self: Private<K, V>) -> string,
	}
))

type Static = {
	ClassName: "LRUCache",
	new: <K, V>(capacity: number) -> LRUCache<K, V>,
	Is: (value: any) -> boolean,
	instanceof: (value: any) -> boolean,
}
type PrivateStatic = Static & {
	__len: (self: Private<any, any>) -> number,
	__tostring: (self: Private<any, any>) -> string,
}

--[=[
	The `LRUCache` (Least Recently Used Cache) class implements a fixed-size
	cache that stores key-value pairs. It uses the Least Recently Used eviction
	policy to manage the cache content when the capacity is exceeded. This
	means that when the cache reaches its capacity, it will remove the least
	recently accessed item to make room for new entries.

	### Features:

	- **Fast Retrieval:** Quickly access cached items using the `Get` method.
	- **Automatic Eviction:** Automatically evicts the least recently used item
	  when adding new entries beyond capacity.
	- **Mutable Size:** Check the current number of items with `Size`.
	- **Capacity Limit:** Set a maximum capacity to control memory usage.
	- **Supports Debug Mode:** You can set `_G.__DEV__` to `true` to enable
	  debug mode. This has to be done BEFORE requiring the module.
	- **Supports `__len`:** Use the length operator `#` to get the cache size.
	- **Supports `__tostring`:** You can call `tostring` on the cache.

	### Example Usage:

	```lua
	_G.__DEV__ = RunService:IsStudio()
	local DataStructures = require("DataStructures")

	-- Create a new cache with a capacity of 2
	local lruCache = DataStructures.LRUCache.new(2)

	-- Add some key-value pairs
	lruCache:Set("apple", "red")
	lruCache:Set("banana", "yellow")

	print(lruCache:Get("apple")) -- Output: "red"
	print(lruCache:Get("banana")) -- Output: "yellow"

	-- Add another item, exceeding the capacity
	lruCache:Set("cherry", "red")

	-- Since "apple" was least recently used, it gets evicted
	print(lruCache:Get("apple")) -- Output: nil
	print(lruCache:Get("cherry")) -- Output: "red"

	-- Check the size of the cache
	print(#lruCache, lruCache.Size) -- Output: 2, 2

	-- Clear the cache
	lruCache:Clear()
	print(#lruCache, lruCache.Size) -- Output: 0, 0
	```

	### Methods:

	- **`LRUCache.new(capacity: number): LRUCache`**
		- Creates a new `LRUCache` instance with the specified capacity.
		- **Parameters:**
			- `capacity` (number): The maximum number of items the cache can
			  hold.
		- **Returns:** A new `LRUCache` object.

	- **`LRUCache:Get(key: K): V?`**
		- Retrieves the value associated with the given key.
		- Marks the key as recently used.
		- **Parameters:**
			- `key` (K): The key to look up.
		- **Returns:** The value associated with the key, or `nil` if not found.

	- **`LRUCache:Set(key: K, value: V): ()`**
		- Adds or updates a key-value pair in the cache.
		- If the key already exists, its value is updated, and it is marked as
		  recently used.
		- If adding the new key exceeds the capacity, the least recently used
		  item is evicted.
		- **Parameters:**
			- `key` (K): The key to insert or update.
			- `value` (V): The value to associate with the key.

	- **`LRUCache:Clear(): ()`**
		- Removes all items from the cache.

	### Properties:
	- **`LRUCache.Capacity: number`** (read-only)
		- The maximum number of items the cache can hold.

	- **`LRUCache.Size: number`**
		- The current number of items in the cache.

	### Tags:

	- `Supports Debug Mode`: You can set `_G.__DEV__` to `true` to enable
	  debug mode. This has to be done BEFORE requiring the module.
	- `Supports __len`: You can use the `#` operator to get the current size
	  of the cache.
	- `Supports __tostring`: You can call `tostring` on the cache.

	@tag Supports Debug Mode
	@tag Supports __len
	@tag Supports __tostring
	@class LRUCache
]=]
local LRUCache = {} :: LRUCache<any, any> & Static
local Private = LRUCache :: Private<any, any> & PrivateStatic
LRUCache.ClassName = "LRUCache";
(LRUCache :: any).__index = LRUCache

--[=[
	The maximum number of items the cache can hold.
	@prop Capacity integer
	@readonly
	@within LRUCache
]=]
--[=[
	The current number of items in the cache.
	@prop Size integer
	@readonly
	@within LRUCache
]=]

local cached: boolean = nil
local function IsUltraStrictMode(): boolean
	if cached ~= nil then
		return cached
	end

	local isUltraStrictMode = not not _G.__DEV__
	cached = isUltraStrictMode
	return isUltraStrictMode
end
local IsValidCapacity = GreenTea.build(GreenTea.number({integer = true, range = "(0, ]"}))
local IsUnknown = GreenTea.build(GreenTea.unknown())

--[=[
	Creates a new LRU cache.

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@param capacity number -- The maximum number of items the cache can hold.
	@return LRUCache<K, V>
]=]
function LRUCache.new<K, V>(capacity: number): LRUCache<K, V>
	if IsUltraStrictMode() then
		local typeSuccess, typeError = IsValidCapacity:matches(capacity)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, LRUCache.new)
			error(exception)
		end
	end

	local self: Private<K, V> = setmetatable({}, LRUCache) :: never
	self.Capacity = capacity
	self.Size = 0

	self.Head = {} :: Node<K, V>
	self.NodesMap = {}
	self.Tail = {} :: Node<K, V>

	return self
end

--[=[
	Checks if `value` is literally an LRUCache.

	```lua
	LRUCache.Is(LRUCache.new(10)) -- true
	LRUCache.Is(LRUCache) -- false
	LRUCache.Is({}) -- false
	LRUCache.Is(nil) -- false
	LRUCache.Is(1) -- false
	```

	@param value unknown
	@return boolean
]=]
function LRUCache.Is(value: any)
	return type(value) == "table" and getmetatable(value) == LRUCache
end
--[=[
	An alias for [LRUCache.Is].

	@function instanceof
	@within LRUCache

	@param value unknown
	@return boolean
]=]
LRUCache.instanceof = LRUCache.Is

local function Evict<K, V>(self: Private<K, V>, node: Node<K, V>)
	local nodesMap = self.NodesMap
	local key = node.Key
	if nodesMap[key] == nil then
		return
	end

	nodesMap[key] = nil
	self.Size -= 1

	local previousNode = node.Previous :: Node<K, V>
	local nextNode = node.Next :: Node<K, V>

	local head = self.Head
	local tail = self.Tail

	if previousNode == head and nextNode == tail then
		head.Next = nil
		tail.Previous = nil
		self.Size = 0
		return
	end

	if previousNode == head then
		nextNode.Previous = head
		head.Next = nextNode
		return
	end

	if nextNode == tail then
		previousNode.Next = tail
		tail.Previous = previousNode
		return
	end

	previousNode.Next = nextNode
	nextNode.Previous = previousNode
end
local function Append<K, V>(self: Private<K, V>, node: Node<K, V>)
	self.NodesMap[node.Key] = node

	local head = self.Head
	local tail = self.Tail

	if head.Next then
		local tailPrevious = tail.Previous :: Node<K, V>
		tailPrevious.Next = node
		node.Previous = tailPrevious
		node.Next = tail
		tail.Previous = node
	else
		head.Next = node
		tail.Previous = node
		node.Previous = head
		node.Next = tail
	end

	local size = self.Size + 1
	self.Size = size
	if size > self.Capacity then
		Evict(self, head.Next :: Node<K, V>)
	end
end

--[=[
	Gets the value associated with the given key.

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@method Get
	@within LRUCache

	@param key K -- The key to get the value for.
	@return V?
]=]
function Private:Get(key)
	if IsUltraStrictMode() then
		local typeSuccess, typeError = IsUnknown:matches(key)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, LRUCache.Get)
			error(exception)
		end
	end

	local node = self.NodesMap[key]
	if not node then
		return nil
	end

	Evict(self, node)
	Append(self, node)
	return node.Value
end

--[=[
	Sets the value to the given key.

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@method Set
	@within LRUCache

	@param key K -- The key to set the value to.
	@param value V -- The value to set.
]=]
function Private:Set<K, V>(key, value)
	if IsUltraStrictMode() then
		local typeSuccess0, typeError0 = IsUnknown:matches(key)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, LRUCache.Set)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsUnknown:matches(value)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, LRUCache.Set)
			error(exception)
		end
	end

	local node = self.NodesMap[key]
	if node then
		node.Value = value
		Evict(self, node)
		Append(self, node)
	else
		Append(self, {Key = key, Value = value})
	end
end

--[=[
	Clears the cache.

	@method Clear
	@within LRUCache
]=]
function Private:Clear()
	table.clear(self.NodesMap)
	table.clear(self.Head)
	table.clear(self.Tail)
	self.Size = 0
end

function Private:__len()
	return self.Size
end
function Private:__tostring()
	return "LRUCache"
end

return table.freeze(LRUCache :: Static)
