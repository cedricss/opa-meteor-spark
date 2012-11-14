type Cursor.callback('a) = {
	('a, int -> void) added,
	('a, int, int -> void) moved,
	('a, int -> void) changed,
	('a, int -> void) removed
}

type Cursor.t('a) = {
	(Cursor.callback('a) -> void) observe,
}

type v = { string _id, string value }

client module Cursor {

    Mutable.t(Cursor.callback(v)) callback =
    	Mutable.make(@unsafe_cast(void))

	function observe(cb) {
		callback.set(cb)
	}

	function getCallback() {
		callback.get()
	}

}


Cursor.t('a) cursor = { observe : Cursor.observe }