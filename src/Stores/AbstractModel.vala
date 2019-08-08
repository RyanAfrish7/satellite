public class Satellite.AbstractModel<T> : Gtk.TreeStore {
    Gee.Map<T, Gtk.TreeIter?> iter_cache;

    public AbstractModel () {
        iter_cache = new Gee.HashMap<T, Gtk.TreeIter?> ();
    }

    public Gtk.TreeIter get_row_by_id (T id) {
        assert (iter_cache.has_key (id));

        return iter_cache.get (id);
    }

    public Gtk.TreeIter get_or_append_row (T id) {
        if (iter_cache.has_key (id)) {
            return get_row_by_id (id);
        } else {
            return append_row (id, null);
        }
    }

    public Gtk.TreeIter append_row (T id, Gtk.TreeIter? root) {
        assert (!iter_cache.has_key (id)); // check for duplicate row
        
        Gtk.TreeIter iter;
        append (out iter, root);
        
        iter_cache.set (id, iter);

        return iter;
    }

    public bool remove_by_id (T id) {
        assert (iter_cache.has_key (id));

        Gtk.TreeIter iter;
        iter_cache.unset (id, out iter);
        return remove (ref iter);
    }

    public void retain_by_ids (Gee.Set<T> ids) {
        Gee.Set<T> ids_to_remove = new Gee.HashSet<int> ();

        ids_to_remove.add_all( iter_cache.keys );
        ids_to_remove.remove_all (ids);

        foreach (T id in ids_to_remove) {
            remove_by_id (id);
        }
    }
}
