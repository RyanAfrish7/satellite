public class Satellite.MemoryView : Gtk.TreeView {
    Gtk.TreeViewColumn column_pid;
    Gtk.TreeViewColumn column_command_line;
    Gtk.TreeViewColumn column_memory_usage;
    Gtk.TreeViewColumn column_memory_usage_in_percentage;
    Gtk.TreeViewColumn column_user;

    public MemoryView () {
        var text_renderer = new Gtk.CellRendererText();
        text_renderer.ellipsize = Pango.EllipsizeMode.END;

        column_command_line = new Gtk.TreeViewColumn ();
        column_command_line.title = get_column_name (MemoryViewModel.Column.COMMAND_LINE);
        column_command_line.expand = true;
        column_command_line.pack_start (text_renderer, false);
        column_command_line.add_attribute (text_renderer, "text", MemoryViewModel.Column.COMMAND_LINE);
        
        insert_column (column_command_line, -1);
        
        column_memory_usage = new Gtk.TreeViewColumn ();
        column_memory_usage.title = get_column_name (MemoryViewModel.Column.MEMORY_USAGE);
        column_memory_usage.expand = false;
        column_memory_usage.min_width = 120;
        column_memory_usage.sort_column_id = MemoryViewModel.Column.MEMORY_USAGE;
        column_memory_usage.pack_start (text_renderer, false);
        column_memory_usage.set_cell_data_func (text_renderer, (layout, renderer, model, iter) => 
        cell_bytes_data(layout, renderer, model, iter, MemoryViewModel.Column.MEMORY_USAGE));

        insert_column (column_memory_usage, -1);

        column_memory_usage_in_percentage = new Gtk.TreeViewColumn ();
        column_memory_usage_in_percentage.title = get_column_name (MemoryViewModel.Column.MEMORY_USAGE_IN_PERCENTAGE);
        column_memory_usage_in_percentage.expand = false;
        column_memory_usage_in_percentage.min_width = 120;
        column_memory_usage_in_percentage.sort_column_id = MemoryViewModel.Column.MEMORY_USAGE_IN_PERCENTAGE;
        column_memory_usage_in_percentage.pack_start (text_renderer, false);
        column_memory_usage_in_percentage.set_cell_data_func (text_renderer, (layout, renderer, model, iter) => 
        cell_percentage_data(layout, renderer, model, iter, MemoryViewModel.Column.MEMORY_USAGE_IN_PERCENTAGE));

        insert_column (column_memory_usage_in_percentage, -1);
        
        column_pid = new Gtk.TreeViewColumn ();
        column_pid.title = get_column_name (MemoryViewModel.Column.PID);
        column_pid.expand = false;
        column_pid.min_width = 120;
        column_pid.pack_start (text_renderer, false);
        column_pid.add_attribute (text_renderer, "text", MemoryViewModel.Column.PID);

        insert_column (column_pid, -1);
        
        column_user = new Gtk.TreeViewColumn ();
        column_user.title = get_column_name (MemoryViewModel.Column.USER);
        column_user.expand = true;
        column_user.pack_start (text_renderer, false);
        column_user.add_attribute (text_renderer, "text", MemoryViewModel.Column.USER);

        insert_column (column_user, -1);
    }

    public string get_column_name (MemoryViewModel.Column column) {
        switch (column) {
            case COMMAND_LINE: return "Command line";
            case MEMORY_USAGE: return "Memory used";
            case MEMORY_USAGE_IN_PERCENTAGE: return "% Memory";
            case PID: return "PID";
            case USER: return "User";
            case UID: return "UID";
            default: assert_not_reached();
        }
    }

    public void cell_bytes_data (Gtk.CellLayout layout, Gtk.CellRenderer renderer, Gtk.TreeModel model, Gtk.TreeIter iter, MemoryViewModel.Column column) {
        Value data;
        model.get_value (iter, column, out data);
        uint64 memory_used_in_bytes = data.get_uint64 ();

        if (memory_used_in_bytes < 9e2)
            renderer.set_property ("text", (uint64.FORMAT + " B").printf (memory_used_in_bytes));
        else if (memory_used_in_bytes < 9e5)
            renderer.set_property ("text", "%.1f KB".printf (memory_used_in_bytes / 1e3));
        else if (memory_used_in_bytes < 9e8)
            renderer.set_property ("text", "%.1f MB".printf (memory_used_in_bytes / 1e6));
        else if (memory_used_in_bytes < 9e11)
            renderer.set_property ("text", "%.1f GB".printf (memory_used_in_bytes / 1e9));
        else
            renderer.set_property ("text", "%.1f TB".printf (memory_used_in_bytes / 1e12));
    }

    public void cell_percentage_data (Gtk.CellLayout layout, Gtk.CellRenderer renderer, Gtk.TreeModel model, Gtk.TreeIter iter, MemoryViewModel.Column column) {
        Value data;
        model.get_value (iter, column, out data);

        renderer.set_property ("text", "%.1f".printf (data.get_double ()));
    }
}
