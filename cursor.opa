type Cursor.callback('a) = {
	('a, int -> void) added,
	('a, int, int -> void) moved,
	('a, int -> void) changed,
	('a, int -> void) removed
}

type Cursor.t('a) = {
	(Cursor.callback('a) -> void) observe,
}

client module MakeCursor() {

	new_id = Fresh.client(identity)

    cb_map = Mutable.make(IntMap.empty)

	function observe(cb) {
		cb_map.set(Map.add(new_id(), cb, cb_map.get()))
	}

	function cb(f) {
		Map.iter({ function(_,cb) f(cb) }, cb_map.get())
	}

	function added(v, index) {
		cb(_.added(v, index))
	}

	function moved(v, from, to) {
		cb(_.moved(v, from, to))
	}

	function changed(v, index) {
		cb(_.changed(v, index))
	}

	function removed(v, index) {
		cb(_.removed(v, index))
	}
}

