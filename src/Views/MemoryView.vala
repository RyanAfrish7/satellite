public class Satellite.MemoryView : Gtk.TreeView {
    Gtk.TreeViewColumn column_pid;
    Gtk.TreeViewColumn column_command_line;
    Gtk.TreeViewColumn column_memory_usage;
    Gtk.TreeViewColumn column_memory_usage_in_percentage;
    Gtk.TreeViewColumn column_user;

    public MemoryView () {
        {
            var renderer = text_column_renderer ();

            column_command_line = new Gtk.TreeViewColumn ();
            column_command_line.title = get_column_name (MemoryViewModel.Column.COMMAND_LINE);
            column_command_line.expand = true;
            column_command_line.pack_start (renderer, false);
            column_command_line.add_attribute (renderer, "text", MemoryViewModel.Column.COMMAND_LINE);
            
            insert_column (column_command_line, -1);
        }
        
        {
            var renderer = numeric_column_renderer ();

            column_memory_usage = new Gtk.TreeViewColumn ();
            column_memory_usage.title = get_column_name (MemoryViewModel.Column.MEMORY_USAGE);
            column_memory_usage.expand = false;
            column_memory_usage.min_width = 120;
            column_memory_usage.sort_column_id = MemoryViewModel.Column.MEMORY_USAGE;
            column_memory_usage.pack_start (renderer, false);
            column_memory_usage.set_cell_data_func (renderer, (layout, renderer, model, iter) => 
                render_bytes(layout, renderer as Gtk.CellRendererText, model, iter, MemoryViewModel.Column.MEMORY_USAGE));

            insert_column (column_memory_usage, -1);
        }

        {
            var renderer = numeric_column_renderer ();

            column_memory_usage_in_percentage = new Gtk.TreeViewColumn ();
            column_memory_usage_in_percentage.title = get_column_name (MemoryViewModel.Column.MEMORY_USAGE_IN_PERCENTAGE);
            column_memory_usage_in_percentage.expand = false;
            column_memory_usage_in_percentage.min_width = 120;
            column_memory_usage_in_percentage.sort_column_id = MemoryViewModel.Column.MEMORY_USAGE_IN_PERCENTAGE;
            column_memory_usage_in_percentage.pack_start (renderer, false);
            column_memory_usage_in_percentage.set_cell_data_func (renderer, (layout, renderer, model, iter) => 
                render_percentage(layout, renderer as Gtk.CellRendererText, model, iter, MemoryViewModel.Column.MEMORY_USAGE_IN_PERCENTAGE));

            insert_column (column_memory_usage_in_percentage, -1);
        }
        
        {
            var renderer = numeric_column_renderer ();
            
            column_pid = new Gtk.TreeViewColumn ();
            column_pid.title = get_column_name (MemoryViewModel.Column.PID);
            column_pid.expand = false;
            column_pid.min_width = 120;
            column_pid.pack_start (renderer, false);
            column_pid.add_attribute (renderer, "text", MemoryViewModel.Column.PID);

            insert_column (column_pid, -1);
        }
        
        {
            var renderer = text_column_renderer ();

            column_user = new Gtk.TreeViewColumn ();
            column_user.title = get_column_name (MemoryViewModel.Column.USER);
            column_user.expand = true;
            column_user.pack_start (renderer, false);
            column_user.add_attribute (renderer, "text", MemoryViewModel.Column.USER);

            insert_column (column_user, -1);
        }

        set_search_column (MemoryViewModel.Column.COMMAND_LINE);
        set_search_equal_func (contains_func);
    }

    public string get_column_name (MemoryViewModel.Column column) {
        switch (column) {
            case COMMAND_LINE: return _("Command line");
            case MEMORY_USAGE: return _("Memory used");
            case MEMORY_USAGE_IN_PERCENTAGE: return _("% Memory");
            case PID: return _("PID");
            case USER: return _("User");
            case UID: return _("UID");
            default: assert_not_reached();
        }
    }
}
