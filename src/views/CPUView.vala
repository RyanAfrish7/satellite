public class Satellite.CPUView : Gtk.TreeView {
    Gtk.TreeViewColumn column_pid;
    Gtk.TreeViewColumn column_command_line;
    Gtk.TreeViewColumn column_cpu_usage;
    Gtk.TreeViewColumn column_user;

    public CPUView () {
        {
            var renderer = text_column_renderer ();

            column_command_line = new Gtk.TreeViewColumn ();
            column_command_line.title = get_column_name (CPUViewModel.Column.COMMAND_LINE);
            column_command_line.expand = true;
            column_command_line.pack_start (renderer, false);
            column_command_line.add_attribute (renderer, "text", CPUViewModel.Column.COMMAND_LINE);
            
            insert_column (column_command_line, -1);
        }

        {
            var renderer = numeric_column_renderer ();

            column_cpu_usage = new Gtk.TreeViewColumn ();
            column_cpu_usage.title = get_column_name (CPUViewModel.Column.CPU_USAGE);
            column_cpu_usage.expand = false;
            column_cpu_usage.min_width = 120;
            column_cpu_usage.sort_column_id = CPUViewModel.Column.CPU_USAGE;
            column_cpu_usage.pack_start (renderer, false);
            column_cpu_usage.set_cell_data_func (renderer, (layout, renderer, model, iter) => 
                render_percentage (layout, renderer as Gtk.CellRendererText, model, iter, CPUViewModel.Column.CPU_USAGE));

            insert_column (column_cpu_usage, -1);
        }

        {
            var renderer = numeric_column_renderer ();

            column_pid = new Gtk.TreeViewColumn ();
            column_pid.title = get_column_name (CPUViewModel.Column.PID);
            column_pid.expand = false;
            column_pid.min_width = 120;
            column_pid.pack_start (renderer, false);
            column_pid.add_attribute (renderer, "text", CPUViewModel.Column.PID);

            insert_column (column_pid, -1);
        }

        {
            var renderer = text_column_renderer ();

            column_user = new Gtk.TreeViewColumn ();
            column_user.title = get_column_name (CPUViewModel.Column.USER);
            column_user.expand = true;
            column_user.pack_start (renderer, false);
            column_user.add_attribute (renderer, "text", CPUViewModel.Column.USER);

            insert_column (column_user, -1);
        }

        set_search_column (CPUViewModel.Column.COMMAND_LINE);
        set_search_equal_func (contains_func);
    }

    public string get_column_name (CPUViewModel.Column column) {
        switch (column) {
            case COMMAND_LINE: return "Command line";
            case CPU_USAGE: return "% CPU";
            case PID: return "PID";
            case USER: return "User";
            case UID: return "UID";
            default: assert_not_reached();
        }
    }
}
