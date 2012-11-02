/**
 * @register { -> Context.context }
 */
function get() {
    return Meteor.deps.Context.current;
}

/**
 * @register { Context.context -> int }
 */
function getId(context) {
    return context.id
}

/**
 * @register { Context.context, (-> void) -> void }
 */
function onInvalidate(context, callback) {
    context.onInvalidate(callback);
}

/**
 * @register { Context.context -> void }
 */
function invalidate(context) {
    context.invalidate();
}