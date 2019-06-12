public class Satellite.ProcessInfoProvider {
    public Gee.Set<Satellite.ProcessInfo> fetch_all () {
        GTop.ProcList proclist;
        int[] pids = GTop.get_proclist (out proclist, GTop.GLIBTOP_KERN_PROC_ALL, -1);
        
        Gee.Set<Satellite.ProcessInfo> list = new Gee.HashSet<Satellite.ProcessInfo>();

        for (int i = 0; i < proclist.number; i += 1) {
            int pid = pids[i];

            // Get user id
            GTop.ProcUid proc_uid;
            GTop.get_proc_uid (out proc_uid, pid);
            int uid = proc_uid.uid;

            // Get user name
            unowned Posix.Passwd passwd = Posix.getpwuid (uid);
            string name = passwd.pw_name;

            // Get command line
            GTop.ProcArgs proc_args;
            string command_line = GTop.get_proc_args (out proc_args, pid, 1024).strip();

            // Removing the apps with empty command line. What are they??
            if (command_line.length == 0) continue;

            list.add (new Satellite.ProcessInfo(
                pid,
                command_line,
                proc_uid.uid,
                name
            ));
        }

        return list;
    }
}
