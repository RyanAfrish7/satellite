namespace Satellite { 
    public void render_percentage (Gtk.CellLayout layout, Gtk.CellRendererText renderer, Gtk.TreeModel model, Gtk.TreeIter iter, int column) {
        Value data;
        model.get_value (iter, column, out data);

        renderer.text = "%.1f".printf (data.get_double ());
    }

    private string format_bytes (uint64 size) {
        if (size < 9e2)
            return _(uint64.FORMAT + " B").printf (size);
        else if (size < 9e5)
            return _("%.1f KB").printf (size / 1e3);
        else if (size < 9e8)
            return _("%.1f MB").printf (size / 1e6);
        else if (size < 9e11)
            return _("%.1f GB").printf (size / 1e9);
        else
            return _("%.1f TB").printf (size / 1e12);
    }

    public void render_bytes (Gtk.CellLayout layout, Gtk.CellRendererText renderer, Gtk.TreeModel model, Gtk.TreeIter iter, int column) {
        Value data;
        model.get_value (iter, column, out data);

        uint64 memory_used_in_bytes = data.get_uint64 ();
        renderer.text = format_bytes (memory_used_in_bytes);
    }

    public Gtk.CellRendererText text_column_renderer () {
        var renderer = new Gtk.CellRendererText();
        renderer.ellipsize = Pango.EllipsizeMode.END;

        return renderer;
    }

    public Gtk.CellRendererText numeric_column_renderer () {
        var renderer = new Gtk.CellRendererText();
        renderer.ellipsize = Pango.EllipsizeMode.END;
        renderer.xalign = 1;

        return renderer;
    }

    public bool contains_func (Gtk.TreeModel model, int column, string key, Gtk.TreeIter iter) {
        Value data;

        model.get_value (iter, column, out data);
        return !data.get_string ().contains (key);
    }
}
