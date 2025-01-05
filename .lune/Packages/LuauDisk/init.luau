local setType = require("./set/type")

export type Set<T> = setType.Set<T>

local Disk = {
	Array = {
		all = require("./array/all");
		alternate = require("./array/alternate");
		any = require("./array/any");
		average = require("./array/average");
		averageBy = require("./array/averageBy");
		concat = require("./array/concat");
		contains = require("./array/contains");
		copy = require("./array/copy");
		deduplicate = require("./array/deduplicate");
		deduplicateByKey = require("./array/deduplicateByKey");
		filter = require("./array/filter");
		find = require("./array/find");
		findIndex = require("./array/findIndex");
		findIndexByValue = require("./array/findIndexByValue");
		findMap = require("./array/findMap");
		flatMap = require("./array/flatMap");
		flatten = require("./array/flatten");
		fromFn = require("./array/fromFn");
		fromTryFn = require("./array/fromTryFn");
		isArray = require("./array/isArray");
		isEmpty = require("./array/isEmpty");
		map = require("./array/map");
		maximum = require("./array/maximum");
		maximumBy = require("./array/maximumBy");
		minimum = require("./array/minimum");
		minimumBy = require("./array/minimumBy");
		partition = require("./array/partition");
		pop = require("./array/pop");
		popFirst = require("./array/popFirst");
		product = require("./array/product");
		productBy = require("./array/productBy");
		push = require("./array/push");
		range = require("./array/range");
		reduce = require("./array/reduce");
		removeIndexes = require("./array/removeIndexes");
		removeSortedIndexes = require("./array/removeSortedIndexes");
		removeValues = require("./array/removeValues");
		reverse = require("./array/reverse");
		reversed = require("./array/reverse");
		sort = require("./array/sort");
		sortByKey = require("./array/sortByKey");
		stepBy = require("./array/stepBy");
		sum = require("./array/sum");
		sumBy = require("./array/sumBy");
		takeWhile = require("./array/takeWhile");
		zip = require("./array/zip");
	};
	Map = {
		copy = require("./map/copy");
		count = require("./map/count");
		entries = require("./map/entries");
		invert = require("./map/invert");
		isEmpty = require("./map/isEmpty");
		keys = require("./map/keys");
		mapEntries = require("./map/mapEntries");
		mapValues = require("./map/mapValues");
		merge = require("./map/merge");
		remove = require("./map/remove");
		values = require("./map/values");
	};
	Set = {
		fromArray = require("./set/fromArray");
	};
	None = require("./None");
	WeakMap = require("./WeakMap");
}

return Disk
