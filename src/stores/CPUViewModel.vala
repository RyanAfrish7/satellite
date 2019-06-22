public class Satellite.CPUViewModel : Satellite.AbstractModel<int> {
    ProcessInfoProvider process_info_provider;
    ProcessCPUUsageProvider process_cpu_usage_provider;

    public enum Column {
        PID,
        COMMAND_LINE,
        UID,
        USER,
        CPU_USAGE
    }

    public CPUViewModel (ProcessInfoProvider process_info_provider, ProcessCPUUsageProvider process_cpu_usage_provider) {
        set_column_types (new Type[] {
            typeof (int),       // pid
            typeof (string),    // command_line
            typeof (int),       // uid
            typeof (string),    // username
            typeof (double)      // cpu_usage
        });

        this.process_info_provider = process_info_provider;
        this.process_cpu_usage_provider = process_cpu_usage_provider;
    }

    public void refresh () {
        // TODO: restructure fetch_all api to return Map of pids to ProcessInfo
        Gee.Set<ProcessInfo> process_info_list = process_info_provider.fetch_all ();
        Gee.Set<int> pids = new Gee.HashSet<int> ();

        foreach (ProcessInfo process_info in process_info_list) {
            pids.add(process_info.pid);
        }

        Gee.Map<int, ProcessCPUUsage> pid_cpu_usage_map = process_cpu_usage_provider.fetch_cpu_usages (pids);

        foreach (ProcessInfo process_info in process_info_list) {
            Gtk.TreeIter iter = get_or_append_row (process_info.pid);
            set (iter,
                Column.PID, process_info.pid,
                Column.COMMAND_LINE, process_info.command_line,
                Column.UID, process_info.uid,
                Column.USER, process_info.user_name,
                Column.CPU_USAGE, pid_cpu_usage_map.get (process_info.pid).cpu_usage,
                -1
            );
            pids.add(process_info.pid);
        }

        // remove processes which are no longer alive     
        retain_by_ids (pids);
    }
}
