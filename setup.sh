#!/bin/bash
echo "what email do you want to use for job notifications (i.e., for -M you@domain.tld)?"
read hpc_email
echo "what notifications do you want (i.e., for -m; use some of [abe] or 'n')?"
read hpc_notes
echo "what is the working directory (i.e., cd /to/where/on/comp at script start)?"
read hpc_wd
echo "check $1 to confirm settings."
cat > $1 <<EOF
#!/bin/usr/bash
export PBSEMAIL=$hpc_email
export PBSNOTIFICATIONS=$hpc_notes
export PBSWD=$hpc_wd
EOF
chmod +x $1