public class Satellite.CPUView : Gtk.TreeView {
    Gtk.TreeViewColumn column_pid;
    Gtk.TreeViewColumn column_command_line;
    Gtk.TreeViewColumn column_cpu_usage;
    Gtk.TreeViewColumn column_user;

    Gtk.TreeStore store;

    public CPUView () {
        var text_renderer = new Gtk.CellRendererText();
        text_renderer.ellipsize = Pango.EllipsizeMode.END;

        column_command_line = new Gtk.TreeViewColumn ();
        column_command_line.title = get_column_name (CPUViewModel.Column.COMMAND_LINE);
        column_command_line.expand = true;
        column_command_line.pack_start (text_renderer, false);
        column_command_line.add_attribute (text_renderer, "text", CPUViewModel.Column.COMMAND_LINE);
        
        insert_column (column_command_line, -1);
        
        column_cpu_usage = new Gtk.TreeViewColumn ();
        column_cpu_usage.title = get_column_name (CPUViewModel.Column.CPU_USAGE);
        column_cpu_usage.expand = false;
        column_cpu_usage.min_width = 120;
        column_cpu_usage.sort_column_id = CPUViewModel.Column.CPU_USAGE;
        column_cpu_usage.pack_start (text_renderer, false);
        column_cpu_usage.set_cell_data_func (text_renderer, (layout, renderer, model, iter) => 
            cell_percentage_data(layout, renderer, model, iter, CPUViewModel.Column.CPU_USAGE));

        insert_column (column_cpu_usage, -1);
        
        column_pid = new Gtk.TreeViewColumn ();
        column_pid.title = get_column_name (CPUViewModel.Column.PID);
        column_pid.expand = false;
        column_pid.min_width = 120;
        column_pid.pack_start (text_renderer, false);
        column_pid.add_attribute (text_renderer, "text", CPUViewModel.Column.PID);

        insert_column (column_pid, -1);
        
        column_user = new Gtk.TreeViewColumn ();
        column_user.title = get_column_name (CPUViewModel.Column.USER);
        column_user.expand = true;
        column_user.pack_start (text_renderer, false);
        column_user.add_attribute (text_renderer, "text", CPUViewModel.Column.USER);

        insert_column (column_user, -1);

        set_model (store);
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

    public void cell_percentage_data (Gtk.CellLayout layout, Gtk.CellRenderer renderer, Gtk.TreeModel model, Gtk.TreeIter iter, CPUViewModel.Column column) {
        Value data;
        model.get_value (iter, column, out data);

        renderer.set_property ("text", "%.1f".printf (data.get_double ()));
    }
}
