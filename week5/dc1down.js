let rsconf = rs.conf();
rsconf.members[5].priority = rsconf.members[4].priority;
rsconf.members[5].hidden = false;
rsconf.members.splice(0, 3);

rs.reconfig(rsconf, { force: true });
